#!/bin/bash
set -x
dir="$(dirname $(readlink -f $0))"
cd $dir

# trouble with packet fragmentation in my network
/sbin/ifconfig eth0 mtu 1400

# skip set kernel parameters
# workaround for
# https://github.com/elastic/elasticsearch/issues/22340
export ES_SKIP_SET_KERNEL_PARAMETERS=true

# first run, no bundle commmand
if ! hash /usr/local/bin/bundle 2>/dev/null;  then
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

# Get current environment from hostname
HOST=$(hostname)
srv=`expr "$HOST" : '^\(d\|t\|p\)-'`
case $srv in
  t) ENVIRONMENT="test" ;;
  d) ENVIRONMENT="development";;
  p) ENVIRONMENT="production";;
  *) echo "Unknown server !!!"exit 1;
esac

# install modules
./bin/librarian-puppet install --path /opt/puppetlabs/puppet/modules --quiet|| exit 1

git config user.email "daniel@engfeldt.net"
git config user.name "Daniel"

# Run Puppet
./bin/puppet apply --environment=$ENVIRONMENT --log_level=warning --color=ansi --modulepath=..:/opt/puppetlabs/puppet/modules manifests "$@"

## Log status of the Puppet run
if [ $? -eq 0 ]
then
    /usr/bin/logger -i "Puppet has run successfully" -t "puppet-run"
    exit 0
else
    /usr/bin/logger -i "Puppet has ran into an error, please run Puppet manually" -t "puppet-run"
    exit 1
fi