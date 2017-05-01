class pve::profiles::logging::server {

  include pve::profiles::common::packages::java8

  class { 'kibana':
    ensure => latest,
    config => {
      'server.port' => '5601',
      'server.host' => '0.0.0.0',
      'server.name' => 'Dragon Central Logging'
    }
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

}