# https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

node /^chat-\d+$/ {
  include pve::roles::chatserver
}