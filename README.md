# Jenkins Setup para AdminEase

Jenkins configurado con todas las herramientas necesarias para ejecutar el pipeline CI/CD de AdminEase.

## Herramientas Incluidas

- **Java 21**: OpenJDK 21 (requerido por Jenkins)
- **Node.js 22.x**: Para frontend
- **Python 3.11**: Para backend
- **Docker CLI**: Para ejecutar docker-compose
- **Docker Compose**: Para ejecutar pipelines
- **Git**: Para checkout de código
- **PostgreSQL Client**: Para tests

## Uso

### Construir la imagen

docker compose build


### Comando para ver el password 

```
docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```



### Nota importante

El archivo `initialAdminPassword` solo existe la primera vez que Jenkins inicia. Si ya configuraste Jenkins, este archivo desaparece. Si necesitas resetear la contraseña, puedes eliminar el volumen y volver a iniciar.