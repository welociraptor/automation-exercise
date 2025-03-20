#!/usr/bin/env bash
set -eux -o pipefail

echo "Bootstrapping network.."
pushd bootstrap
terraform init
terraform apply
terraform output > ../unit.auto.pkrvars.hcl
popd

echo "Building images.."
packer build .

echo "Validating images.."
cp unit.auto.pkrvars.hcl > ./validate/terraform.tfvars
pushd validate
terraform init
terraform test
popd

echo "Done!"
