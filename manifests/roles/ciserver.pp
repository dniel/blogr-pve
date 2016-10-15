class pve::roles::ciserver{
  include pve::profiles::common
  include pve::profiles::network
  include pve::profiles::logging::forwarder
}