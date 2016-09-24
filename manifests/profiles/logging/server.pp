class pve::profiles::logging::server{
  class { 'elasticsearch':
    java_install => true,
    manage_repo  => true,
    repo_version => '2.x',
  }

  package { 'systemd-sysv':
    ensure => 'installed',
  }

  package { 'libaugeas-ruby':
    ensure => 'installed',
  }

}