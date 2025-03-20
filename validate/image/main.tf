# Helper module to find an AMI image

data "aws_ami" "image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = [var.ami_filter]
  }
}

variable "ami_filter" { type = string }

# Export the AMI id so that we can provision an instance using it in the next test step
output "ami_id" { value = data.aws_ami.image.id }
