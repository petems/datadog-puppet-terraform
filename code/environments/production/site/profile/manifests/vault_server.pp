# profile to deploy a puppet vault_server

class profile::vault_server {

  firewall { '8200 accept - vault':
    dport  => '8200',
    proto  => 'tcp',
    action => 'accept',
  }

  file { '/mnt/vault/':
    ensure => directory,
    owner  => 'vault',
    group  => 'vault',
  }

  class { '::vault':
    manage_storage_dir => true,
    storage => {
      file => {
        path => '/mnt/vault/data',
      },
    },
    listener => {
      tcp => {
        'tls_disable'        => true,
        'address'            => '0.0.0.0:8200',
        telemetry => {
          'unauthenticated_metrics_access' => true,
        },
      },
    },
    telemetry => {
      'prometheus_retention_time' => "30s",
      'disable_hostname' => true,
    },
    version   => '1.6.0',
    enable_ui => true,
  }

  file { '/usr/bin/vault':
    ensure => link,
    target => '/usr/local/bin/vault',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
