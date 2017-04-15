class pve::profiles::rancher::host($rancher_url) {
  class { 'rancher::server': }

  package { 'docker':
    ensure => 'installed',
  }

  class { 'rancher':
    registration_url =>
      'http://rancher.service.consul:8080/v1/scripts/443B929165E879B9F533:1483142400000:7C5YD5HkhiDu4foMN6V1XzFo6IY',
    agent_address    => $::ipaddress_eth0
  }

}