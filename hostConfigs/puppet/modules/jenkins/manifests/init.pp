# hostConfigs/puppet/modules/jenkins/manifests/init.pp
class jenkins {

  # Aseguramos que Java esté instalado
  package { 'openjdk-11-jdk':
    ensure => installed,
  }

  # Añadimos repositorio de Jenkins
  exec { 'add_jenkins_key':
    command => '/usr/bin/wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -',
    unless  => '/usr/bin/apt-key list | grep "Jenkins"',
  }

  file { '/etc/apt/sources.list.d/jenkins.list':
    ensure  => present,
    content => 'deb https://pkg.jenkins.io/debian-stable binary/\n',
    notify  => Exec['apt_update'],
  }

  exec { 'apt_update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }

  # Instalamos Jenkins
  package { 'jenkins':
    ensure  => installed,
    require => [Package['openjdk-11-jdk'], File['/etc/apt/sources.list.d/jenkins.list']],
  }

  service { 'jenkins':
    ensure    => running,
    enable    => true,
    subscribe => Package['jenkins'],
  }
}
# -----------------------------------------------------------------------------
