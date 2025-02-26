provider "spacelift" {
  access_key = var.spacelift_access_key
  secret_key = var.spacelift_secret_key
}

resource "spacelift_worker_pool" "private_workers" {
  name        = "private-ec2-workers"
  description = "Private workers running on EC2"
}
