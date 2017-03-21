class pve::roles::configserver{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::network
  include pve::profiles::logging::forwarder
  include pve::profiles::config::server
}