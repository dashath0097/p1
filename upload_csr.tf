resource "null_resource" "upload_csr" {
  provisioner "local-exec" {
    command = <<EOT
      # Ensure /usr/local/bin is in the PATH
      export PATH="/usr/local/bin:$PATH"

      # Check if spacelift-launcher exists before running
      if [ ! -f /usr/local/bin/spacelift-launcher ]; then
        echo "Error: spacelift-launcher not found! Installing..."
        sudo wget -O /usr/local/bin/spacelift-launcher https://downloads.spacelift.io/spacelift-launcher-x86_64
        sudo chmod +x /usr/local/bin/spacelift-launcher
      fi

      # Run the CSR upload command
      SPACELIFT_ACCESS_KEY=${var.spacelift_access_key} \
      SPACELIFT_SECRET_KEY=${var.spacelift_secret_key} \
      /usr/local/bin/spacelift-launcher worker-pool csr upload \
      --worker-pool ${spacelift_worker_pool.private_workers.id} \
      --csr-file worker.csr
    EOT
  }
}
