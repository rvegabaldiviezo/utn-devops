#!/bin/bash
# Vagrant.init.sh - Práctica 3 Puppet + Jenkins

echo "📦 Actualizando sistema..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "🕐 Configurando zona horaria..."
sudo timedatectl set-timezone America/Argentina/Buenos_Aires

echo "🔧 Instalando dependencias..."
sudo apt-get install -y wget curl gnupg apt-transport-https lsb-release

echo "📥 Instalando Puppet..."
wget https://apt.puppet.com/puppet7-release-$(lsb_release -cs).deb
sudo dpkg -i puppet7-release-$(lsb_release -cs).deb
sudo apt-get update -y
sudo apt-get install -y puppetserver puppet-agent

# Asegurar hosts
echo "127.0.0.1 puppet.local puppet" | sudo tee -a /etc/hosts

echo "📂 Copiando manifiestos Puppet..."
if [ -d /vagrant/hostConfigs/puppet ]; then
  sudo mkdir -p /etc/puppet/code/environments/production
  sudo cp -r /vagrant/hostConfigs/puppet/* /etc/puppet/code/environments/production/
fi

echo "🚀 Ejecutando Puppet (site.pp)..."
sudo /opt/puppetlabs/bin/puppet apply /etc/puppet/code/environments/production/site.pp

echo "✅ Puppet aplicado. Jenkins debería estar instalado y corriendo."
echo "🌐 Acceso web: http://127.0.0.1:8082"
echo "🔑 Password inicial:"
echo "    vagrant ssh -c 'sudo cat /var/lib/jenkins/secrets/initialAdminPassword'"

