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

source "amazon-ebs" "unit" {
  ami_name      = "automation-exercise-unit-{{timestamp}}"
  source_ami    = "ami-08b5b3a93ed654d19" # Amazon Linux 2023 AMI 2023.6.20250303.0 x86_64 HVM kernel-6.1
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  region        = "us-east-1"
  vpc_id        = "vpc-0e26642ceb62faa8f"
  subnet_id     = "subnet-08980452e6d4ef1dd"
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
    script = "unit.bootstrap.yum.sh"
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
