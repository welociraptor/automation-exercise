#!/bin/sh -x

# This script builds Unit from source code, using version specified in environment variable VERSION.

# Install dependencies
sudo yum install -y git gcc which pcre2-devel

# Clone desired version from repository
git clone -b $VERSION https://github.com/nginx/unit.git

# Build and install
cd unit
./configure
make
sudo make install

# Clean up
cd ..
rm -rf unit

unitd --version
