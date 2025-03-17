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
    goss = {
      version = "~> 3"
      source  = "github.com/YaleUniversity/goss"
    }
  }
}

variable "vpc_id" { type = string }
variable "source_ami" { type = string }
variable "subnet_id" { type = string }

source "amazon-ebs" "unit" {
  source_ami    = var.source_ami
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  region        = "us-east-1"
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
}

build {
  sources "source.amazon-ebs.unit" {
    ami_name      = "automation-exercise-yum-{{timestamp}}"
  }
  provisioner "file" {
    sources = [
      "index.html",
      "unit.repo",
      "unit.config.json"
    ]
    destination = "/tmp/"
  }
  provisioner "shell" {
    scripts = [
      "unit.install.yum.sh",
      "unit.configure.sh",
      "unit.enable.sh"
    ]
  }
  provisioner "goss" {
    version = "0.4.9"
    tests   = ["goss.yaml"]
  }
  post-processors {
    post-processor "manifest" {}
  }
}

build {
  sources "source.amazon-ebs.unit" {
    ami_name      = "automation-exercise-git-{{timestamp}}"
  }
  provisioner "file" {
    sources = [
      "index.html",
      "unit.repo",
      "unit.config.json"
    ]
    destination = "/tmp/"
  }
  provisioner "shell" {
    scripts = [
      "unit.install.git.sh",
      "unit.configure.sh",
      "unit.enable.sh"
    ]
  }
  provisioner "goss" {
    version = "0.4.9"
    tests   = ["goss.yaml"]
  }
  post-processors {
    post-processor "manifest" {}
  }
}

#
# Build for Docker image
#

source "docker" "unit" {
  image    = "amazonlinux:2023"
  platform = "linux/amd64"
  commit   = true
  changes = [
    "CMD [\"unitd\", \"--no-daemon\"]",
  ]
}

build {
  sources = ["source.docker.unit"]
  provisioner "file" {
    sources = [
      "index.html",
      "unit.repo",
      "unit.config.json"
    ]
    destination = "/tmp/"
  }
  provisioner "shell" {
    scripts = [
      "unit.install.yum.sh",
      "unit.configure.sh"
    ]
  }
  provisioner "goss" {
    version = "0.4.9"
    tests   = ["goss.yaml"]
  }
  post-processors {
    post-processor "docker-tag" {
      repository = "automation-exercise/unit"
      tags       = ["1.34.2"]
    }
    post-processor "manifest" {}
  }
}