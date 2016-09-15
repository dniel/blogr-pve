# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^router-2$/ {
  include pve::roles::router::standby
}