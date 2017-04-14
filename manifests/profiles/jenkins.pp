class pve::profiles::jenkins {
  $tags = [$::environment,
    "traefik.tags=${::environment}",
    "traefik.frontend.rule=Host:ci.dragon.lan,ci",
    "traefik.frontend.passHostHeader=true"]

  ::consul::service { "${::hostname}-ci":
    service_name => 'ci',
    address      => $::ipaddress,
    port         => 8080,
    tags         => $tags
  }

  apt::source { 'webupd8team':
    location => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
    repos    => 'main',
    key      => {
      'id'     => 'EEA14886',
      'server' => 'keyserver.ubuntu.com',
    },
    notify   => Exec["apt_update"]
  }

  exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';

    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }

  package { 'oracle-java8-installer':
    ensure  => 'installed',
    require => [Apt::Source['webupd8team'], Exec['set-licence-selected'], Exec['set-licence-seen']],
  } ->
  package { 'oracle-java8-set-default':
    ensure => 'installed',
  }

  class { 'jenkins':
    version      => 'latest',
    lts          => false,
    install_java => false
  }

  # install node so that we can build blogr.
  class { 'nodejs':
    version      => 'latest',
    make_install => false
  }

  jenkins::job { 'blogr-build-job':
    config => template("pve/jenkins/blogr-build-job.xml.erb"),
  }

  jenkins::job { 'blogr-pve-job':
    config => template("pve/jenkins/blogr-pve-job.xml.erb"),
  }

  include pve::profiles::jenkins::ansicolor
  include pve::profiles::jenkins::git
  include pve::profiles::jenkins::blueocean
  include pve::profiles::jenkins::pipeline
  include pve::profiles::jenkins::mattermost

}
