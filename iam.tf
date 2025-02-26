resource "aws_iam_role" "worker_role" {
  name = "SpaceliftWorkerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "worker_profile" {
  name = "SpaceliftWorkerProfile"
  role = aws_iam_role.worker_role.name
}
