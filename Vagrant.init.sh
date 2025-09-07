# Vagrant.init.sh
#!/bin/bash

# Actualizamos sistema
sudo apt-get update -y
sudo apt-get upgrade -y

# Instalamos dependencias
sudo apt-get install -y wget curl gnupg apt-transport-https lsb-release

# Repositorio Puppet
wget https://apt.puppet.com/puppet7-release-$(lsb_release -cs).deb
sudo dpkg -i puppet7-release-$(lsb_release -cs).deb
sudo apt-get update -y

# Instalamos Puppet server y agent (si es VM única)
sudo apt-get install -y puppetserver puppet-agent

# Copiamos manifiestos desde carpeta compartida
if [ -d /vagrant/hostConfigs/puppet ]; then
  sudo mkdir -p /etc/puppet/code/environments/production
  sudo cp -r /vagrant/hostConfigs/puppet/* /etc/puppet/code/environments/production/
fi

# Ejecutamos puppet apply en site.pp para instalar Jenkins
sudo /opt/puppetlabs/bin/puppet apply /etc/puppet/code/environments/production/site.pp

Esta es una versión anterior
Restaurar esta versión para hacer ediciones

Restaurar esta versión

Volver a la versión más reciente
