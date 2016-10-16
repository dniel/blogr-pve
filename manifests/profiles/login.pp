class pve::profiles::login{

  package { 'tmux':
    ensure => 'installed',
  }

  class { 'fail2ban':
    package_ensure => 'latest',
    config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
  }

}
