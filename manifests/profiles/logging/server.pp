class pve::profiles::logging::server{
  include kibana4

  class { 'elasticsearch':
    java_install => true,
    manage_repo  => true,
    repo_version => '2.x',
  }

  # elasticsearch need it
  package { 'systemd-sysv':
    ensure => 'installed',
  }

  # elasticsearch need it
  package { 'libaugeas-ruby':
    ensure => 'installed',
  }

  class { 'logstash':
    manage_repo  => true,
    autoupgrade  => true,
    repo_version => '2.4',
  }

#  logstash::plugin { 'logstash-input-beats': }

  logstash::configfile { 'beats_logstash_config':
    content => template("pve/logstash/config.erb"),
  }

}