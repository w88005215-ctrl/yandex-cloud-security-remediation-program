output "cluster_id" {
  value       = yandex_kubernetes_cluster.smoke.id
  description = "Temporary smoke-run cluster ID."
}

output "cluster_name" {
  value       = yandex_kubernetes_cluster.smoke.name
  description = "Temporary smoke-run cluster name."
}

output "network_id" {
  value       = yandex_vpc_network.smoke.id
  description = "Temporary smoke-run network ID."
}

output "subnet_id" {
  value       = yandex_vpc_subnet.smoke.id
  description = "Temporary smoke-run subnet ID."
}
