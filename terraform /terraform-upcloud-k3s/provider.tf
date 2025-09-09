# provider "upcloud" {
#   username = var.upcloud_username
#   password = var.upcloud_password
# }

# provider "tls" {}
# provider "local" {}

# provider "kubernetes" {
#   config_path = "${path.module}/kubeconfig.yaml"
# }

# provider "helm" {
#   kubernetes {
#     config_path = "${path.module}/kubeconfig.yaml"
#   }
# }

provider "upcloud" {
  username = var.upcloud_username
  password = var.upcloud_password
}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig.yaml"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig.yaml"
  }
}
provider "tls" {}
provider "local" {} 