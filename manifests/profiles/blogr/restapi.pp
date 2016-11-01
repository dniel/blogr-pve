class pve::profiles::blogr::restapi{

  class { 'nodejs':
    version      => 'v6.2.0',
    make_install => false
  }
  file { '/etc/init.d/node-app':
    source => 'puppet:///modules/pve/app/etc/init.d/node-app',
    notify => Service['node-app'],
    mode => "755"
  }
  service { 'node-app':
    ensure  => running,
    enable  => true,
    require => [File['/etc/init.d/node-app']]
  }
}