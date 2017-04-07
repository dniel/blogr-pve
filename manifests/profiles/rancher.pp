class pve::profiles::rancher {
  class { 'docker':
    manage_service => false
  }
  class { 'rancher::server': }
}