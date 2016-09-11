class pve::profiles::logging::server{
  class { 'elasticsearch':
    java_install => true,
    manage_repo  => true,
    repo_version => '2.x',
    autoupgrade => true
  }

  elasticsearch::instance { 'es-01': }

  include kibana4

}