# Datadog with Puppet and Terraform

## Pre-requisites:

* Vagrant 2.X (https://www.vagrantup.com/docs/installation)
* VirtualBox or VMWare Fusion
* At least 4GB of system RAM
* Terraform 0.14.X (https://www.terraform.io/downloads.html)
* A Datadog API key and login (https://app.datadoghq.com/signup)
* Basic terminal and Git knowledge 

## Background:
This is a demonstration of a common pattern for using Datadog: monitoring infrastructure, integration with application metrics and a dashboard for showing them visually.

In this example, we will be setting up a 3 node VM environment, comprising a Puppet master, a generic node and a Vault server. These then connect to Datadog via the datadog-agent that Puppet configures and installs. 

# Instructions

Initialize the Git submodules:

```
git submodule update --init --recursive
```

Copy the example file to a new file (this is ignored from git to stop the API key being accidentally added to Git):

```
cp code/environments/production/hieradata/common.yaml.example code/environments/production/hieradata/common.yaml
```

And change the API key to the key from your configuration:

```
datadog_agent::api_key: [CHANGE ME]
```

Then run vagrant to spin up the required VMs

```
vagrant up
```

This will take a little while to setup depending on internet speed and previously cached Vagrant VMs, but when complete you’ll have 3 VMs running.

Check that puppet runs are happening successfully by connecting to the demo node and doing a test puppet run:

```
$ vagrant ssh 
$ sudo puppet agent -t
```

When this is complete, you should see some initial reports coming into your Datadog events stream.

You can test this by going to https://app.datadoghq.com/event/stream, you should see a message like the following:



If nothing's showing, connect to the VM via vagrant and see if there’s anything in the datadog-agent logs:

```
$ vagrant ssh datadogdemo
$ sudo journalctl -u datadog-agent
-- Logs begin at Wed 2020-12-30 13:53:08 UTC, end at Wed 2020-12-30 16:19:10 UTC. --
Dec 30 14:30:31 datadogdemo.vm systemd[1]: Started Datadog Agent.
Dec 30 14:30:31 datadogdemo.vm systemd[1]: Starting Datadog Agent...
Dec 30 14:30:32 datadogdemo.vm agent[8974]: 2020-12-30 14:30:32 UTC | CORE | INFO | (cmd/agent/app/run.go:218 in StartAgent) | Starting Datadog Agent v7.24.1
Dec 30 14:30:32 datadogdemo.vm agent[8974]: 2020-12-30 14:30:32 UTC | CORE | INFO | (cmd/agent/app/run.go:255 in StartAgent) | pid '8974' written to pid file '/op
Dec 30 14:30:33 datadogdemo.vm agent[8974]: 2020-12-30 14:30:33 UTC | CORE | INFO | (cmd/agent/app/run.go:262 in StartAgent) | Hostname is: datadogdemo.vm
```

Ok, so now we have events coming in, we’ll want to visualize them with a dashboard. 

Firstly, we can check the default Dashboards that Datadog configures.

Navigate to https://app.datadoghq.com/dashboard/lists

You should see some preset lists based on the integrations that Puppet has setup:



And if we click on the Vault page, we should have the default Vault dashboard working for us:



We’re going to create one directly via the API with Terraform.

Change into the Terraform directory:

```
cd terraform
```

When that’s setup, run a terraform init:

```
$ terraform init 

Initializing the backend...

Initializing provider plugins...
- Finding latest version of datadog/datadog...
- Installing datadog/datadog v2.18.1...
- Installed datadog/datadog v2.18.1 (signed by a HashiCorp partner, key ID FB70BE941301C3EA)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/plugins/signing.html

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* datadog/datadog: version = "~> 2.18.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Now, create a new API key:

https://app.datadoghq.com/account/settings#api

Type a new name of “Terraform” into the New API Key text field and then click Create API Key

Then export this value to your terminal:

```
$ export TF_VAR_datadog_api_key="API-KEY-HERE"
```

Now, create an Application key:

Navigate to  https://app.datadoghq.com/access/application-keys

Then, create a Name it “Terraform” and click “Create Key”

You should then see a screen showing the key, copy that to your clipboard:

Export this to your terminal

```
$ export TF_VAR_datadog_app_key="APP-KEY-HERE"
```

Now, run a terraform apply:

```
$ terraform apply
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # datadog_dashboard.infra_metrics will be created
  + resource "datadog_dashboard" "infra_metrics" {
      + dashboard_lists_removed = (known after apply)
      + description             = "-> Managed by Terraform"
      + id                      = (known after apply)
      + is_read_only            = false
      + layout_type             = "free"
      + title                   = "Datadog Demo - Infrastructure Metrics"
      + url                     = (known after apply)

      + widget {
          + layout = {
              + "height" = "22"
              + "width"  = "28"
              + "x"      = "0"
              + "y"      = "0"
            }

          + hostmap_definition {
              + group           = []
              + no_group_hosts  = true
              + no_metric_hosts = true
              + node_type       = "host"
              + scope           = []
              + title           = "Current Infrastructure"
              + title_align     = "left"
              + title_size      = "20"

              + request {
                  + fill {
                      + q = "avg:system.cpu.user{*} by {host}"
                    }
                }

              + style {
                  + palette      = "hostmap_blues"
                  + palette_flip = false
                }
            }
        }
      + widget {
          + layout = {
              + "height" = "45"
              + "width"  = "38"
              + "x"      = "28"
              + "y"      = "0"
            }

          + timeseries_definition {
              + show_legend = false
              + title       = "System User CPU Usage"
              + title_align = "center"
              + title_size  = "16"

              + request {
                  + display_type   = "line"
                  + on_right_yaxis = false
                  + q              = "avg:system.cpu.user{host:puppet.vm}"

                  + style {
                      + line_type  = "solid"
                      + line_width = "normal"
                      + palette    = "dog_classic"
                    }
                }
              + request {
                  + display_type   = "line"
                  + on_right_yaxis = false
                  + q              = "avg:system.cpu.user{host:datadogdemo.vm}"

                  + style {
                      + line_type  = "solid"
                      + line_width = "normal"
                      + palette    = "dog_classic"
                    }
                }

              + yaxis {
                  + include_zero = true
                  + max          = "auto"
                  + min          = "auto"
                  + scale        = "linear"
                }
            }
        }
      + widget {
          + layout = {
              + "height" = "22"
              + "width"  = "28"
              + "x"      = "0"
              + "y"      = "22"
            }

          + check_status_definition {
              + check       = "tcp.can_connect"
              + group       = "instance:localhost_ssh,port:22,ssh_access,target_host:127.0.0.1,host:puppet.vm"
              + group_by    = [
                  + "host",
                ]
              + grouping    = "cluster"
              + tags        = [
                  + "*",
                ]
              + title       = "SSH Status Ok"
              + title_align = "center"
              + title_size  = "16"
            }
        }
      + widget {
          + layout = {
              + "height" = "24"
              + "width"  = "42"
              + "x"      = "67"
              + "y"      = "0"
            }

          + check_status_definition {
              + check       = "vault.unsealed"
              + group_by    = []
              + grouping    = "cluster"
              + tags        = [
                  + "*",
                ]
              + time        = {
                  + "live_span" = "10m"
                }
              + title       = "Vault Unsealed"
              + title_align = "center"
              + title_size  = "16"
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

datadog_dashboard.infra_metrics: Creating...
datadog_dashboard.infra_metrics: Creation complete after 2s [id=283-r98-zdm]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

url = https://app.datadoghq.com/dashboard/283-r98-zdm/datadog-demo---infrastructure-metrics
```

When that completes, you should be able to access the URL of the new dashboard via the outputs shown. 

```
$ open $(terraform output url)
```

This should open up the Dashboard page, which should look something like this:


Finally, lets test that the checks are actually working.

SSH onto the vagrant vault box and restart Vault, this will seal it (as we don’t have auto-unseal configured)

```
$ vagrant ssh vault
$ service vault restart
```

Then check in the dashboard should shortly change to Red: