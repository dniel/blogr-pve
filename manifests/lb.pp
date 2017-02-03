# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /([tdp])-(lb)-(\d{2})/ {
  include pve::roles::loadbalancer
}