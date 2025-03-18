#!/bin/sh -ex

# This script configures an existing installation of Unit to serve the supplied index.html file.

# Copy asset
sudo mkdir -p /www/data
sudo mv /tmp/index.html /www/data

# Start and configure server
sudo unitd

# Give the server a moment to start up
sleep 3

# Put in the configuration
sudo curl -X PUT --data-binary @/tmp/unit.config.json --unix-socket $SOCKET_LOCATION http://localhost/config
