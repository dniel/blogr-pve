class pve::profiles::blogr::restapi{
  vcsrepo { '/opt/blogr':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/dniel/blogr-workshop'
  }

  exec { 'npm install' :
    cwd => '/opt/blogr',
    user => 'root',
    path => '/usr/local/node/node-default/bin'
  }

  service { 'node-app':
    ensure => running,
    enable => true,
  }
}