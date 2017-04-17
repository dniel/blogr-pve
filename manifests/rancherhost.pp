# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /([tdp])-(host)-(\d{2})/ {
  include include pve::roles::rancher::host
}