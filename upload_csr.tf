resource "null_resource" "upload_csr" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X POST "https://app.spacelift.io/api/v1/worker-pools/${spacelift_worker_pool.private_workers.id}/csr" \
      -H "Authorization: Bearer ${var.spacelift_api_token}" \
      -H "Content-Type: text/plain" \
      --data-binary @worker.csr
    EOT
  }

  depends_on = [local_file.worker_csr_file]
}
