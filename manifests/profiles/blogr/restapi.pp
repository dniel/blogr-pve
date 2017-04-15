class pve::profiles::blogr::restapi {
  package { 'docker':
    ensure => 'purged',
  }

  file { "/opt/blogr":
    ensure => directory,
  }
  exec { "chown blogr":
    require => [File['/opt/blogr'], User['jenkins']],
    command => "/bin/chown -R jenkins.jenkins /opt/blogr",
  }
  class { 'nodejs':
    version      => 'latest',
    make_install => false
  }
  file { '/etc/init.d/node-app':
    content => template('pve/blogr/node-app.erb'),
    notify  => Service['node-app'],
    mode    => "755"
  }
  service { 'node-app':
    ensure  => running,
    enable  => true,
    require => [File['/etc/init.d/node-app']]
  }

  $tags = [$::environment, "traefik.tags=${::environment}"]
  ::consul::service { "${::hostname}-app":
    service_name => "app",
    address      => $::ipaddress_eth0,
    port         => 3000,
    tags         => $tags
  }

}