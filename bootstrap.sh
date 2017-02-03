#!/bin/bash
echo "Bootstrap preparing the container."
ifconfig eth0 mtu 1450 # this is specific for my network, and probably not the same for you.
apt-get -y update
apt-get -y upgrade
apt-get -y install git ca-certificates
git clone https://github.com/dniel/blogr-pve /opt/puppet/pve

echo "Bootstrap complete, the container is ready to run apply.sh"