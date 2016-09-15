# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^login-\d+$/ {
  include pve::roles::loginserver
}