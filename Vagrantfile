# -*- mode: ruby -*-
# Vagrantfile para Windows/Linux/Mac
# Puppet + Jenkins (1 VM)
# Forwarded port 8080 -> 8082

Vagrant.configure("2") do |config|
  # ---------------------------------------------------------------------------
  # Selección de box según arquitectura
  # ---------------------------------------------------------------------------
  if Vagrant::Util::Platform.architecture == 'arm64'
    box_image = "bento/ubuntu-22.04-arm64"
    puts "🍎 Arquitectura ARM64 detectada - Usando imagen optimizada"
  else
    box_image = "ubuntu/jammy64"
    puts "🖥️  Arquitectura x86_64 detectada - Usando imagen estándar"
  end

  config.vm.box = box_image

  # ---------------------------------------------------------------------------
  # Definición de VM Puppet
  # ---------------------------------------------------------------------------
  config.vm.define "puppet" do |puppet|
    puppet.vm.hostname = "puppet.local"

    # Solo forwarded port para Jenkins, evita host-only issues en Windows
    puppet.vm.network "forwarded_port", guest: 8080, host: 8082, auto_correct: true

    # Recursos recomendados para Puppet + Jenkins
    puppet.vm.provider "virtualbox" do |vb|
      vb.memory = 4096  # 4GB RAM
      vb.cpus   = 2
    end

    # Ejecuta el script de bootstrap que prepara Puppet
    puppet.vm.provision "shell", path: "Vagrant.init.sh"
  end
end