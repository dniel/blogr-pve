class pve::profiles::unifi {
  apt::source { 'testing-ubiquiti':
    location => 'http://www.ubnt.com/downloads/unifi/debian',
    repos    => 'ubiquiti',
    release  => 'testing',
    key      => {
      'id'     => '4A228B2D358A5094178285BE06E85760C0A52C50',
      'server' => 'keyserver.ubuntu.com',
    }
  }

  service { 'unifi':
    ensure => 'running',
  }

  service { 'mongodb':
    ensure => 'running',
  }

  ::consul::service { "${::hostname}-unifi":
    service_name => "unifi",
    address      => $::ipaddress_eth0,
    port         => 8080,
    tags         => [$::environment]
  } ~> Service['consul']
}