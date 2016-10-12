class pve::profiles::database::standby(
  $db_name,
  $db_user,
  $db_password,
  $db_host,
  $rep_user,
  $rep_password,
){

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
    encoding            => 'UTF-8',
    locale              => 'nb_NO.UTF-8',
  }-> class { 'postgresql::server':
    manage_recovery_conf       => true,
    listen_addresses           => '*',
  }

  postgresql::server::config_entry { 'hot_standby':
    value => 'on',
  }

  postgresql::server::recovery{ 'Create a recovery.conf file with the following defined parameters':
    restore_command                => 'cp /var/lib/postgresql/9.4/main/mnt/server/archivedir%f %p',
    archive_cleanup_command        => 'pg_archivecleanup /var/lib/postgresql/9.4/main/mnt/server/archivedir %r',
    standby_mode                   => 'on',
    primary_conninfo               => "host=${db_host} port=5432 user=${db_user} password=${db_password}",
    require                        => Exec["pg_basebackup"]
  }

  postgresql::server::pg_hba_rule { "allow ${db_user} to access ${db_name} database":
    description => "Open up PostgreSQL for access from network",
    type        => 'host',
    database    => $db_name,
    user        => $db_user,
    address     => '0.0.0.0/0',
    auth_method => 'md5',
    notify      => Service['postgresqld']
  }

  exec { "pg_basebackup":
    environment => "PGPASSWORD=${rep_password}",
    command     => "/usr/bin/pg_basebackup -X stream -D /var/lib/postgresql/9.4/main -h ${db_host} -U ${rep_user} -w",
    user        => 'postgres',
    unless      => "/usr/bin/test -f /var/lib/postgresql/9.4/main/PG_VERSION",
    logoutput => true,
  }

}