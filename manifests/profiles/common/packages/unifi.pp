class pve::profiles::common::packages::unifi {
  package { 'unifi':
    ensure  => latest
  }
}