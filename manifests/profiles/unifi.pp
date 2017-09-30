class pve::profiles::unifi {
  apt::source { 'testing-ubiquiti':
    location => 'http://www.ubnt.com/downloads/unifi/debian',
    repos    => 'testing ubiquiti',
    key      => {
      'id'     => '06E85760C0A52C50',
      'server' => 'keyserver.ubuntu.com',
    }
  }
}