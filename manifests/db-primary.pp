# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /([tdp])-(db-primary)-(\d{2})/ {
  include pve::roles::dbserver::primary
}