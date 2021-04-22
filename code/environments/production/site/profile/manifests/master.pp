# profile to deploy a puppet master

class profile::master {

  include ::firewall

  firewall { '8140 accept - puppetserver':
    dport  => '8140',
    proto  => 'tcp',
    action => 'accept',
  }

  class { '::puppetserver':
    before  => Service['puppet'],
  }

  file { '/etc/puppetlabs/puppet/autosign.conf':
    ensure  => 'file',
    content => '*',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['puppetserver'],
    notify  => Service['puppetserver'],
  }

  class { 'datadog_agent::reports':
    api_key             => lookup('datadog_agent::api_key'),
    puppetmaster_user   => 'puppet',
    dogapi_version      => 'latest',
    report_fact_tags    => ["virtual","operatingsystem"],
    report_trusted_fact_tags => ["certname","extensions.pp_role","hostname"],
    manage_dogapi_gem   => false,
  }

  package{ 'dogapi':
    ensure   => 'present',
    provider => 'puppetserver_gem',
    notify   => Service['puppetserver']
  }

  ini_setting { 'puppet_conf_master_report_datadog_puppetdb':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'reports',
    value   => 'datadog_reports,puppetdb',
    notify  => [
      Service['puppet'],
      Service['puppetserver'],
    ],
  }

  class { '::puppetdb':
    ssl_listen_address => '0.0.0.0',
    listen_address     => '0.0.0.0',
    open_listen_port   => true,
  }

  class { '::puppetdb::master::config':
    puppetdb_server         => 'puppet',
    strict_validation       => false,
    manage_report_processor => true,
    enable_reports          => true,
    restart_puppet          => false,
  }

}
