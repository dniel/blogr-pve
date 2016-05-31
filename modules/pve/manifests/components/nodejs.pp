class pve::components::nodejs{
  class { '::nodejs':
    version      => 'v6.2.0',
    make_install => false
  }
}
