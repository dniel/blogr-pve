class pve::profiles::jenkins::slave {

  include pve::profiles::common::packages::java
  include pve::profiles::common::packages::docker

  class { 'jenkins::slave':
    masterurl => 'http://p-ci-01.dniel.in:8080',
    ui_user => 'adminuser',
    ui_pass => 'adminpass',
  }

}
