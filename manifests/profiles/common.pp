class pve::profiles::common{

  include unattended_upgrades
  
  class { 'timezone':
    timezone => 'Europe/Oslo',
  }

  class { 'apt':
    update => {
      frequency => 'daily',
    }
  }

  class { 'ssh::server':
    storeconfigs_enabled => false,
    options              => {
      'PermitRootLogin'  => 'yes',
    },
  }

  class { 'locales':
    default_locale  => 'nb_NO.UTF-8',
    locales         => ['en_US.UTF-8 UTF-8', 'nb_NO.UTF-8 UTF-8'],
  }

  file { "/opt/pve/apply.sh":
    mode => "744",
  }

  exec {"chown pve":
    require => [File['/opt/pve'], User['jenkins']],
    command => "chmod -R jenkins.jenkins /opt/pve",

  }

  exec {"chown blogr":
    require => [File['/opt/blogr'], User['jenkins']],
    command => "chmod -R jenkins.jenkins /opt/blogr",
  }

  file { 'post-hook':
    ensure   => absent,
    path     => '/opt/pve/.git/hooks/post-merge',
    content  => 'cd /opt/pve ; ./apply.sh',
    mode     => "0755",
    owner    => root,
    group    => root
  }->
  cron { 'puppet-apply':
    ensure  => absent,
    command => "cd /opt/pve ; /usr/bin/git pull",
    user    => root,
    minute  => '*/60',
    require => File['post-hook']
  }

}
