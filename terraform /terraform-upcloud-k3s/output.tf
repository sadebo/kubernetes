output "master_ip" {
  value       = upcloud_server.master.network_interface[0].ip_address
  description = "Public IP of the master node"
}

output "worker_ips" {
  value       = [for w in upcloud_server.workers : w.network_interface[0].ip_address]
  description = "Public IPs of worker nodes"
}

output "kubeconfig_file" {
  value       = "${path.module}/kubeconfig.yaml"
  description = "Path to kubeconfig file"
}

output "traefik_status" {
  value       = helm_release.traefik.status
}

output "cert_manager_status" {
  value       = helm_release.cert_manager.status
}
