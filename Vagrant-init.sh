#!/bin/bash

### Aprovisionamiento de software ###


# --- Fix DNS permanente para evitar problemas de resolución ---
sudo rm -f /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
sudo chattr +i /etc/resolv.conf

# Espero a que liberen los locks de apt antes de actualizar
while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do
  echo "Esperando a que liberen /var/lib/apt/lists/lock..."
  sleep 5
done

while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  echo "Esperando a que liberen /var/lib/dpkg/lock-frontend..."
  sleep 5
done

sudo apt update -y && sudo apt upgrade -y
# sudo apt-get install -y apache2 git  # <-- solo si querés Apache


# Instalar Docker (última versión estable desde Docker repo oficial)
if ! command -v docker &> /dev/null
then
    echo "Instalando Docker..."
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    # Clave GPG oficial de Docker
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Repositorio Docker estable
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Agrego vagrant al grupo docker para no necesitar sudo
    sudo usermod -aG docker vagrant
fi


# Instalar Puppet Server - Client
# Lista de versiones https://apt-puppetcore.puppet.com/public/index.html
# 1

wget https://apt.puppet.com/puppet7-release-focal.deb

sudo dpkg -i puppet7-release-focal.deb

sudo apt update

sudo apt-get install -y puppetserver puppet-agent

PUPPET_MASTER=${1:-"puppet-master"} // si alguien quiere agregar el puppet-master al dns 

# sudo tee /etc/puppetlabs/puppet/puppet.conf > /dev/null << EOF
# [main]
# server = $(hostname -f)

# [agent]
# certname = $(hostname -f)
# EOF


#2

groupadd puppet 2>/dev/null || echo "grupo puppet ya existee"
    
useradd -r -g puppet -d /var/lib/puppet -s /bin/false -c "puppet daemon user" puppet 2>/dev/null || echo "usuario puppet ya existe"
    

echo "Copiando manifiestos"
if [ -d "/tmp/puppet-manifests" ]; then
    cp -r /tmp/puppet-manifests/* /etc/puppetlabs/code/environments/production/manifests/
    chown -R puppet:puppet /etc/puppetlabs/code/environments/production/manifests/
fi

echo "Copiando configuraciones"
if [ -d "/tmp/puppet-config" ] && [ "$(ls -A /tmp/puppet-config)" ]; then
    cp -r /tmp/puppet-config/puppet.conf /etc/puppetlabs/puppet/puppet.conf
    chown -R puppet:puppet /etc/puppetlabs/
fi

sudo systemctl start puppetserver

sudo systemctl enable puppetserver

sudo systemctl start puppet

sudo systemctl enable puppet


### Configuración del entorno ###

## Partición swap
if [ ! -f "/swapdir/swapfile" ]; then
	sudo mkdir /swapdir
	cd /swapdir
	sudo dd if=/dev/zero of=/swapdir/swapfile bs=1024 count=2000000
	sudo chmod 0600 /swapdir/swapfile
	sudo mkswap -f  /swapdir/swapfile
	sudo swapon swapfile
	echo "/swapdir/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
	sudo sysctl vm.swappiness=10
	echo "vm.swappiness = 10" | sudo tee -a /etc/sysctl.conf
fi

## aplicación
APP_ROOT="/home/vagrant/"
APP_PATH="$APP_ROOT/agent"

if [ ! -d "$APP_PATH" ]; then
    echo "Clonando el repositorio en $APP_PATH ..."
    sudo mkdir -p $APP_ROOT
    cd $APP_ROOT
    sudo git clone https://github.com/rvegabaldiviezo/agent.git agent
fi

cd $APP_PATH
git checkout master
git pull origin master
docker compose up --build -d

# Aplicar manifiestos de Puppet para Jenkins
echo "Aplicando configuración de Jenkins con Puppet..."
sudo /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/jenkins.pp --verbose

echo "=== INFORMACIÓN DE ACCESO ==="
echo "Jenkins estará disponible en: http://localhost:8080"
echo "Para obtener la contraseña inicial de Jenkins, ejecuta:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"


