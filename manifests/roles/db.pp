class pve::roles::db{
  include pve::profiles::common
  include pve::profiles::common::packages
  include pve::profiles::common::users
  include pve::profiles::database
  include pve::profiles::blogr::database
  include pve::profiles::logging::forwarder
  include pve::profiles::network
  include pve::profiles::config::agent
  include pve::profiles::monitoring::agent
}

class pve::roles::db::primary inherits pve::roles::db{
  include pve::profiles::database::primary
}

class pve::roles::db::standby inherits pve::roles::db{
  include pve::profiles::database::standby
}

