class pve::roles::loadbalancer{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::blogr::lb
  include pve::profiles::network
  include pve::profiles::logging::forwarder
  include pve::profiles::config::agent
}