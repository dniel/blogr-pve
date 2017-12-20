class pve::profiles::logging::server {

  apt::source { 'elastic-curator':
    location => 'http://packages.elastic.co/curator/5/debian',
    repos    => 'main',
    key      => {
      'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
      'server' => 'packages.elastic.co',
    }
  } -> Exec["replace-jessie-with-stable"] -> Exec["apt_update"] -> package { 'elasticsearch-curator':
    ensure => 'installed'
  }

  exec {
    'replace-jessie-with-stable':
      command => '/bin/sed -i.bak -e \'s/jessie/stable/\' /etc/apt/sources.list.d/elastic-curator.list';
  }

  include pve::profiles::common::packages::java8

  class { 'kibana':
    ensure => latest,
    config => {
      'server.port' => '5601',
      'server.host' => '0.0.0.0',
      'server.name' => 'Dragon Central Logging'
    }
  }

  ::consul::check { 'check_kibana_http_status':
    script   => "/usr/lib/nagios/plugins/check_http -H localhost -p 5601 -j HEAD",
    interval => '30s'
  }

  $tags = [$::environment,
    "traefik.tags=${::environment}",
    "traefik.frontend.rule=Host:logs.dniel.in,logs",
    "traefik.frontend.passHostHeader=true"]
  ::consul::service { "${::hostname}-log":
    service_name => "logs",
    address      => "${::ipaddress_eth0}",
    port         => 5601,
    tags         => $tags
  }

  class { 'elasticsearch':
    java_install => false,
    manage_repo  => true,
    repo_version => '5.x',
    autoupgrade  => true,
    /*    config => {
          'network.host' => '0.0.0.0',
        }
    */
  }

  elasticsearch::instance { 'es-01': }

  # elasticsearch need it
  package { 'systemd-sysv':
    ensure => 'installed',
  }

  # elasticsearch need it
  package { 'libaugeas-ruby':
    ensure => 'installed',
  }

  class { 'logstash':
    auto_upgrade => true,
  }

#  logstash::plugin { 'logstash-input-beats': }
#  logstash::plugin { 'logstash-input-gelf': }

  logstash::configfile { 'beats_logstash_config':
    content => template("pve/logstash/config.erb"),
  }

  ::consul::service { "${::hostname}-filebeats":
    service_name => "filebeats",
    address      => $::ipaddress_eth0,
    port         => 5044,
    tags         => [$::environment]
  } ~> Service['consul']

  ::consul::service { "${::hostname}-syslog":
    service_name => "syslog",
    address      => $::ipaddress_eth0,
    port         => 5000,
    tags         => [$::environment]
  } ~> Service['consul']

  ::consul::service { "${::hostname}-es":
    service_name => "elasticsearch",
    address      => $::ipaddress_eth0,
    port         => 9200,
    tags         => [$::environment]
  } ~> Service['consul']

  ::consul::check { 'check_filebeats':
    script   => '/usr/lib/nagios/plugins/check_tcp -p 5044',
    interval => '30s'
  } ~> Service['consul']

  ::consul::check { 'check_syslog':
    script   => '/usr/lib/nagios/plugins/check_tcp -p 5000',
    interval => '30s'
  } ~> Service['consul']

  ::consul::check { 'check_elasticsearch':
    script   => '/usr/lib/nagios/plugins/check_tcp -p 9200',
    interval => '30s'
  } ~> Service['consul']


}