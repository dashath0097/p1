provider "spacelift" {}

resource "spacelift_worker_pool" "private_workers" {
  name        = "private-ec2-workers"
  description = "Private workers running on EC2"
}
