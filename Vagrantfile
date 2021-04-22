$bootstrap_puppet = <<-SHELL
  /bin/yum -y install https://yum.puppet.com/puppet6/puppet6-release-el-7.noarch.rpm
  if [ $? -ne 0 ] ; then
    echo "Something went wrong installing the repository RPM"
    exit 1
    fi

  # install / update puppet-agent
  /bin/yum -y install puppet-agent
  if [ $? -ne 0 ] ; then
    echo "Something went wrong installing puppet-agent"
    exit 1
    fi

  yum install unzip -y

  echo "10.13.38.2    puppet.vm puppet" >> /etc/hosts
SHELL

Vagrant.configure(2) do |config|

  config.vm.define "puppet", primary: true do |puppet|
    puppet.vm.hostname = "puppet.vm"
    puppet.vm.box = "geerlingguy/centos7"
    puppet.vm.box_version = "1.2.12"
    puppet.vm.network "private_network", ip: "10.13.38.2"

    puppet.vm.synced_folder "code", "/etc/puppetlabs/code"

    puppet.vm.provider :virtualbox do |vb|
      vb.memory = "3072"
    end

    # Initial Puppet Bootstrap
    puppet.vm.provision "shell", inline: $bootstrap_puppet

    puppet.vm.provision "puppet" do |puppetapply|
      puppetapply.environment = "production"
      puppetapply.environment_path = ["vm", "/etc/puppetlabs/code/environments"]
    end
  end

  config.vm.define "datadogdemo", primary: true do |datadogdemo|
    datadogdemo.vm.hostname = "datadogdemo.vm"
    datadogdemo.vm.box = "geerlingguy/centos7"
    datadogdemo.vm.box_version = "1.2.12"
    datadogdemo.vm.network "private_network", ip: "10.13.38.3"

    # Initial Puppet Bootstrap
    datadogdemo.vm.provision "shell", inline: <<-SHELL
      /bin/yum -y install https://yum.puppet.com/puppet6/puppet6-release-el-7.noarch.rpm
      if [ $? -ne 0 ] ; then
        echo "Something went wrong installing the repository RPM"
        exit 1
      fi

      # install / update puppet-agent
      /bin/yum -y install puppet-agent
      if [ $? -ne 0 ] ; then
        echo "Something went wrong installing puppet-agent"
        exit 1
      fi

      echo "10.13.38.2    puppet.vm puppet" >> /etc/hosts
    SHELL

    # Run an agent run to check Puppetserver master is running ok
    datadogdemo.vm.provision "puppet_server" do |puppet_server|
      puppet_server.puppet_server = "puppet"
      puppet_server.options = "--test"
    end

    datadogdemo.vm.provision "shell", inline: <<-SHELL
      echo "Simulating some load to make the graphs more interesting";
      curl -s https://packagecloud.io/install/repositories/petems/stress/script.rpm.sh | sudo bash;
      yum install -y stress;
      stress -c 2 -i 1 -m 1 --vm-bytes 128M -t 30s;
      echo "Download file to create network traffic";
      wget http://ipv4.download.thinkbroadband.com/50MB.zip --quiet;
    SHELL

  end

  config.vm.define "vault", primary: true do |vault|
    vault.vm.hostname = "vault.vm"
    vault.vm.box = "geerlingguy/centos7"
    vault.vm.box_version = "1.2.12"
    vault.vm.network "private_network", ip: "10.13.38.4"

    # Initial Puppet Bootstrap
    vault.vm.provision "shell", inline: $bootstrap_puppet

    # Run an agent run to check Puppetserver master is running ok
    vault.vm.provision "puppet_server" do |puppet_server|
      puppet_server.puppet_server = "puppet"
      puppet_server.options = "--test"
    end

    vault.vm.provision "shell", inline: <<-SHELL
      export VAULT_ADDR=http://localhost:8200
      /usr/local/bin/vault operator init -key-shares=1 -key-threshold=1 | tee vault.keys
      VAULT_TOKEN=$(grep '^Initial' vault.keys | awk '{print $4}')
      VAULT_KEY=$(grep '^Unseal Key 1:' vault.keys | awk '{print $4}')
      export VAULT_TOKEN
      /usr/local/bin/vault operator unseal "$VAULT_KEY"
      echo $VAULT_TOKEN > /etc/vault_token.txt
      echo $VAULT_KEY > /etc/vault_key.txt
    SHELL

  end

end


