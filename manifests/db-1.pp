# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^db-1$/ {
  include pve::roles::dbserver::primary
}