class pve::profiles::node{
  class { 'nodejs':
    version      => 'v6.2.0',
    make_install => false
  }
}