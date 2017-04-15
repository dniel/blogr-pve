# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /([tdp])-(rancher)-(\d{2})/ {
  include pve::roles::rancher::server
}