class pve::components::reverseproxy{
  class { '::nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline'
  }

  nginx::resource::vhost { 'front-1':
    server_name  => ['front-1', 'front-1.dragon.lan'],
    access_log   => '/var/log/nginx/blogr.access.log',
    error_log    => '/var/log/nginx/blogr.error.log',
    listen_port  => '3000',
    ensure       => 'present',
    proxy        => 'http://app-1:3000'
  }
}