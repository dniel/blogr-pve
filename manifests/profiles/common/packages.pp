class pve::profiles::common::packages {

  apt::source { 'webupd8team':
    location => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
    repos    => 'main',
    key      => {
      'id'     => 'EEA14886',
      'server' => 'keyserver.ubuntu.com',
    },
    notify   => Exec["apt_update"]
  } -> Exec['sed -i \'s/jessie/trusty/g\' /etc/apt/sources.list.d/webupd8team.list']

  exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';

    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }

  package { 'oracle-java8-installer':
    ensure  => 'installed',
    require => [Apt::Source['webupd8team'], Exec['set-licence-selected'], Exec['set-licence-seen']],
  }

  package { 'openjdk-7-jdk':
    ensure  => 'purge'
  }

  package { 'oracle-java8-set-default':
    ensure => 'installed',
  }

  package { 'monitoring-plugins':
    ensure => 'installed',
  }

  package { 'git':
    ensure => 'installed',
  }

  package { 'vim':
    ensure => 'installed',
  }

  package { 'curl':
    ensure => 'installed',
  }

  # https://tickets.puppetlabs.com/browse/FACT-866
  package { 'lsb-release':
    ensure => installed,
  }

  package { 'ca-certificates':
    ensure => installed,
  }

  package { 'zip':
    ensure => installed,
  }

}
