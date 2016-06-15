class pve::profiles::database::primary{
  $db = hiera_hash('pve::profiles::database')

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
    encoding            => 'UTF-8',
    locale              => 'nb_NO.UTF-8',
  }-> class { 'postgresql::server':
    listen_addresses           => '*',
  }

  ### Standby configuration for primary db server.
  # configure postgres with hot standby as described here: https://cloud.google.com/solutions/setup-postgres-hot-standby
  postgresql::server::config_entry { 'wal_level':
    value => 'hot_standby',
  }
  postgresql::server::config_entry { 'archive_mode':
    value => 'on',
  }
  postgresql::server::config_entry { 'archive_command':
    value => 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f',
  }
  postgresql::server::config_entry { 'max_wal_senders':
    value => '3',
  }

  postgresql::server::role { "repuser":
    replication      => true,
    connection_limit => 5,
    password_hash    => postgresql_password("repuser", "${db['password']}"),
  }

  $archive_dirs = [
    '/var/lib/postgresql/main',
    '/var/lib/postgresql/main/mnt',
    '/var/lib/postgresql/main/mnt/server',
    '/var/lib/postgresql/main/mnt/server/archivedir',
  ]

  file { $archive_dirs:
    ensure => 'directory',
    owner  => 'postgres',
    group  => 'postgres',
    mode   => '0750',
  }

  postgresql::server::pg_hba_rule { "allow repuser from db-2 to replicate the database":
    description => "Open up replication for access from network",
    type        => 'host',
    database    => "replication",
    user        => "repuser",
    address     => '10.0.1.206/32',
    auth_method => 'md5',
  }
  ## end.

  postgresql::server::db { "${db['name']}":
    user     => "${db['user']}",
    password => postgresql_password("${db['user']}", "${db['password']}"),
  }

  postgresql::server::role { "${db['user']}":
    password_hash => postgresql_password("${db['user']}", "${db['password']}"),
  }

  postgresql::server::database_grant { "GRANT ALL ${db['user']} - ${db['name']}:":
    privilege => "ALL",
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
    notify => Service['postgresqld']
  }
}