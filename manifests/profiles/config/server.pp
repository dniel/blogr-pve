class pve::profiles::config::server{
  class { '::consul':
    init_style => 'debian',
    config_hash => {
      'bootstrap_expect' => 1,
      'client_addr'      => '0.0.0.0',
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'pve',
      'log_level'        => 'INFO',
      'node_name'        => "${::hostname}-server",
      'server'           => true,
      'ui_dir'           => '/opt/consul/ui',
    }
  }
}