class pve::profiles::database::primary(
  $rep_user,
  $rep_password,
  $rep_adress,
){

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
    value => 'off',
  }
  postgresql::server::config_entry { 'archive_command':
    value => 'rsync -aq %p postgres@db-2.dragon.lan:/var/lib/postgresql/9.4/main/archive/%f',
  }
  postgresql::server::config_entry { 'max_wal_senders':
    value => '3',
  }

  postgresql::server::role { $rep_user:
    replication      => true,
    connection_limit => 5,
    password_hash    => postgresql_password($rep_user, $rep_password),
  }

  postgresql::server::pg_hba_rule { "allow replication user from standby to replicate the database":
    description => "Open up replication for access from network",
    type        => 'host',
    database    => "replication",
    user        => $rep_user,
    address     => $rep_adress,
    auth_method => 'md5',
  }

  postgresql::server::pg_hba_rule { "allow all to access all database":
    description => "Open up PostgreSQL for access from network",
    type        => 'host',
    database    => "all",
    user        => "all",
    address     => '0.0.0.0/0',
    auth_method => 'md5',
  }

}