class pve::profiles::blogr::restapi{
  require nodejs

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