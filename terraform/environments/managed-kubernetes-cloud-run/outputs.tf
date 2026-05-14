output "cluster_id" {
  description = "Managed Kubernetes cluster ID."
  value       = yandex_kubernetes_cluster.mks.id
}

output "cluster_name" {
  description = "Managed Kubernetes cluster name."
  value       = yandex_kubernetes_cluster.mks.name
}

output "node_group_id" {
  description = "Managed Kubernetes node group ID."
  value       = yandex_kubernetes_node_group.workers.id
}

output "network_id" {
  description = "Temporary VPC network ID."
  value       = yandex_vpc_network.mks.id
}

output "subnet_id" {
  description = "Temporary VPC subnet ID."
  value       = yandex_vpc_subnet.mks.id
}
