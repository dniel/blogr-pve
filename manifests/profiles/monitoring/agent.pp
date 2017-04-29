class pve::profiles::monitoring::agent{

  $init_style = $::initsystem ? {
    /systemd/ => 'systemd',
    default   => 'debian'
  }

  class { 'prometheus::node_exporter':
    init_style => $init_style
  }

}