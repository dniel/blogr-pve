class pve::profiles::reverseproxy{

  $reverseproxy = hiera_hash('pve::profiles::reverseproxy')

  class { '::nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline'
  }

  nginx::resource::vhost { "${hostname}":
    server_name  => ["${hostname}", "${fqdn}"],
    access_log   => "/var/log/nginx/${hostname}.access.log",
    error_log    => "/var/log/nginx/${hostname}.error.log",
    listen_port  => "3000",
    ensure       => "present",
    proxy        => "http://${reverseproxy['app_host']}:3000"
  }
}