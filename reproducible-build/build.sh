#!/bin/bash

set -e

mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global color.ui true
repo init -u https://github.com/flashbots/yocto-manifests.git -b tdx
repo sync
source setup
make build
