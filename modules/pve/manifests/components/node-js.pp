class pve::components::node-js{
  class { 'nodejs':
    version      => 'v6.2.0',
    make_install => false
  }
}
