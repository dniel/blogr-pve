#!/bin/bash
set -x

dir="$(dirname $(readlink -f $0))"
cd $dir

# first run, no bundle commmand
if ! hash bundle 2>/dev/null;  then
  if [ -f /etc/redhat-release ]; then
    yum clean all
    yum install -y ruby ruby-dev make gcc
    gem install bundler --no-ri --no-rdoc
  elif [ -f /etc/debian_version ]; then
    apt-get update
    apt-get install -y ruby ruby-dev make git
    gem install bundler --no-ri --no-rdoc
  else
    echo "OS not supported yet"; exit 1
  fi
fi

# Install gems from Gemfile or Gemfile.lock if checked in
bundle install --path=.bundle --binstubs=bin || exit 1

# get environment from current git branch
environment=$(git symbolic-ref --short HEAD)

# install modules
./bin/librarian-puppet install --path ./modules --verbose || exit 1

# Run Puppet
./bin/puppet apply --modulepath="..:./modules" --hiera_config=hiera.yaml manifests "$@" || exit 1