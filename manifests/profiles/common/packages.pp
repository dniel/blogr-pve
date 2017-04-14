class pve::profiles::common::packages{

  apt::source { 'webupd8team':
    location => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
    repos    => 'trusty main',
    key      => {
      'id'     => 'EEA14886',
      'server' => 'keyserver.ubuntu.com',
    },
  }

  package { 'oracle-java8-installer':
    ensure => 'installed',
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
