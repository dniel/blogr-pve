class pve::profiles::jenkins {

  include pve::profiles::common::packages::java8

  $tags = [$::environment,
    "traefik.tags=${::environment}",
    "traefik.frontend.rule=Host:ci.dragon.lan,ci",
    "traefik.frontend.passHostHeader=true"]

  ::consul::service { "${::hostname}-ci":
    service_name => 'ci',
    address      => $::ipaddress_eth0,
    port         => 8080,
    tags         => $tags
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
