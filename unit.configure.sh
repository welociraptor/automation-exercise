#!/bin/sh -ex

# This script configures an existing installation of Unit to serve the supplied index.html file.

# Copy asset
sudo mkdir -p /www/data
sudo mv /tmp/index.html /www/data

# Start and configure server
sudo unitd
sudo curl -X PUT --data-binary @/tmp/unit.config.json --unix-socket /var/run/unit/control.sock http://localhost/config
