# Validate that the yum-based AMI exists
run "validate_yum_image" {
  command = plan

  module {
    source     = "./image"
  }

  variables {
    ami_filter = "automation-exercise-yum-*"
  }

  assert {
    condition = data.aws_ami.image.id != ""
    error_message = "image not found"
  }
}

# Validate that a web server can be deployed from the image and it responds with the correct data
run "validate_yum_server" {
  module {
    source = "./instance"
  }

  variables {
    vpc_id    = var.vpc_id
    subnet_id = var.subnet_id
    ami       = run.validate_yum_image.ami_id
  }

  assert {
    # This tests that the HTTP received is the asset file deployed to the web server during build
    condition     = data.http.index.response_body == file("../assets/index.html")
    error_message = "incorrect data received"
  }
}
