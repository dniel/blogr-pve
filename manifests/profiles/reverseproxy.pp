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
    server_names      => 'app-2.dragon.lan',
    ipaddresses       => '10.0.3.9',
    ports             => '3000',
    options           => 'check fall 3 rise 2'
  }

  haproxy::balancermember { 'app-4':
    listening_service => 'puppet00',
    server_names      => 'app-4.dragon.lan',
    ipaddresses       => '10.0.3.7',
    ports             => '3000',
    options           => 'check fall 3 rise 2'
  }


  haproxy::backend { 'blogr-backend':
    options => {
      'option'  => [
        'httpchk HEAD /api/system/ping HTTP/1.1',
      ],
      'balance' => 'roundrobin',
    },
  }
}
