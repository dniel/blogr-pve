class pve::profiles::monitoring::server {
  class { 'prometheus':
    scrape_configs => [{
      job_name          => 'overwritten-default',
      consul_sd_configs => {
        server   => '127.0.0.1:8500'
      }
    }]
  }

  class { 'grafana':
  }

  grafana_datasource { 'prometheus':
    type              => 'prometheus',
    url               => 'http://localhost:9090',
    is_default        => true,
  }
}