class pve::profiles::logging::forwarder (
  $log_server,
  $log_port
) {

  class { 'filebeat':
    outputs => {
      'logstash' => {
        'hosts' => [
          "${log_server}:${log_port}"
        ]
      },
    },
  }

  filebeat::prospector { 'syslogs':
    paths    => [
      '/var/log/auth.log',
      '/var/log/syslog',
    ],
    doc_type => 'syslog',
  }
}

class pve::profiles::logging::forwarder::blogr {
  filebeat::prospector { 'blogr':
    paths         => [
      '/opt/blogr/log/*',
    ],
    exclude_files => ['.gz$', '.[0-9]$'],
    doc_type      => 'blogr',
  }
}

class pve::profiles::logging::forwarder::jenkins {
  filebeat::prospector { 'jenkins':
    paths         => [
      '/var/log/jenkins/*',
    ],
    exclude_files => ['.gz$', '.[0-9]$'],
    doc_type      => 'jenkins',
  }
}

class pve::profiles::logging::forwarder::traefik_access {
  filebeat::prospector { 'traefik_access':
    paths         => [
      '/var/log/traefik/access*',
    ],
    exclude_files => ['.gz$', '.[0-9]$'],
    doc_type      => 'traefik_access',
  }
}

class pve::profiles::logging::forwarder::traefik_app {
  filebeat::prospector { 'traefik_app':
    paths         => [
      '/var/log/traefik/traefik*',
    ],
    exclude_files => ['.gz$', '.[0-9]$'],
    doc_type      => 'traefik_application',
  }
}