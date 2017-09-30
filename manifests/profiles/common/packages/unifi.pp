class pve::profiles::common::packages::unifi {
  package { 'unifi':
    ensure  => latest,
    require => Yumrepo['HP-spp'],
  }
}