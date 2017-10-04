class pve::profiles::config::server {

  service { 'consul':
    ensure => 'running'
  }

  class { '::consul':
    init_style  => 'debian',
    version     => '0.9.3',
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