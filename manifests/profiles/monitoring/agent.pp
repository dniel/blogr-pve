class pve::profiles::monitoring::agent {

  $init_style = $::initsystem ? {
    /systemd/ => 'systemd',
    default   => 'debian'
  }

  class { 'prometheus::node_exporter':
    init_style => $init_style
  }


  $tags = [$::environment, "monitor"]

  ::consul::service { "${::hostname}-node_exporter":
    service_name => 'node_exporter',
    address      => $::ipaddress_eth0,
    port         => 9100,
    tags         => $tags
  }

}