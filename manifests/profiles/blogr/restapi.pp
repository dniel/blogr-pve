class pve::profiles::blogr::restapi{

  $config = hiera_hash('pve::profiles::blogr')
  $db_name = $config['db_name']
  $db_host = $config['db_host']
  $db_user = $config['db_user']
  $db_password = $config['db_password']

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
  }->
  file { '/etc/init.d/node-app':
    source => 'puppet:///modules/pve/app/etc/init.d/node-app'
  }->
  file { '/etc/environment':
    content => template('pve/app/etc/environment.erb')
  }~>
  service { 'node-app':
    ensure => running,
    enable => true,
  }
}