# Infrastructure automation exercise

This repository contains an exercise in how to automate the setup of an EC2 instance that would run Nginx Unit.

Following the principle of immutable infrastructure, we will be using [Packer](https://www.packer.io/) to prebake
the instance image, [Terraform](https://www.packer.io/) to deploy and [Goss](https://github.com/goss-org/goss) to
validate that the instance is properly built.

Download goss and dgoss:
```
curl -L https://github.com/goss-org/goss/releases/download/v0.4.9/goss-linux-amd64 -o goss-linux-amd64
curl -L https://raw.githubusercontent.com/goss-org/goss/master/extras/dgoss/dgoss -o dgoss
chmod u+x dgoss
```

Test container using dgoss:
```
GOSS_FILES_STRATEGY=cp GOSS_PATH=goss-linux-amd64 ./dgoss run --rm -ti -p 8080:8080 automation-exercise/unit:1.34.2
```
