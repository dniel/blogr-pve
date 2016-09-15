class pve::roles::loginserver{
  include pve::profiles::common
  include pve::profiles::network
  include pve::profiles::logging::forwarder
}