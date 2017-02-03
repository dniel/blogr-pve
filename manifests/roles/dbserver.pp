class pve::roles::dbserver{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::database
  include pve::profiles::blogr::database
  include pve::profiles::network
  include pve::profiles::logging::forwarder
}

class pve::roles::dbserver::primary inherits pve::roles::dbserver{
  include pve::profiles::database::primary
}

class pve::roles::dbserver::standby inherits pve::roles::dbserver{
  include pve::profiles::database::standby
}

