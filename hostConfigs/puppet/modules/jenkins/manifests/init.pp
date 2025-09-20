# hostConfigs/puppet/modules/jenkins/manifests/init.pp
class jenkins {

  # Aseguramos que Java esté instalado
  package { 'openjdk-11-jdk':
    ensure => installed,
  }

  # Instalamos apt-transport-https y ca-certificates necesarios para HTTPS
  package { ['apt-transport-https', 'ca-certificates', 'curl', 'gnupg']:
    ensure => installed,
  }

  # Añadimos la clave GPG de Jenkins usando el método recomendado
  exec { 'add_jenkins_key':
    command => '/usr/bin/curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg',
    creates => '/usr/share/keyrings/jenkins-keyring.gpg',
    require => Package['curl'],
  }

  # Añadimos el repositorio de Jenkins con la clave firmada
  file { '/etc/apt/sources.list.d/jenkins.list':
    ensure  => present,
    content => "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/\n",
    require => Exec['add_jenkins_key'],
    notify  => Exec['apt_update'],
  }

  exec { 'apt_update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }

  # Instalamos Jenkins
  package { 'jenkins':
    ensure  => installed,
    require => [Package['openjdk-11-jdk'], File['/etc/apt/sources.list.d/jenkins.list'], Exec['apt_update']],
  }

  service { 'jenkins':
    ensure    => running,
    enable    => true,
    subscribe => Package['jenkins'],
  }
}
# -----------------------------------------------------------------------------
