class pve::profiles::config::server {
  class { '::consul':
    init_style  => 'debian',
    version     => '0.8.0',
    config_hash => {
      'bootstrap'   => true,
      'client_addr' => '0.0.0.0',
      'data_dir'    => '/opt/consul',
      'datacenter'  => 'pve',
      'log_level'   => 'INFO',
      'node_name'   => $::hostname,
      'server'      => true,
      'ui'          => true,
      'ui_dir'           => '/opt/consul/ui'
    }
  }
}