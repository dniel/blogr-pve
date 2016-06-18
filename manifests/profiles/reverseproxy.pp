class pve::profiles::reverseproxy{

  $reverseproxy = hiera_hash('pve::profiles::reverseproxy')

  class { '::nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline'
  }

  nginx::resource::upstream { 'backend':
    ensure => "present",
    members => ["app-1:3000","app-2:3000"],
  }

  nginx::resource::vhost { "${hostname}":
    proxy        => "http://backend"
  }
}
