resource "aws_instance" "private_worker" {
  count         = 1
  ami           = "ami-0e1bed4f06a3b463d" # Latest Ubuntu AMI
  instance_type = "t3.medium"
  iam_instance_profile = aws_iam_instance_profile.worker_profile.name

  tags = {
    Name = "Spacelift-Worker-${count.index}"
  }

  user_data = templatefile("${path.module}/user_data.sh", {
    SPACELIFT_WORKER_POOL_ID   = spacelift_worker_pool.private_workers.id
    SPACELIFT_WORKER_POOL_CERT = file("${path.module}/worker.crt")
    SPACELIFT_WORKER_POOL_KEY  = tls_private_key.worker_key.private_key_pem
  })

  depends_on = [null_resource.fetch_worker_cert]
}
