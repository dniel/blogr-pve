class pve::profiles::network(
  $hostname,
  $ipaddress,
  $gateway,
  $netmask = "255.255.255.0",
  $mtu = "1495"
){

  class{ '::network':
    hostname => $hostname
  }

  network::interface { 'eth0':
    ipaddress => $ipaddress,
    netmask   => $netmask,
    gateway   => $gateway,
    mtu       => $mtu
  }

}
