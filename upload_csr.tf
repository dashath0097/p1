resource "null_resource" "upload_csr" {
  provisioner "local-exec" {
    command = <<EOT
      # Define install directory
      INSTALL_DIR="$HOME/.local/bin"
      mkdir -p "$INSTALL_DIR"

      # Ensure $INSTALL_DIR is in the PATH
      export PATH="$INSTALL_DIR:$PATH"

      # Check if spacelift-launcher exists before running
      if [ ! -f "$INSTALL_DIR/spacelift-launcher" ]; then
        echo "Error: spacelift-launcher not found! Installing..."
        wget -O "$INSTALL_DIR/spacelift-launcher" https://downloads.spacelift.io/spacelift-launcher-x86_64
        chmod +x "$INSTALL_DIR/spacelift-launcher"
      fi

      # Run the CSR upload command
      SPACELIFT_ACCESS_KEY=${var.spacelift_access_key} \
      SPACELIFT_SECRET_KEY=${var.spacelift_secret_key} \
      "$INSTALL_DIR/spacelift-launcher" worker-pool csr upload \
      --worker-pool ${spacelift_worker_pool.private_workers.id} \
      --csr-file worker.csr
    EOT
  }
}
