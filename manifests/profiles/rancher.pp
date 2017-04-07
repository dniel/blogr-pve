class pve::profiles::rancher {
  class { 'docker':
  }
  class { 'rancher::server': }
}