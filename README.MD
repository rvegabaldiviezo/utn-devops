# Práctica 3 - Exploratoria: automatizar la instalación de Jenkins mediante Puppet

## Descripción de la actividad
Esta práctica tiene como objetivo **automatizar la instalación de Jenkins mediante Puppet**, utilizando **Vagrant** como herramienta para levantar una máquina virtual reproducible. 

---

## Pasos de ejecución

### 1. Clonar el repositorio
```bash
git clone https://github.com/rvegabaldiviezo/utn-devops.git
cd utn-devops
git checkout unidad-3-puppet
git pull origin unidad-3-puppet
```

### 2. Revisar la estructura de archivos
Los archivos principales para esta práctica son:
- `Vagrantfile` → define la VM de Vagrant.
- `Vagrant.init.sh` → script de aprovisionamiento que instala Puppet y aplica manifiestos.
- `hostConfigs/puppet/site.pp` → manifiesto principal que incluye la clase Jenkins.
- `hostConfigs/puppet/modules/jenkins/manifests/init.pp` → módulo que instala y configura Jenkins.

### 3. Levantar la VM con Vagrant
```bash
vagrant up --provision
```
> Este comando crea la máquina virtual, ejecuta el script de aprovisionamiento y aplica el manifiesto de Puppet.

### 4. Verificar Jenkins
Una vez completado el aprovisionamiento:
- Acceder desde el navegador del host a: [http://127.0.0.1:8082](http://127.0.0.1:8082)
- Seguir los pasos iniciales de Jenkins:
  1. Ingresar con la contraseña inicial desde `/var/lib/jenkins/secrets/initialAdminPassword`.
  2. Seleccionar **Install suggested plugins**.
  3. Crear un usuario administrador.

---

## Resultado esperado
Al finalizar estos pasos:
- Jenkins debe estar instalado y funcionando en la VM.
- El acceso desde el host debe estar disponible en el puerto `8082`.

---

## Nota
En caso de errores durante el aprovisionamiento, se recomienda ejecutar:
```bash
vagrant reload --provision
```
o bien aplicar manualmente Puppet dentro de la VM:
```bash
vagrant ssh
sudo /opt/puppetlabs/bin/puppet apply /etc/puppet/code/environments/production/site.pp
```
