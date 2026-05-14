terraform {
  required_version = ">= 1.5.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.202.0"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.iam_token
}

locals {
  prefix       = "ycsec-mks-cloud-run"
  network_cidr = var.network_cidr
}

resource "yandex_vpc_network" "mks" {
  name        = "${local.prefix}-network"
  description = "YCSEC Managed Kubernetes controlled cloud-run network"
  folder_id   = var.folder_id
}

resource "yandex_vpc_subnet" "mks" {
  name           = "${local.prefix}-subnet"
  description    = "YCSEC Managed Kubernetes controlled cloud-run subnet"
  folder_id      = var.folder_id
  zone           = var.zone
  network_id     = yandex_vpc_network.mks.id
  v4_cidr_blocks = [local.network_cidr]
}

resource "yandex_iam_service_account" "cluster" {
  name        = "${local.prefix}-cluster-sa"
  description = "YCSEC Managed Kubernetes cluster service account for controlled baseline/remediation run"
  folder_id   = var.folder_id
}

resource "yandex_iam_service_account" "nodes" {
  name        = "${local.prefix}-nodes-sa"
  description = "YCSEC Managed Kubernetes node service account for controlled baseline/remediation run"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "cluster_agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "cluster_vpc_admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "nodes_registry_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.nodes.id}"
}

resource "yandex_kubernetes_cluster" "mks" {
  #checkov:skip=CKV_YC_5:Controlled evidence cluster requires public API access for short validation from isolated operator workstation.
  #checkov:skip=CKV_YC_10:Short-lived evidence cluster stores no persistent application secrets; encryption tradeoff is documented as a budget/runtime exception.
  #checkov:skip=CKV_YC_14:Cluster-level security group hardening is documented as a production recommendation; this run focuses on admission/policy evidence.
  name        = var.cluster_name
  description = "YCSEC short-lived Managed Kubernetes baseline/remediation evidence cluster"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.mks.id

  service_account_id      = yandex_iam_service_account.cluster.id
  node_service_account_id = yandex_iam_service_account.nodes.id
  network_policy_provider = "CALICO"
  release_channel         = "REGULAR"

  master {
    public_ip = true

    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.mks.id
    }
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.cluster_agent,
    yandex_resourcemanager_folder_iam_member.cluster_vpc_admin,
    yandex_resourcemanager_folder_iam_member.nodes_registry_puller
  ]
}

resource "yandex_kubernetes_node_group" "workers" {
  #checkov:skip=CKV_YC_6:Short-lived worker nodes use public NAT for controlled image pull and validation, then are destroyed.
  #checkov:skip=CKV_YC_15:Node group security group hardening is documented as a production recommendation; this run is bounded by cleanup evidence.
  name        = "${local.prefix}-workers"
  description = "YCSEC short-lived worker node group for baseline/remediation evidence"
  cluster_id  = yandex_kubernetes_cluster.mks.id

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }

  instance_template {
    platform_id = var.node_platform_id

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.mks.id]
    }

    resources {
      cores  = var.node_cores
      memory = var.node_memory
    }

    boot_disk {
      type = var.node_disk_type
      size = var.node_disk_size
    }

    scheduling_policy {
      preemptible = var.node_preemptible
    }
  }
}
