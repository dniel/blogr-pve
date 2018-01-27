class pve::profiles::jenkins::slave(
  $masterurl,
  $admin_password,
  $admin_user
) {

  include pve::profiles::common::packages::java
  include pve::profiles::common::packages::docker

  class { 'jenkins::slave':
    masterurl => $masterurl,
    ui_user => $admin_user,
    ui_pass => $admin_password,
    install_java => false
  }

}
