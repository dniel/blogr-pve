class pve::profiles::reverseproxy(
  $app_hosts
){

  package { 'nginx':
    ensure => purged,
  }
  package { 'nginx-common':
    ensure => purged,
  }

  include ::haproxy
  haproxy::listen { 'puppet00':
    collect_exported => false,
    ipaddress        => $::ipaddress,
    ports            => '3000',
    mode             => 'http',
  }

  haproxy::balancermember { 'app-2':
    listening_service => 'puppet00',
    server_names      => 'app-2',
    ipaddresses       => '10.0.3.9',
    options           => 'check fall 3 rise 2'
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
    mode => 'http',
    options => {
      'option'  => [
        'httpchk HEAD /api/system/ping HTTP/1.1',
      ],
      'balance' => 'roundrobin',
    },
  }
}
