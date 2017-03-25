class pve::profiles::blogr::lb(
  $app_hosts,
  $server_names
){
  class { 'haproxy':
    package_ensure => 'absent',
    service_ensure => 'absent'
  }

  $tags = $::hostname ? {
    /^t-/    => ['test'],
    /^p-/    => ['prod'],
    /^d-/    => ['dev'],
    default  => []
  }

  ::consul::service { "${::hostname}-lb":
    checks        => [
      {
        http     => 'http://localhost:80',
        interval => '5s'
      }
    ],
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
    source  => 'puppet:///modules/pve/etc/traefik/traefik.toml',
    owner   => $traefikUser,
    group   => $traefikGroup,
    require => [
      File['/etc/traefik'],
      User[$traefikUser],
      Group[$traefikGroup]
    ]
  }

  file { '/etc/init.d/traefik':
    source  => 'puppet:///modules/pve/etc/init.d/traefik',
    mode => "755",
    notify => Service['traefik-service']
  }

  service { 'traefik-service':
    ensure  => running,
    enable  => true,
    require => [File['/etc/init.d/traefik']]
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
    noop => true,
    command => '/sbin/setcap \'cap_net_bind_service=ep\' /opt/traefik/traefik_linux-amd64'
  }
}
