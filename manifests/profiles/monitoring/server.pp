class pve::profiles::monitoring::server {

  class { 'prometheus':
    init_style      => $init_style,
    config_template => 'pve/prometheus/prometheus.yaml.erb'
  }

  $tags = [$::environment,
    "traefik.tags=${::environment}",
    "traefik.frontend.rule=Host:dash.dragon.lan,dash",
    "traefik.frontend.passHostHeader=true"]

  ::consul::service { "${::hostname}-grafana":
    service_name => 'grafana',
    address      => $::ipaddress_eth0,
    port         => 3000,
    tags         => $tags
  } ~> Service['consul']

  class { 'grafana':
    version => '4.2.0'
  }

  #  grafana_datasource { 'prometheus':
  #    type              => 'prometheus',
  #    url               => 'http://localhost:9090',
  #    is_default        => true
  #  }
}