# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /([tdp])-(log)-(\d{2})/ {
  include pve::roles::logserver
}