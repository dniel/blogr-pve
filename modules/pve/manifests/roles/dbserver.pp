class pve::roles::dbserver::primary{
  include pve::profiles::common
  include pve::profiles::database::primary
  include pve::profiles::network
}

class pve::roles::dbserver::standby{
  include pve::profiles::common
  include pve::profiles::database::standby
  include pve::profiles::network
}

