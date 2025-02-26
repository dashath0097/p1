resource "null_resource" "fetch_worker_cert" {
  provisioner "local-exec" {
    command = <<EOT
      # Ensure Spacelift CLI is installed
      INSTALL_DIR="/usr/local/bin"
      if [ ! -f "$INSTALL_DIR/spacelift-launcher" ]; then
        echo "Installing Spacelift CLI..."
        wget -O "$INSTALL_DIR/spacelift-launcher" https://downloads.spacelift.io/spacelift-launcher-x86_64
        chmod +x "$INSTALL_DIR/spacelift-launcher"
      fi

      # Fetch Worker Certificate
      SPACELIFT_ACCESS_KEY=${var.spacelift_access_key} \
      SPACELIFT_SECRET_KEY=${var.spacelift_secret_key} \
      "$INSTALL_DIR/spacelift-launcher" worker-pool cert get \
      --worker-pool ${spacelift_worker_pool.private_workers.id} \
      --output ${path.module}/worker.crt
    EOT
  }

  depends_on = [null_resource.upload_csr]
}

# Store the actual worker certificate contents
resource "local_file" "worker_crt_file" {
  content  = file("${path.module}/worker.crt")  # Store actual certificate
  filename = "${path.module}/worker.crt"

  depends_on = [null_resource.fetch_worker_cert]
}

output "worker_cert" {
  value     = file("${path.module}/worker.crt")  # Output actual certificate content
  sensitive = true
}
