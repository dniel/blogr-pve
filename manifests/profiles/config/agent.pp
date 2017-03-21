class pve::profiles::config::agent{
  class { '::consul':
    config_hash => {
      'data_dir'   => '/opt/consul',
      'datacenter' => 'east-aws',
      'log_level'  => 'INFO',
      'node_name'  => 'agent',
      'retry_join' => ['10.0.50.106'],
    }
  }
}