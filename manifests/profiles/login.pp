class pve::profiles::login{

  package { 'tmux':
    ensure => 'installed',
  }

  class { 'fail2ban':
    package_ensure => 'latest',
  }

}
