# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^db-\d+$/ {
  include pve::roles::dbserver
}