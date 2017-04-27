class pve::roles::loadbalancer{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::lb
  include pve::profiles::network
  include pve::profiles::logging::forwarder
  include pve::profiles::logging::forwarder::traefik_access
  include pve::profiles::logging::forwarder::traefik_app
  include pve::profiles::config::agent
}