class pve::profiles::network{
  $network = hiera_hash('pve::profiles::network')

  class{ '::network':
    hostname => "${network['hostname']}"
  }

  network::interface { 'eth0':
    ipaddress => "${network['ipaddress']}",
    netmask   => '255.255.255.0',
    gateway   => "${network['gateway']}",
    mtu       => '1495'
  }

}
