class pve::profiles::database::primary{

  $db = hiera('pve::profiles::database')

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
  }-> class { 'postgresql::server':
    listen_addresses           => '*',
  }

  postgresql::server::db { "${db['name']}":
    user     => "${db['user']}",
    password => postgresql_password("${db['user']}", "${db['password']}"),
  }

  postgresql::server::role { "${db['user']}":
    password_hash => postgresql_password("${db['user']}", "${db['password']}"),
  }

  postgresql::server::role { "${db['user']}":
    password_hash => postgresql_password("${db['user']}", "${db['password']}"),
  }

  postgresql::server::database_grant { "${db['name']}":
    privilege => 'ALL',
    db        => "${db['name']}",
    role      => "${db['user']}",
  }

  postgresql::server::pg_hba_rule { "allow ${db['user']} to access ${db['name']} database":
    description => "Open up PostgreSQL for access from network",
    type        => 'host',
    database    => "${db['name']}",
    user        => "${db['user']}",
    address     => '0.0.0.0/0',
    auth_method => 'md5',
  }
}