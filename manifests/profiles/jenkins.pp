class pve::profiles::jenkins{
  include ::jenkins

  jenkins::plugin { 'git': }
  jenkins::plugin { 'workflow-aggregator': }
}

