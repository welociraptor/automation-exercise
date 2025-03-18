# Infrastructure automation exercise

This repository contains an exercise in how to automate the setup of an EC2 instance that would run Nginx Unit.

Following the principle of immutable infrastructure, we will be using [Packer](https://www.packer.io/) to prebake
the instance image, [Terraform](https://www.packer.io/) to deploy and [Goss](https://github.com/goss-org/goss) to
validate that the instance is properly built.

## Repository

| File or folder | Description                                                             |
|----------------|-------------------------------------------------------------------------|
| .githooks/     | Pre-commit hook for running formatters                                  |
| assets/        | Configuration files and data to be copied to the image                  |
| scripts/       | Scripts used in provisioning the image                                  |
| terraform/     | Configuration files for setting up AWS networking and testing the image |
| .prototools    | Proto configuration file                                                |
| goss.yaml      | Test file for Goss                                                      |
| README.md      | You're reading it!                                                      |
| unit.pkr.hcl   | Packer configuration file                                               |

## Prerequisites

- [Packer](https://www.packer.io/)
- [Terraform](https://www.terraform.io/)
- Active AWS account and credentials

To install Packer and Terraform, you can use the [Proto](https://moonrepo.dev/proto) toolchain manager and the
command `proto activate`.

## Development

Running Packer and Terraform format with a git pre-commit hook is always a good idea. To enable this, you can use the
following commands:
```shell
git config --local core.hooksPath .githooks
```
