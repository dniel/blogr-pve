class pve::roles::puppetserver{
  include pve::profiles::common
  include pve::profiles::puppetmaster
  include pve::profiles::logging::forwarder
}