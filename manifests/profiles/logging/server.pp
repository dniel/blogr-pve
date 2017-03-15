class pve::profiles::logging::server{
  class { 'kibana':
    ensure => latest
  }

  class { 'elasticsearch':
    java_install => true,
    manage_repo  => true,
    repo_version => '5.x',
    autoupgrade => true
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
    auto_upgrade  => true,
  }

#  logstash::plugin { 'logstash-input-beats': }

  logstash::configfile { 'beats_logstash_config':
    content => template("pve/logstash/config.erb"),
  }

}