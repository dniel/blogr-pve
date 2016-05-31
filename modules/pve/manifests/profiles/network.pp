class pve::profiles::network{
  class{ 'network':
    hostname => 'front-1'
  }

  network::interface { 'eth0':
    ipaddress => '10.0.1.201',
    netmask   => '255.255.255.0',
    gateway   => '10.0.1.204'
  }

}