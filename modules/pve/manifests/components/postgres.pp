class pve::components::postgres{
  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
  }-> class { 'postgresql::server':
    listen_addresses           => '*',
  }

  postgresql::server::db { 'blogr':
    user     => 'blogr',
    password => postgresql_password('blogr', 'Password1'),
  }

  postgresql::server::role { 'blogr':
    password_hash => postgresql_password('blogr', 'Password1'),
  }

  postgresql::server::database_grant { 'blogr':
    privilege => 'ALL',
    db        => 'blogr',
    role      => 'blogr',
  }

  postgresql::server::pg_hba_rule { 'allow application network to access blogr database':
    description => "Open up PostgreSQL for access from network",
    type        => 'host',
    database    => 'blogr',
    user        => 'blogr',
    address     => '0.0.0.0/0',
    auth_method => 'md5',
  }
}
