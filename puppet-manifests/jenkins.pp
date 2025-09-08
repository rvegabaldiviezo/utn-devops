class jenkins {
  
  exec { 'apt-update':
    command => '/usr/bin/apt-get update',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    unless  => '/usr/bin/test -f /var/cache/apt/pkgcache.bin -a "$(stat -c %Y /var/cache/apt/pkgcache.bin)" -gt "$(date +%s -d "1 hour ago")"',
  }

  package { 'openjdk-11-jdk':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { ['wget', 'curl', 'gnupg']:
    ensure  => installed,
    require => Exec['apt-update'],
  }

  exec { 'add-jenkins-key':
    command => '/usr/bin/wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | /usr/bin/apt-key add -',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    unless  => '/usr/bin/apt-key list | /bin/grep jenkins',
    require => Package['wget'],
  }

  file { '/etc/apt/sources.list.d/jenkins.list':
    ensure  => file,
    content => "deb https://pkg.jenkins.io/debian-stable binary/\n",
    require => Exec['add-jenkins-key'],
    notify  => Exec['apt-update-jenkins'],
  }

  exec { 'apt-update-jenkins':
    command     => '/usr/bin/apt-get update',
    path        => '/usr/bin:/bin:/usr/sbin:/sbin',
    refreshonly => true,
  }

  package { 'jenkins':
    ensure  => installed,
    require => [
      Package['openjdk-11-jdk'],
      Exec['apt-update-jenkins'],
    ],
  }

  service { 'jenkins':
    ensure  => running,
    enable  => true,
    require => Package['jenkins'],
  }

  exec { 'ufw-allow-8080':
    command => '/usr/sbin/ufw allow 8080',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    unless  => '/usr/sbin/ufw status | /bin/grep "8080"',
    require => Service['jenkins'],
  }

  exec { 'wait-for-jenkins':
    command => '/bin/sleep 30',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => Service['jenkins'],
  }

  file { '/vagrant/get-jenkins-password.sh':
    ensure  => file,
    mode    => '0755',
    content => "#!/bin/bash\necho 'Jenkins initial admin password:'\nsudo cat /var/lib/jenkins/secrets/initialAdminPassword\necho ''\necho 'Access Jenkins at: http://localhost:8080'\n",
    require => Exec['wait-for-jenkins'],
  }

  exec { 'jenkins-info':
    command => '/vagrant/get-jenkins-password.sh',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => File['/vagrant/get-jenkins-password.sh'],
  }
}

include jenkins
