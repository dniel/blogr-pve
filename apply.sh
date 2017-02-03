#!/bin/bash
set -x
dir="$(dirname $(readlink -f $0))"
cd $dir

# first run, no bundle commmand
if ! hash bundle 2>/dev/null;  then
  if [ -f /etc/redhat-release ]; then
    yum clean all
    yum install -y ruby ruby-dev make gcc ca-certificates lsb_release libaugeas-ruby
    gem install bundler --no-ri --no-rdoc --quiet
  elif [ -f /etc/debian_version ]; then
    apt-get update
    apt-get install -y ruby ruby-dev make git ca-certificates lsb-release libaugeas-ruby apt-transport-https
    gem install bundler --no-ri --no-rdoc --quiet
  else
    echo "OS not supported yet"; exit 1
  fi
fi

# Install gems from Gemfile or Gemfile.lock if checked in
/usr/local/bin/bundle install --path=.bundle --binstubs=bin --quiet|| exit 1

# get environment from current git branch
environment=$(git symbolic-ref --short HEAD)

# install modules
./bin/librarian-puppet install --path .. --quiet|| exit 1

# Run Puppet
./bin/puppet apply --log_level=warning --color=ansi --modulepath=.. --hiera_config=hiera.yaml manifests "$@"

## Log status of the Puppet run
if [ $? -eq 0 ]
then
    /usr/bin/logger -i "Puppet has run successfully" -t "puppet-run"
    exit 0
else
    /usr/bin/logger -i "Puppet has ran into an error, please run Puppet manually" -t "puppet-run"
    exit 1
fi