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

  haproxy::frontend { 'blogr_frontend':
    ipaddress       => $::ipaddress,
    ports           => '3000',
    mode            => 'http',
    options         => { 'balance' => 'roundrobin' }
  }

  haproxy::backend { 'blogr_backend':
    listening_service => 'blogr',
    server_names      => ['app-2', 'app-4'],
    ipaddresses       => ['app-2.dragon.lan', 'app-4.dragon.lan'],
    ports             => '3000',
    options           => {
      'option'  => [
        'httpchk HEAD /api/system/ping HTTP/1.1',
      ],
    }
  }
}
