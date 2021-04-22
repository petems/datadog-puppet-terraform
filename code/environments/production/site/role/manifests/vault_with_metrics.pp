# Puppet master role
class role::vault_with_metrics {
  include ::profile::base
  include ::profile::vault_server
  include ::profile::vault_datadog
}