# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^ci-\d+$/ {
  include pve::roles::ciserver
}