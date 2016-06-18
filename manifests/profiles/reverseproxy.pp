class pve::profiles::reverseproxy{

  $reverseproxy = hiera_hash('pve::profiles::reverseproxy')
  $app_hosts = $reverseproxy['app_hosts']

  class { '::nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline'
  }

  nginx::resource::upstream { 'backend':
    ensure => "present",
    members => $app_hosts
  }

  nginx::resource::vhost { "${hostname}":
    proxy        => "http://backend"
  }
}
