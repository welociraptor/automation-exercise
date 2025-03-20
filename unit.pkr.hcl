packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.5"
      source  = "github.com/hashicorp/amazon"
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
  source "source.amazon-ebs.unit" {
    name     = "yum"
    ami_name = "automation-exercise-yum-{{timestamp}}"
  }
  provisioner "file" {
    sources = [
      "assets/index.html",
      "assets/unit.repo",
      "assets/unit.config.json"
    ]
    destination = "/tmp/"
  }
  provisioner "shell" {
    env = {
      # The socket is in a different location in the version installed with Git
      SOCKET_LOCATION = "/var/run/unit/control.sock"
    }
    scripts = [
      "scripts/unit.install.yum.sh",
      "scripts/unit.configure.sh",
      "scripts/unit.systemd.enable.sh"
    ]
  }
  provisioner "goss" {
    version = "0.4.9"
    tests   = ["goss/yum/goss.yaml"]
  }
}

build {
  source "source.amazon-ebs.unit" {
    name     = "git"
    ami_name = "automation-exercise-git-{{timestamp}}"
  }
  provisioner "file" {
    sources = [
      "assets/index.html",
      "assets/unit.repo",
      "assets/unit.config.json",
      "assets/unit.service"
    ]
    destination = "/tmp/"
  }
  provisioner "shell" {
    env = {
      # The socket is in a different location in the version installed with Yum
      SOCKET_LOCATION = "/usr/local/var/run/unit/control.unit.sock"
      # This is used in selecting which tag to clone from git
      VERSION = "1.34.1"
    }
    scripts = [
      "scripts/unit.install.git.sh",
      "scripts/unit.configure.sh",
      "scripts/unit.systemd.prepare.sh",
      "scripts/unit.systemd.enable.sh"
    ]
  }
  provisioner "goss" {
    version = "0.4.9"
    tests   = ["goss/git/goss.yaml"]
  }
}
