class pve::profiles::common::packages::docker {
  package { 'docker':
    ensure => 'installed',
  }
}