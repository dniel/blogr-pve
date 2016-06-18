class pve::profiles::blogr::restapi{

  $config = hiera_hash('pve::profiles::blogr')

  class { 'nodejs':
    version      => 'v6.2.0',
    make_install => false
  }

  vcsrepo { '/opt/blogr':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/dniel/blogr-workshop'
  }->
  exec { 'npm install' :
    cwd  => '/opt/blogr',
    user => 'root',
    path => '/usr/local/node/node-default/bin',
    require => Class['nodejs']
  }->
  file { '/etc/init.d/node-app':
    source => 'puppet:///modules/pve/app/etc/init.d/node-app',
    notify => Service['node-app'],
    require => Exec['npm install'],
    mode => "755"
  }

  service { 'node-app':
    ensure  => running,
    enable  => true,
    require => [File['/etc/init.d/node-app'], Exec['npm install']]
  }
}