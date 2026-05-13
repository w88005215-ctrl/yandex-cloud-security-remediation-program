locals {
  labels = {
    project = "ycsec"
    phase   = "phase-11-smoke"
    owner   = "local-validation"
  }
}

resource "yandex_vpc_network" "smoke" {
  name        = "${var.name_prefix}-network"
  description = "Temporary YCSEC smoke-run network"
  labels      = local.labels
}

resource "yandex_vpc_subnet" "smoke" {
  name           = "${var.name_prefix}-subnet"
  description    = "Temporary YCSEC smoke-run subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.smoke.id
  v4_cidr_blocks = ["10.60.0.0/24"]
  labels         = local.labels
}

resource "yandex_iam_service_account" "cluster" {
  name        = "${var.name_prefix}-cluster-sa"
  description = "Temporary service account for YCSEC Kubernetes smoke cluster"
}

resource "yandex_iam_service_account" "nodes" {
  name        = "${var.name_prefix}-nodes-sa"
  description = "Temporary service account for YCSEC Kubernetes smoke nodes"
}

resource "yandex_resourcemanager_folder_iam_member" "cluster_agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "cluster_vpc_public_admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "nodes_image_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.nodes.id}"
}

resource "yandex_kubernetes_cluster" "smoke" {
  name        = "${var.name_prefix}-cluster"
  description = "Temporary YCSEC smoke-run Managed Kubernetes cluster"
  network_id  = yandex_vpc_network.smoke.id

  master {
    version   = var.kubernetes_version
    public_ip = true

    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.smoke.id
    }
  }

  service_account_id      = yandex_iam_service_account.cluster.id
  node_service_account_id = yandex_iam_service_account.nodes.id
  release_channel         = "STABLE"
  labels                  = local.labels

  depends_on = [
    yandex_resourcemanager_folder_iam_member.cluster_agent,
    yandex_resourcemanager_folder_iam_member.cluster_vpc_public_admin,
    yandex_resourcemanager_folder_iam_member.nodes_image_puller
  ]
}

resource "yandex_kubernetes_node_group" "smoke" {
  cluster_id  = yandex_kubernetes_cluster.smoke.id
  name        = "${var.name_prefix}-node-group"
  description = "Temporary YCSEC smoke-run node group"
  version     = var.kubernetes_version
  labels      = local.labels

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.smoke.id]
      nat        = false
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  depends_on = [
    yandex_kubernetes_cluster.smoke
  ]
}
