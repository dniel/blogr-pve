# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^pve\d+$/ {
  include pve::roles::pveserver
}