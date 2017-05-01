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
if ! hash bundle 2>/dev/null;  then
  if [ -f /etc/debian_version ]; then
    apt-get update
    apt-get install -y ruby ruby-dev make git ca-certificates lsb-release libaugeas-ruby apt-transport-https
    gem install bundler --no-ri --no-rdoc --quiet
  else
    echo "OS not supported yet"; exit 1
  fi
fi

# Install gems from Gemfile or Gemfile.lock if checked in
bundle install --path=.bundle --binstubs=bin --quiet|| exit 1

# Get current environment from hostname
HOST=$(hostname)
srv=`expr "$HOST" : '^\(d\|t\|p\)-'`
case $srv in
  t) ENVIRONMENT="test" ;;
  d) ENVIRONMENT="development";;
  p) ENVIRONMENT="production";;
  *) echo "Unknown server !!!"exit 1;
esac

# Get current role from hostname
HOST=$(hostname)
ROLE=`expr "$HOST" : '[p|t|d]-\(\w*\)-[0-9]\{2\}'`

if [ -z "$ROLE" ];
then
  echo "No role found on first try, check if it is a Proxmox host with special naming."
  ROLE=`expr "$HOST" : "\(pve\)"`
fi

if [ -z "$ROLE"];
then
    /usr/bin/logger -i "Puppet Apply has run into an error, could not parse Role for $HOST" -t "puppet-run"
    exit 1
fi

# install modules
./bin/librarian-puppet install --path /opt/puppetlabs/puppet/modules --quiet|| exit 1

# Run Puppet with parsed ROLE and ENVIRONMENT from hostname
./bin/puppet apply --environment=$ENVIRONMENT \
                   --log_level=warning \
                   --color=ansi \
                   --modulepath=..:/opt/puppetlabs/puppet/modules \
                   -e"include pve::roles::$ROLE" "$@"

## Log status of the Puppet run
if [ $? -eq 0 ]
then
    /usr/bin/logger -i "Puppet has run successfully" -t "puppet-run"
    exit 0
else
    /usr/bin/logger -i "Puppet has ran into an error, please run Puppet manually" -t "puppet-run"
    exit 1
fi