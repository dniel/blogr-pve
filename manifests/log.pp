# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^log\d+$/ {
  include pve::roles::logserver
}