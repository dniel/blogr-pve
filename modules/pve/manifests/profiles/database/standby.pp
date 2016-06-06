class pve::profiles::database::standby{

  $db = hiera('pve::profiles::database')

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
  }-> class { 'postgresql::server':
    listen_addresses           => '*',
  }
}