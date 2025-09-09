# terraform-upcloud-k3s

Terraform module for deploying a **K3s Kubernetes cluster** on [UpCloud](https://upcloud.com/) with:

- **1 master** + configurable **worker nodes**
- **UpCloud Load Balancer**
- **Automatic kubeconfig export**
- **Traefik ingress controller** (via Helm)
- **cert-manager** (via Helm)
- Secure **SSH key management**

---

## 🚀 Features

- Provisions **Ubuntu servers** in UpCloud.
- Installs **K3s** automatically via `cloud-init`.
- Configures a **master node** and adds workers with **join tokens**.
- Creates an **UpCloud Load Balancer** in front of the cluster.
- Fetches and saves **kubeconfig.yaml** locally for `kubectl`.
- Deploys **Traefik** ingress controller.
- Deploys **cert-manager** with CRDs.

---

## 📂 Module Structure

terraform-upcloud-k3s/
├── main.tf # Helm deployments (Traefik + cert-manager)
├── cluster.tf # Cluster creation (UpCloud + K3s)
├── variables.tf # Input variables
├── outputs.tf # Module outputs
├── versions.tf # Provider requirements
├── templates/
│ └── worker-cloudinit.yaml.tmpl # Worker cloud-init template
└── examples/
└── simple/
├── main.tf
└── variables.tf


---

## ⚡ Usage

```hcl
module "upcloud_k3s" {
  source = "github.com/your-org/terraform-upcloud-k3s"

  upcloud_username     = var.upcloud_username
  upcloud_password     = var.upcloud_password

  ssh_public_key       = "ssh-rsa AAAAB3Nz... user@host"
  ssh_private_key_file = "~/.ssh/id_rsa"

  cluster_name = "my-k3s"
  node_count   = 3
  node_plan    = "2xCPU-4GB"
  zone         = "de-fra1"
}