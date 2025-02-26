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

resource "local_file" "worker_crt_file" {
  content  = data.http.fetch_worker_cert.body  # Store certificate content dynamically
  filename = "${path.module}/worker.crt"

  depends_on = [null_resource.fetch_worker_cert]
}

output "worker_cert" {
  value     = data.http.fetch_worker_cert.body  # Output certificate content instead of reading from file
  sensitive = true
}
