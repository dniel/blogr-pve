class pve::profiles::common::users{

  class { 'accounts':
    ssh_keys   => hiera_hash('accounts::ssh_keys', {}),
    users      => hiera_hash('accounts::users', {}),
    usergroups => hiera_hash('accounts::usergroups', {}),
    shell      => '/bin/bash'
  }

  accounts::account { 'jenkins':
    authorized_keys => ['jenkins'],
  }

  file { 'jenkins sudoers':
    ensure   => present,
    path     => '/opt/pve/.git/hooks/post-merge',
    source   => 'puppet:///files/etc/sudoers.d/jenkins',
    owner    => root,
    group    => root
  }
}
