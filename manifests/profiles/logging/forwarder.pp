class pve::profiles::logging::forwarder{

  class { 'filebeat':
    outputs => {
      'logstash'     => {
        'hosts' => [
          'log-1.dragon.lan:5044'
        ]
      },
    },
  }
}


class pve::profiles::logging::forwarder::nginx{

  filebeat::prospector { 'nginx':
    paths    => [
      '/var/log/nginx/*',
    ],
    exclude_files => ['.gz$','.[0-9]$'],
    doc_type => 'nginx',
  }
}

class pve::profiles::logging::forwarder::blogr{

  filebeat::prospector { 'blogr':
    paths    => [
      '/opt/blogr/log/*',
    ],
    exclude_files => ['.gz$','.[0-9]$'],
    doc_type => 'blogr',
  }
}