class pve::profiles::pve {
  apt::source { 'pve-no-subscription':
    location => 'http://download.proxmox.com/debian',
    repos    => 'pve-no-subscription',
    key      => {
      'id'     => 'BE257BAA5D406D01157D323EC23AC7F49887F95A',
      'server' => 'download.proxmox.com',
    }
  }
}