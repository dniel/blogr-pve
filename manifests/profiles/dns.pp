class pve::profiles::unifi {

  include dnsmasq
  dnsmasq::conf { 'consul':
    ensure  => present,
    content => 'server=/consul/127.0.0.1#8600',
  }

}