class pve::profiles::common::packages::java {

  package { 'default-jdk':
    ensure => 'installed',
  }
}