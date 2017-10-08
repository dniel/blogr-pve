class pve::profiles::dns {

  include dnsmasq
  dnsmasq::conf { 'consul-forwarding':
    ensure  => present,
    content => 'server=/consul/10.0.50.10#8600',
  }

  dnsmasq::conf { 'consul-file':
    prio   => 20,
    ensure => present,
    source => 'puppet:///files/etc/dnsmasq.d/consul-file',
  }
}