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
    autoupgrade  => true,
    repo_version => '2.4',
  }

#  logstash::plugin { 'logstash-input-beats': }

  $logstash_config = @(LOGSTASH_CONFIG)

  input {
    tcp {
      port => 5000
      type => syslog
    }
    udp {
      port => 5000
      type => syslog
    }
    beats {
      port => 5044
    }
  }
  filter {
    if [type] == "blogr" {
      grok {
          match => { "message" => "%{COMBINEDAPACHELOG}" }
      }
    }
    if [type] == "syslog" {
      grok {
        match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
        add_field => [ "received_at", "%{@timestamp}" ]
        add_field => [ "received_from", "%{host}" ]
      }
      date {
        match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
      }
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
    content => $logstash_config,
  }

  include kibana4
}