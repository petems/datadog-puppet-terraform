class profile::vault_datadog {

  class { 'datadog_agent::integrations::generic':
    integration_name     => 'vault',
    integration_contents => template('profile/vault.yaml.erb'),
  }

}