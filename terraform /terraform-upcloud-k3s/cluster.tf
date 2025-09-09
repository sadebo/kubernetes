# ============================
# Master node
# ============================
resource "upcloud_server" "master" {
  zone     = var.zone
  title    = "${var.cluster_name}-master"
  hostname = "${var.cluster_name}-master.local"
  plan     = var.node_plan

  login {
    user = "root"
    keys = [var.ssh_public_key]
  }

  network_interface {
    type = "public"
  }

  template {
    storage = var.template_storage_uuid
    size    = 50
    title   = "${var.cluster_name}-master-disk"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - curl
  EOF
}

# ============================
# Install K3s on master
# ============================
resource "null_resource" "install_master" {
  depends_on = [upcloud_server.master]

  connection {
    type        = "ssh"
    host        = upcloud_server.master.network_interface[0].ip_address
    user        = "root"
    private_key = file(var.ssh_private_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "echo '🚀 Installing K3s master...'",
      "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=\"server --cluster-init --bind-address 0.0.0.0 --advertise-address ${upcloud_server.master.network_interface[0].ip_address} --tls-san ${upcloud_server.master.network_interface[0].ip_address}\" sh -",
      "systemctl enable k3s && systemctl start k3s",
    ]
  }
}

# ============================
# Worker nodes
# ============================
resource "upcloud_server" "workers" {
  count    = max(var.node_count - 1, 0)
  zone     = var.zone
  title    = "${var.cluster_name}-worker-${count.index}"
  hostname = "${var.cluster_name}-worker-${count.index}.local"
  plan     = var.node_plan

  login {
    user = "root"
    keys = [var.ssh_public_key]
  }

  network_interface {
    type = "public"
  }

  template {
    storage = var.template_storage_uuid
    size    = 50
    title   = "${var.cluster_name}-worker-${count.index}-disk"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - curl
      - sshpass
  EOF
}

# ============================
# Fetch kubeconfig
# ============================
resource "null_resource" "fetch_kubeconfig" {
  depends_on = [null_resource.install_master]

  provisioner "local-exec" {
    command = <<EOT
    for i in {1..60}; do
      ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key_file} root@${upcloud_server.master.network_interface[0].ip_address} \
        'cat /etc/rancher/k3s/k3s.yaml' > ${path.module}/kubeconfig.yaml && break
      echo "⏳ Waiting for kubeconfig... retrying in 10s"
      sleep 10
    done
    if [ ! -s ${path.module}/kubeconfig.yaml ]; then
      echo "❌ Failed to fetch kubeconfig"
      exit 1
    fi
    # Patch kubeconfig to use master public IP
    sed -i.bak "s/127.0.0.1/${upcloud_server.master.network_interface[0].ip_address}/g" ${path.module}/kubeconfig.yaml
    sed -i.bak "s/0.0.0.0/${upcloud_server.master.network_interface[0].ip_address}/g" ${path.module}/kubeconfig.yaml
    echo "✅ Kubeconfig fetched and patched"
    EOT
  }
}
