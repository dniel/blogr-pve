class pve::profiles::blogr::restapi{
  vcsrepo { '/opt/blogr':
    ensure   => present,
    provider => git,
    source   => 'git@github.com:dniel/blogr-pve.git',
  }
}