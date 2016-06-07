class pve::profiles::blogr::database{
  vcsrepo { '/opt/blogr':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/dniel/blogr-pve'
  }
}