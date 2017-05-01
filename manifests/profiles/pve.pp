class pve::profiles::pve {
  apt::source { 'pve-no-subscription':
    location => 'http://download.proxmox.com/debian',
    repos    => 'pve-no-subscription',
    key      => {
      'id'     => 'BE25 7BAA 5D40 6D01 157D  323E C23A C7F4 9887 F95A',
      'server' => 'download.proxmox.com',
    }
  }
}