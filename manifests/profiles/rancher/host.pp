class pve::profiles::rancher::host (
  $rancher_url
) {
  package { 'docker':
    ensure => 'installed',
  }

  class { 'rancher':
    registration_url => $rancher_url,
    agent_address    => $::ipaddress_eth0
  }
}