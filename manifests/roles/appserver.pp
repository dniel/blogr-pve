class pve::roles::appserver{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::blogr::website
  include pve::profiles::blogr::restapi
  include pve::profiles::network
  include pve::profiles::logging::forwarder
  include pve::profiles::logging::forwarder::blogr
}