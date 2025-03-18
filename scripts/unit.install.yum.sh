#!/bin/sh -ex

# This script installs Unit from the official repository.

sudo mv /tmp/unit.repo /etc/yum.repos.d/unit.repo
sudo yum install -y unit
unitd --version
