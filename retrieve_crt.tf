resource "null_resource" "fetch_worker_cert" {
  provisioner "local-exec" {
    command = <<EOT
      # Define install directory
      INSTALL_DIR="/usr/local/bin"
      if [ ! -w "$INSTALL_DIR" ]; then
        INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$INSTALL_DIR"
        export PATH="$INSTALL_DIR:$PATH"
      fi

      SPACELIFT_CLI="$INSTALL_DIR/spacelift-launcher"

      # Install Spacelift CLI if not found
      if [ ! -f "$SPACELIFT_CLI" ]; then
        echo "⚠️ Spacelift CLI not found. Installing..."
        wget -O "$SPACELIFT_CLI" https://downloads.spacelift.io/spacelift-launcher-x86_64
        chmod +x "$SPACELIFT_CLI"
      fi

      # Verify Spacelift CLI exists
      if [ ! -f "$SPACELIFT_CLI" ]; then
        echo "❌ Error: Spacelift CLI installation failed."
        exit 1
      fi

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
