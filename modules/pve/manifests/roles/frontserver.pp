class pve::roles::frontserver{
  include pve::profiles::reverseproxy
  include pve::profiles::network
}