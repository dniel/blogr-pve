# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /([tdp])-(chat)-(\d{2})$/ {
  include pve::roles::chatserver
}