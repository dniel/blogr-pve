class pve::roles::appserver{
  include pve::profiles::common
  include pve::profiles::blogr
  include pve::profiles::network
}