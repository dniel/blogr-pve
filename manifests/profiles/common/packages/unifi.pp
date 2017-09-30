class pve::profiles::common::packages::unifi {
  service { 'unifi':
    ensure => 'running',
  }

  service { 'mongodb':
    ensure => 'running',
  }
}