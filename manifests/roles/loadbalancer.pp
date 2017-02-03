class pve::roles::loadbalancer{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::reverseproxy
  include pve::profiles::network
  include pve::profiles::logging::forwarder
  include pve::profiles::logging::forwarder::nginx
}