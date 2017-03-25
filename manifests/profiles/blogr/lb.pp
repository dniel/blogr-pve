class pve::profiles::blogr::lb(
  $app_hosts,
  $server_names
){
  include ::haproxy

  haproxy::balancermember { 'haproxy':
    listening_service => 'blogr_frontend',
    server_names      => $server_names,
    ipaddresses       => $app_hosts,
    options           => 'check fall 3 rise 2',
    ports             => '3000'
  }

  haproxy::frontend { 'blogr_frontend':
    ipaddress => '0.0.0.0',
    ports     => '80',
    mode      => 'http',
    options   => {
      'use_backend' => 'blogr_backend'
    }
  }

  haproxy::backend { 'blogr_backend':
    mode    => 'http',
    options => {
      'option'  => [
        'httpchk HEAD /api/system/ping HTTP/1.1',
      ],
      'balance' => 'roundrobin',
    },
  }

  $tags = $::hostname ? {
    /^t-/ => ['test'],
    /^p-/ => ['prod'],
    /^d-/ => ['dev'],
    default  => []
  }

  ::consul::service { "${::hostname}-lb":
    checks  => [
      {
        http   => 'http://localhost:80',
        interval => '5s'
      }
    ],
    service_name => "lb",
    address      => "${::ipaddress}",
    port         => 80,
    tags          => $tags
  }

  # create a directory
  file { '/opt/traefik':
    ensure => 'directory',
  }

  # create a directory
  file { '/var/log/traefik':
    ensure => 'directory'
  }

  # create a directory
  file { '/etc/traefik':
    ensure => 'directory'
  }

  file { '/etc/traefik/traefik.toml':
    source => 'puppet:///modules/pve/etc/traefik/traefik.toml',
    require => [File['/etc/traefik']]
  }

  file { '/opt/traefik/traefik_linux-amd64':
    source => 'puppet:///modules/pve/opt/traefik/traefik_linux-amd64',
    mode => "700",
    require => [File['/opt/traefik'],File['/etc/traefik'],File['/var/log/traefik']]
  }
}
