class pve::profiles::lb {

  $tags = [$::environment]
  ::consul::service { "${::hostname}-lb":
    service_name => 'lb',
    address      => $::ipaddress,
    port         => 80,
    tags         => $tags
  }
  ::consul::service { "${::hostname}-exporter":
    service_name => 'traefik-exporter',
    address      => $::ipaddress,
    port         => 8080,
    tags         => [$::environment, "monitor"]
  }
  ::consul::check { 'check_http_ping':
    http     => "http://127.0.0.1:8080/ping",
    interval => '5s',
    timeout  => "1s"
  }

  ###
  ## INSTALL traefik
  #
  $traefikDir = '/opt/traefik'
  $traefikUser = 'traefik'
  $traefikGroup = 'traefik'
  $traefikUid = 1500
  $traefikGid = 1500

  user { $traefikUser:
    home => $traefikDir,
    uid  => $traefikUid,
    gid  => $traefikGid,
  }

  group { $traefikGroup:
    gid => $traefikGid
  }

  file { $traefikDir:
    ensure  => 'directory',
    owner   => $traefikUser,
    group   => $traefikGroup,
    require => [
      User[$traefikUser],
      Group[$traefikGroup]
    ]
  }

  # create a directory
  file { '/var/log/traefik':
    ensure  => 'directory',
    owner   => $traefikUser,
    group   => $traefikGroup,
    require => [
      User[$traefikUser],
      Group[$traefikGroup]
    ]
  }

  # create a directory
  file { '/etc/traefik':
    ensure  => 'directory',
    owner   => $traefikUser,
    group   => $traefikGroup,
    require => [
      User[$traefikUser],
      Group[$traefikGroup]
    ]
  }

  file { '/etc/traefik/traefik.toml':
    content => template('pve/traefik/traefik.toml.erb'),
    owner   => $traefikUser,
    group   => $traefikGroup,
    notify  => Service['traefik'],
    require => [
      File['/etc/traefik'],
      User[$traefikUser],
      Group[$traefikGroup]
    ]
  }

  file { '/etc/init.d/traefik':
    source => 'puppet:///modules/pve/etc/init.d/traefik',
    mode   => "755",
  } ~> Service['traefik']

  service { 'traefik':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }


  # find download url for latest release of traefik for linux
  #  curl -s https://api.github.com/repos/containous/traefik/releases/latest | jq -r ".assets[] | select(.name==\"traefik_linux-amd64\") | .browser_download_url"

  file { '/opt/traefik/traefik_linux-amd64':
    source  => 'puppet:///modules/pve/opt/traefik/traefik_linux-amd64',
    owner   => $traefikUser,
    group   => $traefikGroup,
    mode    => "700",
    require => [
      User[$traefikUser],
      Group[$traefikGroup],
      File['/opt/traefik'],
      File['/etc/traefik'],
      File['/var/log/traefik'],
      File['/etc/init.d/traefik']]
  } -> Exec["setcap-traefik"] ~> Service['traefik']

  exec { 'setcap-traefik':
    command => '/sbin/setcap \'cap_net_bind_service=ep\' /opt/traefik/traefik_linux-amd64'
  }
}
