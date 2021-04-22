class profile::base {

  host { 'puppet.vm':
    ip => '10.13.38.2',
  }

  host { 'datadogdemo.vm':
    ip => '10.13.38.4',
  }

  package { 'puppet-agent':
    ensure => installed,
  }

  service { 'puppet':
    ensure  => running,
    enable  => true,
    require => Package['puppet-agent'],
  }

  class { 'datadog_agent':
    datadog_site        => 'datadoghq.com',
    agent_major_version => 7,
  }

  class { 'datadog_agent::integrations::ntp' :
    offset_threshold     => 60,
    host                 => 'pool.ntp.org',
  }

  class { 'datadog_agent::integrations::disk' :
    use_mount            => 'yes',
    excluded_filesystems => '/dev/tmpfs',
  }

  class { 'datadog_agent::integrations::tcp_check':
    check_name => 'localhost-ssh',
    host       => '127.0.0.1',
    port       => '22',
    threshold  => 1,
    window     => 1,
    tags       => ['ssh access'],
  }

  ini_setting { 'puppet_conf_agent_report_true':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'agent',
    setting => 'report',
    value   => 'true',
    notify  => [
      Service['puppet'],
    ],
  }

}
