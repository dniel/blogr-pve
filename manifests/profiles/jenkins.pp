class pve::profiles::jenkins{
  include ::jenkins

  jenkins::plugin { 'git': }

}

