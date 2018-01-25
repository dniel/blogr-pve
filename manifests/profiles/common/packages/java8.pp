class pve::profiles::common::packages::java8 {

  package { 'default-jdk':
    ensure => 'installed',
  }
}