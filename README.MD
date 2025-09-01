#  TP 


## comandos de deploy

- Levanta la VM en el puerto que le definimos (Valgranfile). Una vez finalice ir a http://localhost:8000/ para usar la App.

Primero si existe la VM la destruimos. 
```bash 
vagrant destroy -f
```

Construir la VM.
```bash 
vagrant up
```


## comandos de validacion del estado de la VM

- Conectarnos a la VM por ssh

```bash 
vagrant ssh  
```