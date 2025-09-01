#  TP 


## comandos de deploy

- Levanta la VM en el puerto que le definimos (Valgranfile). Una vez finalice ir a http://localhost:8000/ para usar la App.

Si ya existe la VM la destruimos. 
```bash 
vagrant destroy -f
```

Construir la VM con todas las dependencias instaladas (Docker, Repo de la App, etc).
```bash 
vagrant up
```


## comandos de validacion del estado de la VM

- Conectarnos a la VM por ssh

```bash 
vagrant ssh  
```

- Ver los containers deployeados

```bash 
docker ps
```


## Repo donde esta la App para esta prueba


- Name Repo:   Agent
- Branch: 	Master
- Url:  		https://github.com/rvegabaldiviezo/agent 
