packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.5"
      source  = "github.com/hashicorp/amazon"
    }
    docker = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "vpc_id" { type = string }
variable "source_ami" { type = string }
variable "subnet_id" { type = string }

source "amazon-ebs" "unit" {
  ami_name      = "automation-exercise-unit-{{timestamp}}"
  source_ami    = var.source_ami
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ssh_interface = "public_ip"
  region        = "us-east-1"
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
}

source "docker" "unit" {
  image    = "amazonlinux:2023"
  platform = "linux/amd64"
  commit   = true
  changes = [
    "CMD [\"unitd\", \"--no-daemon\"]",
  ]
}

build {
  sources = ["source.docker.unit", "source.amazon-ebs.unit"]
  provisioner "file" {
    sources = [
      "unit.config.json",
      "index.html"
    ]
    destination = "/tmp/"
  }
  provisioner "shell" {
    scripts = [
      "unit.install.yum.sh",
      "unit.configure.sh"
    ]
  }
  provisioner "shell" {
    only   = ["amazon-ebs.unit"]
    inline = ["systemctl enable unit"]
  }
  post-processors {
    post-processor "docker-tag" {
      only       = ["docker.unit"]
      repository = "automation-exercise/unit"
      tags       = ["1.34.2"]
    }
  }
}
