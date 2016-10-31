class pve::profiles::jenkins{
  include ::jenkins

  # install node so that we can build blogr.
  class { 'nodejs':
    version      => 'v6.2.0',
    make_install => false
  }

  jenkins::job { 'blogr-build-job':
    config  => template("pve/jenkins/blogr-build-job.xml.erb"),
  }

  jenkins::plugin { 'ansicolor': }

  # GIT plugin and all its dependencies.
  jenkins::plugin { 'git': }
  jenkins::plugin { 'mailer': }
  jenkins::plugin { 'ssh-credentials': }
  jenkins::plugin { 'git-client': }
  jenkins::plugin { 'matrix-project': }
  jenkins::plugin { 'scm-api': }
  jenkins::plugin { 'structs': }
  jenkins::plugin { 'junit': }
  jenkins::plugin { 'script-security': }
  jenkins::plugin { 'display-url-api': }

  #Pipeline v2.4 plugin and all its dependencies.
  jenkins::plugin { 'workflow-aggregator': }
  jenkins::plugin { 'pipeline-utility-steps': }
  jenkins::plugin { 'workflow-cps':}
  jenkins::plugin { 'workflow-support':}
  jenkins::plugin { 'workflow-basic-steps':}
  jenkins::plugin { 'pipeline-input-step':}
  jenkins::plugin { 'pipeline-milestone-step':}
  jenkins::plugin { 'pipeline-build-step':}
  jenkins::plugin { 'pipeline-stage-view':}
  jenkins::plugin { 'workflow-multibranch':}
  jenkins::plugin { 'workflow-durable-task-step':}
  jenkins::plugin { 'workflow-api':}
  jenkins::plugin { 'pipeline-stage-step':}
  jenkins::plugin { 'workflow-scm-step':}
  jenkins::plugin { 'workflow-cps-global-lib':}
  jenkins::plugin { 'workflow-step-api':}
  jenkins::plugin { 'workflow-job':}

  jenkins::plugin { 'cloudbees-folder':}
  jenkins::plugin { 'git-server':}
  jenkins::plugin { 'ace-editor':}
  jenkins::plugin { 'jquery-detached':}

  jenkins::plugin { 'handlebars':}
  jenkins::plugin { 'pipeline-rest-api':}
  jenkins::plugin { 'momentjs':}

  jenkins::plugin { 'pipeline-graph-analysis':}
  jenkins::plugin { 'branch-api':}
  jenkins::plugin { 'durable-task':}

}
