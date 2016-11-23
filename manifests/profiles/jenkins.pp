class pve::profiles::jenkins{
  class { 'jenkins':
    version => 'latest'
  }

  # install node so that we can build blogr.
  class { 'nodejs':
    version      => 'latest',
    make_install => false
  }

  jenkins::job { 'blogr-build-job':
    config  => template("pve/jenkins/blogr-build-job.xml.erb"),
  }

  jenkins::job { 'blogr-pve-job':
    config  => template("pve/jenkins/blogr-pve-job.xml.erb"),
  }

  jenkins::plugin { 'ansicolor': }

  include pve::profiles::jenkins::ansicolor
  include pve::profiles::jenkins::git
  include pve::profiles::jenkins::blueocean
  include pve::profiles::jenkins::pipeline

}
