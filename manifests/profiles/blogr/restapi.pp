class pve::profiles::blogr::restapi{
  require nodejs

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
    source => 'puppet:///modules/pve/node-app'
  }~>
  service { 'node-app':
    ensure => running,
    enable => true,
  }
}