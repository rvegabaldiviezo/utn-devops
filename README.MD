

# Práctica 2 - Exploratoria: Automatización de despliegue con Vagrant y Docker


Este trabajo práctico consiste en automatizar el despliegue de una aplicación web y una base de datos usando Vagrant y Docker, reutilizando la imagen de Ubuntu creada en la práctica anterior. El objetivo es que, al levantar la VM, se instalen todas las dependencias y se despliegue la app en contenedores, permitiendo acceder a la aplicación desde el navegador de la máquina host.

---

## Grupo 6 - Integrantes

- Gustavo Venturo
- Ramon Vega
- Mariano Diez
- Leandro Emmanuel Iriarte
- Juan Magnacco
- Alexander Martinez
- Imanol Penaloza
- Matias Santo Stefano

---

## 🎯 Objetivo

- Instalar Docker automáticamente en la VM usando Vagrant.
- Desplegar dos contenedores: uno con el servidor web (y la app) y otro con la base de datos.
- Mapear el puerto 8000/8000 del contenedor de la VM al host para acceder a la app desde el navegador.
- Persistir los datos de la base de datos usando volúmenes de Docker.
- El código de la app y la infraestructura deben estar en repos separados.

---

## 🚀 Pasos para el despliegue

1. **(Opcional) Eliminar la VM existente:**
	 ```bash
	 vagrant destroy -f
	 ```

2. **Levantar la VM y aprovisionar todo:**
	 ```bash
	 vagrant up
	 ```

3. **Acceder a la aplicación:**
	 Abre tu navegador y entra a: [http://localhost:8000/](http://localhost:8000/)

---

## 🔎 Comandos útiles para validación

- **Conectarse a la VM por SSH:**
	```bash
	vagrant ssh
	```

- **Ver los contenedores Docker activos:**
	```bash
	docker ps
	```

- **Ver logs de un contenedor (por ejemplo, el de la app):**
	```bash
	docker logs -f <CONTAINER_ID>
	```

- **Apagar la VM (sin destruirla):**
	```bash
	vagrant halt
	```

- **Eliminar la VM completamente:**
	```bash
	vagrant destroy -f
	```

---

## 📦 Información del repositorio de la App

- **Nombre:** Agent
- **Branch principal:** Master
- **URL:** https://github.com/rvegabaldiviezo/agent

---
