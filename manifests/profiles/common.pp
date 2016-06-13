class pve::profiles::common{
  package { 'git':
    ensure => 'installed',
  }

  package { 'vim':
    ensure => 'installed',
  }

  package { 'sudo':
    ensure => 'installed',
  }

  package { 'lsb-release':
    ensure => installed,
  }
}