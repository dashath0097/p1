data "http" "fetch_worker_cert" {
  url = "https://app.spacelift.io/api/v1/worker-pools/${spacelift_worker_pool.private_workers.id}/certificate"

  request_headers = {
    Authorization = "Bearer ${var.spacelift_api_token}"
  }

  depends_on = [null_resource.upload_csr]
}

resource "local_file" "worker_crt_file" {
  content  = data.http.fetch_worker_cert.body
  filename = "${path.module}/worker.crt"

  depends_on = [data.http.fetch_worker_cert]
}

output "worker_cert" {
  value     = data.http.fetch_worker_cert.body
  sensitive = true
}
