class pve::roles::logserver{
  include pve::profiles::common
  include pve::profiles::network
  include pve::profiles::logging::server

  # Agent
  class { '::puppet':
    puppetmaster => "puppet-1.dragon.lan",
    server => false
  }

}