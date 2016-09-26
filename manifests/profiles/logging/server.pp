class pve::profiles::logging::server{
  class { 'elasticsearch':
    java_install => true,
    manage_repo  => true,
    repo_version => '2.x',
  }

  # elasticsearch need it
  package { 'systemd-sysv':
    ensure => 'installed',
  }

  # elasticsearch need it
  package { 'libaugeas-ruby':
    ensure => 'installed',
  }

  class { 'logstash':
    manage_repo  => true,
    repo_version => '2.x',
    autoupgrade  => true,
  }

#  logstash::plugin { 'logstash-input-beats': }

  $logstash_config = @(LOGSTASH_CONFIG)
  input {
    beats {
      port => 5044
    }
  }

  output {
    elasticsearch {
      hosts => "localhost:9200"
      manage_template => false
      index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
      document_type => "%{[@metadata][type]}"
    }
  }
  LOGSTASH_CONFIG

  logstash::configfile { 'beats_logstash_config':
    content => logstash_config,
  }

  include kibana4
}