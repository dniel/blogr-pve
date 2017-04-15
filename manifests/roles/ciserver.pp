class pve::roles::ciserver{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::network
  include pve::profiles::jenkins
  include pve::profiles::logging::forwarder
  include pve::profiles::logging::forwarder::jenkins
  include pve::profiles::config::agent
}