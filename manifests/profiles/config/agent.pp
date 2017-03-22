class pve::profiles::config::agent{
  class { '::consul':
    init_style => 'debian',
    config_hash => {
      'data_dir'   => '/opt/consul',
      'datacenter' => 'pve',
      'log_level'  => 'INFO',
      'node_name'  => "${::hostname}-agent",
      'retry_join' => ['10.0.50.106'],
    }
  }
}
