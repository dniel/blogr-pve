class pve::roles::chatserver{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::network
  include pve::profiles::logging::forwarder
  include pve::profiles::chatserver
  include pve::profiles::config::agent
}