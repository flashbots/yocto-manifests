#!/bin/bash

set -e

mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global color.ui true

su -p -s /bin/bash -l -c "source /build/srcs/poky/oe-init-build-env && cd /build && make gen-measurements" ubuntu

cp --dereference /build/measurements/* /artifacts/measurements/.
