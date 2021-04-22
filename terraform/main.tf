terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

# Configure the Datadog provider
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

resource "datadog_dashboard" "infra_metrics" {

  title       = "Datadog Demo - Infrastructure Metrics"
  layout_type = "free"
  description = "-> Managed by Terraform"

  widget {
    layout = {
      "height" = "22"
      "width"  = "28"
      "x"      = "0"
      "y"      = "0"
    }

    hostmap_definition {
      group           = []
      no_group_hosts  = true
      no_metric_hosts = true
      node_type       = "host"
      scope           = []
      title           = "Current Infrastructure"
      title_align     = "left"
      title_size      = "20"

      request {
        fill {
          q = "avg:system.cpu.user{*} by {host}"
        }
      }

      style {
        palette      = "hostmap_blues"
        palette_flip = false
      }
    }
  }

  widget {
    layout = {
      "height" = "45"
      "width"  = "38"
      "x"      = "28"
      "y"      = "0"
    }

    timeseries_definition {
      show_legend = false
      time        = {}
      title       = "System User CPU Usage"
      title_align = "center"
      title_size  = "16"

      request {
        display_type   = "line"
        on_right_yaxis = false
        q              = "avg:system.cpu.user{host:puppet.vm}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
      request {
        display_type   = "line"
        on_right_yaxis = false
        q              = "avg:system.cpu.user{host:datadogdemo.vm}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max          = "auto"
        min          = "auto"
        scale        = "linear"
      }
    }
  }

  widget {
    layout = {
      "height" = "22"
      "width"  = "28"
      "x"      = "0"
      "y"      = "22"
    }

    check_status_definition {
      check = "tcp.can_connect"
      group = "instance:localhost_ssh,port:22,ssh_access,target_host:127.0.0.1,host:puppet.vm"
      group_by = [
        "host",
      ]
      grouping = "cluster"
      tags = [
        "*",
      ]
      time        = {}
      title       = "SSH Status Ok"
      title_align = "center"
      title_size  = "16"
    }
  }

  widget {
    layout = {
      "height" = "24"
      "width"  = "42"
      "x"      = "67"
      "y"      = "0"
    }

    check_status_definition {
      check    = "vault.unsealed"
      group_by = []
      grouping = "cluster"
      tags = [
        "*",
      ]
      time = {
        "live_span" = "10m"
      }
      title       = "Vault Unsealed"
      title_align = "center"
      title_size  = "16"
    }
  }

}

output "url" {
  value = "https://app.datadoghq.com${datadog_dashboard.infra_metrics.url}"
}
