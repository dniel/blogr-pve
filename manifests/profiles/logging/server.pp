class pve::profiles::logging::server{
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
    repo_version => '1.5',
    autoupgrade  => true,
  }

  include kibana4
}