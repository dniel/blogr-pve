class pve::profiles::blogr::lb{

  $tags = [$::environment]
  ::consul::service { "${::hostname}-lb":
    service_name  => "lb",
    address       => "${::ipaddress}",
    port          => 80,
    tags          => $tags
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
    home =>  $traefikDir,
    uid  =>  $traefikUid,
    gid  =>  $traefikGid,
  }

  group { $traefikGroup:
    gid  =>  $traefikGid
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
    ensure => 'directory',
    owner   => $traefikUser,
    group   => $traefikGroup,
    require => [
      User[$traefikUser],
      Group[$traefikGroup]
    ]
  }

  # create a directory
  file { '/etc/traefik':
    ensure => 'directory',
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
    notify => Service['traefik'],
    require => [
      File['/etc/traefik'],
      User[$traefikUser],
      Group[$traefikGroup]
    ]
  }

  file { '/etc/init.d/traefik':
    source  => 'puppet:///modules/pve/etc/init.d/traefik',
    mode => "755",
    notify => Service['traefik']
  }

  service { 'traefik':
    ensure  => running,
    enable  => true,
    hasrestart => true,
    hasstatus => true,
  }

  file { '/opt/traefik/traefik_linux-amd64':
    source  => 'puppet:///modules/pve/opt/traefik/traefik_linux-amd64',
    owner   => $traefikUser,
    group   => $traefikGroup,
    mode    => "700",
    notify  => Exec['setcap-traefik'],
    require => [
      User[$traefikUser],
      Group[$traefikGroup],
      File['/opt/traefik'],
      File['/etc/traefik'],
      File['/var/log/traefik'],
      File['/etc/init.d/traefik']]
  }

  exec { 'setcap-traefik':
    command => '/sbin/setcap \'cap_net_bind_service=ep\' /opt/traefik/traefik_linux-amd64'
  }
}
