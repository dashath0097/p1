# Fetch the worker certificate from Spacelift API
resource "null_resource" "fetch_worker_cert" {
  provisioner "local-exec" {
    command = <<EOT
      INSTALL_DIR="$HOME/.local/bin"
      SPACELIFT_CLI="$INSTALL_DIR/spacelift-launcher"

      # Ensure Spacelift CLI is installed
      if [ ! -f "$SPACELIFT_CLI" ]; then
        echo "Error: Spacelift CLI not found at $SPACELIFT_CLI"
        exit 1
      fi

      # Ensure Spacelift CLI is in PATH
      export PATH="$INSTALL_DIR:$PATH"

      # Fetch worker certificate using full path
      SPACELIFT_ACCESS_KEY=${var.spacelift_access_key} \
      SPACELIFT_SECRET_KEY=${var.spacelift_secret_key} \
      "$SPACELIFT_CLI" worker-pool cert get \
      --worker-pool ${spacelift_worker_pool.private_workers.id} \
      --output ${path.module}/worker.crt

      echo "Worker certificate successfully fetched."
    EOT
  }

  depends_on = [null_resource.install_spacelift_cli] # Ensure Spacelift CLI is installed
}

# Ensure the worker certificate is saved correctly
resource "local_file" "worker_crt_file" {
  content  = fileexists("${path.module}/worker.crt") ? file("${path.module}/worker.crt") : "Certificate not found"
  filename = "${path.module}/worker.crt"

  depends_on = [null_resource.fetch_worker_cert]
}

# Output the certificate content securely
output "worker_cert" {
  value     = fileexists("${path.module}/worker.crt") ? file("${path.module}/worker.crt") : "No certificate found"
  sensitive = true
}
