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

      # Create Spacelift API credentials JSON file
      CREDENTIALS_FILE="$HOME/.spacelift-api-credentials.json"
      echo '{
        "access_key": "${var.spacelift_access_key}",
        "secret_key": "${var.spacelift_secret_key}"
      }' > "$CREDENTIALS_FILE"

      # Set the API credentials file environment variable
      export SPACELIFT_API_CREDENTIALS_FILE="$CREDENTIALS_FILE"

      # Run the CSR upload command
      "$INSTALL_DIR/spacelift-launcher" worker-pool csr upload \
      --worker-pool ${spacelift_worker_pool.private_workers.id} \
      --csr-file worker.csr
    EOT
  }
}
