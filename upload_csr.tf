resource "null_resource" "install_spacelift_cli" {
  provisioner "local-exec" {
    command = "sh ${path.module}/install_spacelift.sh"
  }
}

resource "null_resource" "upload_csr" {
  provisioner "local-exec" {
    command = <<EOT
      export PATH="$HOME/.local/bin:$PATH"
      SPACELIFT_ACCESS_KEY=${var.spacelift_access_key} \
      SPACELIFT_SECRET_KEY=${var.spacelift_secret_key} \
      $HOME/.local/bin/spacelift worker-pool csr upload \
      --worker-pool ${spacelift_worker_pool.private_workers.id} \
      --csr-file worker.csr
    EOT
  }

  depends_on = [null_resource.install_spacelift_cli] # Ensure CLI is installed first
}
