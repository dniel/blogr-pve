# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^router-1$/ {
  include pve::roles::router::primary
}