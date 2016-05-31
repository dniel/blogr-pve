# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^app-\d+$/ {
  include pve::roles::appserver
}