class pve::profiles::logging::server {


class pve::profiles::pve {
  apt::source { 'elastic-curator':
    location => 'http://packages.elastic.co/curator/5/debian',
    repos    => 'stable',
    key      => {
      'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
      'server' => 'packages.elastic.co',
    }
  } -> Exec["apt_update"] -> package { 'elasticsearch-curator':
    ensure => 'installed',
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
    script     => "/usr/lib/nagios/plugins/check_http -H localhost -p 5601 -j HEAD",
    interval => '30s'
  }

  $tags = [$::environment,
    "traefik.tags=${::environment}",
    "traefik.frontend.rule=Host:log.dragon.lan,log",
    "traefik.frontend.passHostHeader=true"]
  ::consul::service { "${::hostname}-log":
    service_name => "log",
    address      => "${::ipaddress}",
    port         => 5601,
    tags         => $tags
  }

  class { 'elasticsearch':
    java_install => false,
    manage_repo  => true,
    repo_version => '5.x',
    autoupgrade  => true,
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

  logstash::configfile { 'beats_logstash_config':
    content => template("pve/logstash/config.erb"),
  }

  ::consul::service { "${::hostname}-filebeats":
    service_name => "filebeats",
    address      => $::ipaddress,
    port         => 5044,
    tags         => [$::environment]
  }
  ::consul::service { "${::hostname}-syslog":
    service_name => "syslog",
    address      => $::ipaddress,
    port         => 5000,
    tags         => [$::environment]
  }

  ::consul::check { 'check_filebeats':
    script   => '/usr/lib/nagios/plugins/check_tcp -p 5044',
    interval => '30s'
  }
  ::consul::check { 'check_syslog':
    script   => '/usr/lib/nagios/plugins/check_tcp -p 5000',
    interval => '30s'
  }



}