resource "null_resource" "fetch_worker_cert" {
  provisioner "local-exec" {
    command = <<EOT
      # Define install directory
      INSTALL_DIR="$HOME/.local/bin"
      mkdir -p "$INSTALL_DIR"

      # Ensure Spacelift CLI is installed and executable
      SPACELIFT_CLI="$INSTALL_DIR/spacelift-launcher"
      
      if [ ! -f "$SPACELIFT_CLI" ]; then
        echo "⚠️ Spacelift CLI not found. Installing..."
        wget -O "$SPACELIFT_CLI" https://downloads.spacelift.io/spacelift-launcher-x86_64
        if [ $? -ne 0 ]; then
          echo "❌ Error: Failed to download Spacelift CLI"
          exit 1
        fi
        chmod +x "$SPACELIFT_CLI"
      fi

      # Ensure CLI is in PATH and persist it
      export PATH="$INSTALL_DIR:$PATH"
      echo "export PATH=$INSTALL_DIR:\$PATH" >> ~/.bashrc

      # Reload bash profile
      source ~/.bashrc

      # Verify Spacelift CLI is working
      "$SPACELIFT_CLI" version || { echo "❌ Error: Spacelift CLI is not executable"; exit 1; }

      # Export Spacelift API credentials
      export SPACELIFT_ACCESS_KEY="${var.spacelift_access_key}"
      export SPACELIFT_SECRET_KEY="${var.spacelift_secret_key}"

      # Fetch worker certificate
      "$SPACELIFT_CLI" worker-pool cert get \
      --worker-pool "${spacelift_worker_pool.private_workers.id}" \
      --output "${path.module}/worker.crt"

      if [ ! -f "${path.module}/worker.crt" ]; then
        echo "❌ Error: Worker certificate not fetched"
        exit 1
      fi

      echo "✅ Worker certificate successfully fetched."
    EOT
  }

  depends_on = [null_resource.install_spacelift_cli]
}

resource "local_file" "worker_crt_file" {
  content  = fileexists("${path.module}/worker.crt") ? file("${path.module}/worker.crt") : ""
  filename = "${path.module}/worker.crt"

  depends_on = [null_resource.fetch_worker_cert]
}

output "worker_cert" {
  value     = fileexists("${path.module}/worker.crt") ? file("${path.module}/worker.crt") : "No certificate found"
  sensitive = true
}
