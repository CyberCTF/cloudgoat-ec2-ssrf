data "aws_ami" "ec2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "${path.module}/../assets/lambda.py"
  output_path = "${path.module}/../assets/lambda.zip"
}

data "archive_file" "app" {
  type        = "zip"
  source_dir  = "${path.module}/../assets/ssrf_app/"
  output_path = "${path.module}/../assets/app.zip"
}
