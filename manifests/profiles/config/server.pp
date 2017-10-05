class pve::profiles::config::server {

  class { '::consul':
    init_style  => 'debian',
    version     => '0.9.3',
    extra_options => ' -disable-host-node-id ',
    config_hash => {
      'bootstrap'   => true,
      'client_addr' => '0.0.0.0',
      'data_dir'    => '/opt/consul',
      'datacenter'  => 'pve',
      'log_level'   => 'INFO',
      'node_name'   => $::hostname,
      'server'      => true,
      'ui'          => true,
      'enable_script_checks' => true
    }
  }
}