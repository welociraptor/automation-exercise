# Infrastructure automation exercise

This repository contains an exercise in how to automate the setup of an EC2 instance that would run Nginx Unit.

Following the principle of immutable infrastructure, we will be using [Packer](https://www.packer.io/) to prebake
the instance images, [Goss](https://github.com/goss-org/goss) to test the image during build time and Terraform to 
validate that the image can be used to deploy an instance and works. Terraform is also used to provision infrastructure
necessary to build the images.

The application used is the Nginx Unit web server, configured to serve a minimal HTML document at port 8080.

We are building two variants of the image, one which installs the server using Yum and another one that compiles
the server from source code cloned from a Git repository.

## Repository

| File or folder | Description                                                               |
|----------------|---------------------------------------------------------------------------|
| .githooks/     | Pre-commit hook for running formatters                                    |
| assets/        | Configuration files and data to be copied to the image                    |
| bootstrap/     | Terraform configuration files for setting up AWS networking to run Packer |
| goss/          | Test files for Goss                                                       |
| scripts/       | Scripts used in provisioning the image                                    |
| validate/      | Terraform configuration and test suite to validate the built images       |
| .prototools    | Proto configuration file                                                  |
| README.md      | You're reading it!                                                        |
| unit.pkr.hcl   | Packer configuration file                                                 |

## Prerequisites

- [Packer](https://www.packer.io/)
- [Terraform](https://www.terraform.io/)
- Active AWS account and credentials

To install Packer and Terraform, you can use the [Proto](https://moonrepo.dev/proto) toolchain manager.

## Running the test suite

Run `build.sh` from the repository root. Terraform will ask confirmation to apply the changes in the first step when
provisioning the network infrastructure.

## Development

Running Packer and Terraform format with a git pre-commit hook is always a good idea. To enable this, you can use the
following commands:
```shell
git config --local core.hooksPath .githooks
```
