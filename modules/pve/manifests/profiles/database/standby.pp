class pve::profiles::database::standby{

  $db = hiera('pve::profiles::database')

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
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
}