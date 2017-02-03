# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^([tdp])-(ci)-(\d{2})$/ {
  include pve::roles::ciserver
}