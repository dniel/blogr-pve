class pve::profiles::database::standby{

  $db = hiera_hash('pve::profiles::database')

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
    restore_command                => 'cp /mnt/server/archivedir/%f %p',
    archive_cleanup_command        => 'pg_archivecleanup /mnt/server/archivedir %r',
    standby_mode                   => 'on',
    primary_conninfo               => 'host=10.0.1.203 port=5432 user=repuser password=password1',
  }

  postgresql::server::pg_hba_rule { "allow ${db['user']} to access ${db['name']} database":
    description => "Open up PostgreSQL for access from network",
    type        => 'host',
    database    => "${db['name']}",
    user        => "${db['user']}",
    address     => '0.0.0.0/0',
    auth_method => 'md5',
  }

  service { 'postgresqld':
    ensure    => running,
    enable    => true,
  }
}