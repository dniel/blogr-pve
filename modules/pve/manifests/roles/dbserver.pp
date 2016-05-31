class pve::roles::dbserver{
  include pve::profiles::database
  include pve::profiles::network
}