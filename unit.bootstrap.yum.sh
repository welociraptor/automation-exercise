#!/bin/sh -ex

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

# Copy asset
mkdir -p /www/data
mv /tmp/index.html /www/data

# Start and configure server
unitd
curl -X PUT --data-binary @/tmp/unit.config.json --unix-socket /var/run/unit/control.sock http://localhost/config
