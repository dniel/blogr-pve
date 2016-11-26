class pve::profiles::chatserver{
  class { 'postgresql::server':
    ipv4acls => ['host all all 127.0.0.1/32 md5'],
  }
  postgresql::server::db { 'mattermost':
    user     => 'mattermost',
    password => postgresql_password('mattermost', 'mattermost'),
  }
  postgresql::server::database_grant { 'mattermost':
    privilege => 'ALL',
    db        => 'mattermost',
    role      => 'mattermost',
  } ->
  class { 'mattermost':
    override_options => {
      'SqlSettings' => {
        'DriverName' => 'postgres',
        'DataSource' => "postgres://mattermost:mattermost@127.0.0.1:5432/mattermost?sslmode=disable&connect_timeout=10",
      },
      'FileSettings' => {
        'Directory' => '/var/mattermost',
      },
    },
  }
}