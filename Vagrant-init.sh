#!/bin/bash

### Aprovisionamiento de software ###

# Espero a que liberen los locks de apt antes de actualizar
while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do
   echo "Esperando a que liberen /var/lib/apt/lists/lock..."
   sleep 5
done

while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
   echo "Esperando a que liberen /var/lib/dpkg/lock-frontend..."
   sleep 5
done

sudo apt-get update -y
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
	cd $APP_PATH

	sh run.sh
	# Si el repo no tiene commits, esto va a fallar
	# sudo git checkout master || true
fi


