class pve::roles::app{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::blogr::restapi
  include pve::profiles::network
  include pve::profiles::logging::forwarder
  include pve::profiles::logging::forwarder::blogr
  include pve::profiles::config::agent
  include pve::profiles::monitoring::agent
}