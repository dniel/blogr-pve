class pve::profiles::common{
  package { 'git':
    ensure => 'installed',
  }

  package { 'vim':
    ensure => 'installed',
  }

  package { 'sudo':
    ensure => 'installed',
  }

  package { 'lsb-release':
    ensure => installed,
  }

  package { 'ca-certificates':
    ensure => installed,
  }

  file { "/opt/pve/apply.sh":
    mode => "700",
  }

}