# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^([tdp])-(cfg)-(\d{2})$/ {
  include pve::roles::configserver
}