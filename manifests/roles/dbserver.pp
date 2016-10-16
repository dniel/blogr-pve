class pve::roles::dbserver::primary{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::database::primary
  include pve::profiles::blogr::database
  include pve::profiles::network
  include pve::profiles::logging::forwarder
}

class pve::roles::dbserver::standby{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::database::standby
  include pve::profiles::network
  include pve::profiles::logging::forwarder
}

