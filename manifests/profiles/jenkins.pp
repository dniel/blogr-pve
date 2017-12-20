class pve::profiles::jenkins {

  include pve::profiles::common::packages::java8
  include pve::profiles::common::packages::docker

  $tags = [$::environment,
    "traefik.tags=${::environment}",
    "traefik.frontend.rule=Host:ci.dniel.in,ci",
    "traefik.frontend.passHostHeader=true"]

  ::consul::service { "${::hostname}-ci":
    service_name => 'ci',
    address      => $::ipaddress_eth0,
    port         => 8080,
    tags         => $tags
  }

  ::consul::check { 'check_jenkins_http_status':
    script   => "/usr/lib/nagios/plugins/check_http -H localhost -p 8080 -j HEAD",
    interval => '30s'
  }

  file { '/opt/ecs-deploy':
    source  => 'puppet:///modules/pve/opt/ecs-deploy',
    owner   => "jenkins",
    group   => "jenkins",
    mode    => "700",
    require => [
      User["jenkins"],
      Group["jenkins"]]
  }


  class { 'jenkins':
    version      => 'latest',
    lts          => false,
    install_java => false
  }


  jenkins::job { 'blogr-build-job':
    config => template("pve/jenkins/blogr-build-job.xml.erb"),
  }

  jenkins::job { 'puppet-apply-job':
    config => template("pve/jenkins/puppet-apply-job.xml.erb"),
  }

  jenkins::job { 'puppet-ci-job':
    config => template("pve/jenkins/puppet-ci-job.xml.erb"),
  }

  jenkins::job { 'cleanup-elastic-indices':
    config => template("pve/jenkins/cleanup-elastic-indices.xml.erb"),
  }

  jenkins::job { 'cleanup-ci-docker':
    config => template("pve/jenkins/cleanup-docker-builds.xml.erb"),
  }

  include pve::profiles::jenkins::ansicolor
  include pve::profiles::jenkins::git
  include pve::profiles::jenkins::blueocean
  include pve::profiles::jenkins::pipeline
  include pve::profiles::jenkins::mattermost

}
