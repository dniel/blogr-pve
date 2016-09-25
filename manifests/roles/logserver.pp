class pve::roles::logserver{
  include pve::profiles::common
  include pve::profiles::network
  include pve::profiles::logging::server
}