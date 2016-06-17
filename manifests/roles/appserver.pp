class pve::roles::appserver{
  include pve::profiles::common
  include pve::profiles::blogr::website
  include pve::profiles::blogr::restapi
  include pve::profiles::network
}