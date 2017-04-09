class pve::profiles::rancher {
  class { 'docker':
    manage_service => false
  }
  class { 'rancher::server': }

  $tags = [$::environment,"traefik.tags=${::environment}"]
  ::consul::service { "${::hostname}-rancher":
    service_name => "rancher",
    address      => $::ipaddress_eth0,
    port         => 3000,
    tags         => $tags
  }
}