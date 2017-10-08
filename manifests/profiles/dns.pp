class pve::profiles::dns {

  class { '::dnsmasq':
    configs_hash    => {},
    hosts_hash      => {},
    dhcp_hosts_hash => {},
  }

  dnsmasq::conf { 'consul':
    ensure  => present,
    content => 'server=/consul/10.0.50.10#8600',
  }
}