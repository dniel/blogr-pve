# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /([tdp])-(app)-(\d{2})/ {
  include pve::roles::appserver
}