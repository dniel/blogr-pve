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

  filebeat::prospector { 'syslogs':
    paths    => [
      '/var/log/auth.log',
      '/var/log/syslog',
    ],
    doc_type => 'syslog-beat',
  }
}


class pve::profiles::logging::forwarder::nginx{

  filebeat::prospector { 'nginx':
    paths    => [
      '/var/log/nginx/*',
    ],
    exclude_files => ['.gz$'],
    doc_type => 'nginx-access',
  }
}