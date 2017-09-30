class pve::roles::ci{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::jenkins
  include pve::profiles::logging::forwarder
  include pve::profiles::logging::forwarder::jenkins
  include pve::profiles::config::agent
  include pve::profiles::monitoring::agent
}