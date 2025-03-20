# Configuration to provision an instance using a given AMI and enabling connectivity to port 8080

variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "ami" { type = string }

resource "aws_security_group" "allow_http" {
  name        = "allow_ssh"
  description = "Allow HTTP inbound traffic to port 8080"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
}

# We need to add a bit of delay to wait until Unit comes up before launching the http request
resource "time_sleep" "wait_5_seconds" {
  depends_on      = [aws_instance.test]
  create_duration = "5s"
}

# This will be used to validate the HTTP response from the web server in the tests
data "http" "index" {
  depends_on = [time_sleep.wait_5_seconds]
  url        = "http://${aws_instance.test.public_ip}:8080/index.html"
}
