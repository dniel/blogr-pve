class pve::profiles::dns {

  include dnsmasq
  dnsmasq::conf { 'consul':
    ensure  => present,
    content => 'server=/consul/10.0.50.10#8600',
  }
}