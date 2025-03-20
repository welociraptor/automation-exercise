# Terraform configuration for bootstrapping the build process
#
# This configuration provisions the necessary network components to allow Packer to be run.
# It also figures out the AMI id to use as a base for the build process. Outputs are passed
# on to Packer using a env file in the next step.

# Data source to figure out the id for the latest Amazon Linux 2023 for x64 architecture in the selected region
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# AWS networking components to allow Packer to bootstrap an instance and connect to it

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Outputs to be passed on to Packer

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "source_ami" {
  value = data.aws_ami.amazon_linux_2023.id
}
