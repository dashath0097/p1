resource "tls_private_key" "worker_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "worker_csr" {
  private_key_pem = tls_private_key.worker_key.private_key_pem

  subject {
    common_name  = "spacelift-worker"
    organization = "MyCompany"
  }
}

resource "local_file" "worker_csr_file" {
  content  = tls_cert_request.worker_csr.cert_request_pem
  filename = "${path.module}/worker.csr"
}

output "worker_csr" {
  value     = tls_cert_request.worker_csr.cert_request_pem
  sensitive = true
}

output "worker_private_key" {
  value     = tls_private_key.worker_key.private_key_pem
  sensitive = true
}
