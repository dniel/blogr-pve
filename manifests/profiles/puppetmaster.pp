class pve::profiles::puppetmaster{

  # Agent and puppetmaster:
  class { '::puppet':
    server         => true,
    server_foreman => false
  }

}
