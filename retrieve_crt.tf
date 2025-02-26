# Fetch the worker certificate from Spacelift API
resource "null_resource" "fetch_worker_cert" {
  provisioner "local-exec" {
    command = <<EOT
      SPACELIFT_ACCESS_KEY=${var.spacelift_access_key} \
      SPACELIFT_SECRET_KEY=${var.spacelift_secret_key} \
      spacelift worker-pool cert get \
      --worker-pool ${spacelift_worker_pool.private_workers.id} \
      --output ${path.module}/worker.crt
    EOT
  }

  depends_on = [null_resource.upload_csr]
}

# Save the fetched certificate dynamically
resource "local_file" "worker_crt_file" {
  content  = <<EOT
  ${fileexists("${path.module}/worker.crt") ? file("${path.module}/worker.crt") : "Certificate not generated yet"}
  EOT
  filename = "${path.module}/worker.crt"

  depends_on = [null_resource.fetch_worker_cert]
}

# Output certificate content correctly
output "worker_cert" {
  value     = local_file.worker_crt_file.content
  sensitive = true
}
