module "upcloud_k3s" {
  source = "../.."   # path to module root

  upcloud_username     = var.upcloud_username
  upcloud_password     = var.upcloud_password
  ssh_public_key       = file("~/.ssh/upcloud_rsa.pub")
  ssh_private_key_file = "~/.ssh/upcloud_rsa"

  cluster_name          = "my-k3s"
  node_count            = 3
  node_plan             = "2xCPU-4GB"
  zone                  = "de-fra1"
  template_storage_uuid = "01000000-0000-4000-8000-000030200200" # Ubuntu 22.04
}
