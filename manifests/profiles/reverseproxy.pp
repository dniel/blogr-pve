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
  }
  haproxy::balancermember { 'app-4':
    listening_service => 'puppet00',
    server_names      => 'app-4.dragon.lan',
    ipaddresses       => '10.0.3.7',
    ports             => '3000',
  }
}
