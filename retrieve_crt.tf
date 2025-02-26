resource "null_resource" "fetch_worker_cert" {
  provisioner "local-exec" {
    command = <<EOT
      # Determine Spacelift CLI install location
      INSTALL_DIR="/usr/local/bin"
      if [ ! -f "$INSTALL_DIR/spacelift-launcher" ]; then
        INSTALL_DIR="$HOME/.local/bin"
      fi

      SPACELIFT_CLI="$INSTALL_DIR/spacelift-launcher"

      # Verify Spacelift CLI exists
      if [ ! -f "$SPACELIFT_CLI" ]; then
        echo "❌ Error: Spacelift CLI not found in expected locations."
        exit 1
      fi

      # Ensure CLI is in PATH
      export PATH="$INSTALL_DIR:$PATH"

      # Debugging - Print CLI version
      "$SPACELIFT_CLI" version || { echo "❌ Error: Spacelift CLI is not executable"; exit 1; }

      # Fetch worker certificate
      SPACELIFT_ACCESS_KEY=${var.spacelift_access_key} \
      SPACELIFT_SECRET_KEY=${var.spacelift_secret_key} \
      "$SPACELIFT_CLI" worker-pool cert get \
      --worker-pool ${spacelift_worker_pool.private_workers.id} \
      --output ${path.module}/worker.crt

      echo "✅ Worker certificate successfully fetched."
    EOT
  }

  depends_on = [null_resource.install_spacelift_cli]
}

resource "local_file" "worker_crt_file" {
  content  = fileexists("${path.module}/worker.crt") ? file("${path.module}/worker.crt") : "No certificate found"
  filename = "${path.module}/worker.crt"

  depends_on = [null_resource.fetch_worker_cert]
}

output "worker_cert" {
  value     = fileexists("${path.module}/worker.crt") ? file("${path.module}/worker.crt") : "No certificate found"
  sensitive = true
}
