variable "upcloud_username" {
  type        = string
  description = "UpCloud API username"
}

variable "upcloud_password" {
  type        = string
  description = "UpCloud API password"
  sensitive   = true
}

variable "zone" {
  type        = string
  default     = "de-fra1"
  description = "UpCloud zone for all resources"
}

variable "cluster_name" {
  type        = string
  default     = "demo-cluster"
  description = "Cluster name prefix"
}

variable "node_count" {
  type        = number
  default     = 3
  description = "Total number of nodes (1 master + n-1 workers)"
}

variable "node_plan" {
  type        = string
  default     = "2xCPU-4GB"
  description = "UpCloud plan size for nodes"
}

variable "ssh_public_key" {
  type        = string
  description = "Your SSH public key string (ssh-rsa ...)"
}

variable "ssh_private_key_file" {
  type        = string
  description = "Path to your SSH private key file"
  default     = "~/.ssh/upcloud_rsa"
}

variable "template_storage_uuid" {
  type        = string
  description = <<EOT
UUID of the OS template to use for servers.
Run `upctl storage list --template` to find valid UUIDs for your zone.
For Ubuntu 22.04 LTS (Jammy), a typical example is:
01000000-0000-4000-8000-000030200200
EOT
  default     = "01000000-0000-4000-8000-000030200200"
}
