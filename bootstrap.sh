#!/bin/bash
set -x

echo "Bootstrap preparing the container."
apt-get -y update
apt-get -y upgrade
apt-get -y install git ca-certificates
git clone https://github.com/dniel/blogr-pve /opt/pve

echo "Bootstrap complete, the container is ready to run apply.sh"