# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /([tdp])-(monitoring)-(\d{2})/ {
  include pve::roles::monitoringserver
}