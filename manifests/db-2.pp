# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^db-2$/ {
  include pve::roles::dbserver::standby
}