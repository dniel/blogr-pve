class pve::profiles::common::packages {


  package { 'openjdk-7-jdk':
    ensure => 'purged',
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
