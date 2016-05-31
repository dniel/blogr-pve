# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^front-\d+$/ {
  include pve::roles::frontserver
}