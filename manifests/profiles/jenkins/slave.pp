class pve::profiles::jenkins::slave(
  $admin_password,
  $admin_user
) {

  include pve::profiles::common::packages::java
  include pve::profiles::common::packages::docker

  class { 'jenkins::slave':
    masterurl => 'http://p-ci-01.dniel.in:8080',
    ui_user => $admin_user,
    ui_pass => $admin_password
  }

}
