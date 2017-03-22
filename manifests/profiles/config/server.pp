class pve::profiles::config::server{
  class { '::consul':
    init_style => 'debian',
    config_hash => {
      'bootstrap_expect' => 1,
      'client_addr'      => '0.0.0.0',
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'pve',
      'log_level'        => 'INFO',
      'node_name'        => "${::hostname}-server",
      'server'           => true,
      'ui_dir'           => '/opt/consul/ui',
    }
  }

  ######
  ## Load balancers
  ## PROD
  ::consul::service { 'prod-lb-1':
    service_name => "lb",
    address => "10.0.10.100",
    port    => 80,
    tags    => ['prod']
  }

  ::consul::service { 'prod-lb-2':
    service_name => "lb",
    address => "10.0.10.101",
    port    => 80,
    tags    => ['prod']
  }

  ####
  # TEST
  #
  ::consul::service { 'test-lb-2':
    service_name => "lb",
    address => "10.0.30.100",
    port    => 80,
    tags    => ['test']
  }

  ####
  ## APP services
  ## PROD
  ::consul::service { 'prod-app-1':
    service_name => "app",
    address => "10.0.20.102",
    port    => 3000,
    tags    => ['prod']
  }
  ::consul::service { 'prod-app-2':
    service_name => "app",
    address => "10.0.20.100",
    port    => 3000,
    tags    => ['prod']
  }
  ::consul::service { 'prod-app-3':
    service_name => "app",
    address => "10.0.20.103",
    port    => 3000,
    tags    => ['prod']
  }

  ::consul::service { 'prod-app-4':
    service_name => "app",
    address => "10.0.20.104",
    port    => 3000,
    tags    => ['prod']
  }

  ########
  ## TEST App serves
  ##
  ::consul::service { 'test-app-1':
    service_name => "app",
    address => "10.0.30.101",
    port    => 3000,
    tags    => ['test']
  }

  ::consul::service { 'test-app-2':
    service_name => "app",
    address => "10.0.30.102",
    port    => 3000,
    tags    => ['test']
  }





}