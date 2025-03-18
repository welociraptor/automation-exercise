#!/bin/sh -ex

# Prepare systemd
sudo mv /tmp/unit.service /usr/lib/systemd/system
sudo systemctl daemon-reload
