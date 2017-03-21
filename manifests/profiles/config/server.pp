class pve::profiles::config::server{
  class { '::consul':
    config_hash => {
      'bootstrap_expect' => 1,
      'client_addr'      => '0.0.0.0',
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'east-aws',
      'log_level'        => 'INFO',
      'node_name'        => 'server',
      'server'           => true,
      'ui_dir'           => '/opt/consul/ui',
    }
  }
}