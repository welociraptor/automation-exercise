#!/bin/sh -ex

# This script installs Unit from the official repository.

# Install unit
cat > /etc/yum.repos.d/unit.repo << \EOF
[unit]
name=unit repo
baseurl=https://packages.nginx.org/unit/amzn/2023/x86_64/
gpgkey=https://unit.nginx.org/keys/nginx-keyring.gpg
gpgcheck=1
enabled=1
EOF
yum install -y unit

unitd --version
