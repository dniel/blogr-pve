class pve::profiles::chatserver {
  $tags = [$::environment,
    "traefik.tags=${::environment}",
    "traefik.frontend.rule=Host:chat.dragon.lan,chat",
    "traefik.frontend.passHostHeader=true"]

  ::consul::service { "${::hostname}-chat":
    service_name => 'chat',
    address      => $::ipaddress,
    port         => 8065,
    tags         => $tags
  }

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
    service_template => 'mattermost/sysvinit_debian.erb',
    service_path     => '/etc/init.d/mattermost',
    override_options => {
      'SqlSettings'  => {
        'DriverName' => 'postgres',
        'DataSource' => "postgres://mattermost:mattermost@127.0.0.1:5432/mattermost?sslmode=disable&connect_timeout=10",
      },
      'FileSettings' => {
        'Directory' => '/var/mattermost',
      },
    },
  }
}