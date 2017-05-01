class pve::profiles::monitoring::server {

  class { 'prometheus':
    init_style      => $init_style,
    config_template => 'pve/prometheus/prometheus.yaml.erb'
  }

  class { 'grafana':
    version => '4.2.0'
  }

  #  grafana_datasource { 'prometheus':
  #    type              => 'prometheus',
  #    url               => 'http://localhost:9090',
  #    is_default        => true
  #  }
}