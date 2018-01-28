class pve::profiles::jenkins::slave (
  $masterurl,
  $admin_password,
  $admin_user
) {

  include pve::profiles::common::packages::java
  include pve::profiles::common::packages::docker

  class { 'jenkins::slave':
    masterurl    => $masterurl,
    ui_user      => $admin_user,
    ui_pass      => $admin_password,
    install_java => false,
    version      => '3.0'
  }

  # should download swarm-client.jar from https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.8/swarm-client-3.8.jar

  # should start service.
}
