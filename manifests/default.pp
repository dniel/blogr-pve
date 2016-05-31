node default{
  class{ 'network':
    hostname => 'front-1'
  }

  network::interface { 'eth0':
    enable_dhcp => false,
    ipaddress => '10.0.1.201',
    netmask   => '255.255.255.0',
  }

}