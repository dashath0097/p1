# Fetch the worker certificate from Spacelift API
data "http" "fetch_worker_cert" {
  url = "https://app.spacelift.io/api/v1/worker-pools/${spacelift_worker_pool.private_workers.id}/certificate"

  request_headers = {
    Authorization = "Bearer ${var.spacelift_access_key}:${var.spacelift_secret_key}"
  }

  depends_on = [null_resource.upload_csr]  # Ensure CSR is uploaded first
}

# Save the fetched certificate as a local file
resource "local_file" "worker_crt_file" {
  content  = data.http.fetch_worker_cert.body  # Store certificate content dynamically
  filename = "${path.module}/worker.crt"

  depends_on = [data.http.fetch_worker_cert]
}

# Output the certificate content for debugging (sensitive)
output "worker_cert" {
  value     = data.http.fetch_worker_cert.body  # Output actual certificate content
  sensitive = true
}
