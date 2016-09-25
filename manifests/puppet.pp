# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^puppet-1$/ {
  include pve::roles::puppetserver
}