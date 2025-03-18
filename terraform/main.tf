module "network" {
  source = "./network"
}

module "instance" {
  source    = "./instance"
  subnet_id = module.network.subnet_id
  vpc_id    = module.network.vpc_id
  ami       = var.ami
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

variable "ami" {
  type    = string
  default = ""
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "source_ami" {
  value = data.aws_ami.amazon_linux_2023.id
}

output "public_ip" {
  value = module.instance.public_ip
}
