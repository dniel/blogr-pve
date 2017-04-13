class pve::profiles::database () {

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
    encoding            => 'UTF-8',
    locale              => 'nb_NO.UTF-8',
  } -> class { 'postgresql::server':
    listen_addresses          => '*',
    service_restart_on_change => true
  }

  postgresql::server::pg_hba_rule { "allow all to access all database":
    description => "Open up PostgreSQL for access from network",
    type        => 'host',
    database    => "all",
    user        => "all",
    address     => '0.0.0.0/0',
    auth_method => 'md5',
  }

  $tags = [$::environment]
  ::consul::service { "${::hostname}-postgres":
    service_name => 'postgres',
    address      => $::ipaddress,
    port         => 5432,
    tags         => $tags
  }
}
