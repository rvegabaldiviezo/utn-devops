# Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.define "puppet" do |puppet|
    puppet.vm.hostname = "puppet.local"
    puppet.vm.network "private_network", ip: "192.168.56.10"
    puppet.vm.network "forwarded_port", guest: 8080, host: 8082, auto_correct: true

    puppet.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    puppet.vm.provision "shell", path: "Vagrant.init.sh"
  end
end
