class pve::roles::log{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::network
  include pve::profiles::logging::server
  include pve::profiles::config::agent
  include pve::profiles::monitoring::agent
}