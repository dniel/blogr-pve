class pve::profiles::jenkins::git{

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
}