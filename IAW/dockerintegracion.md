## Despliegue de aplicaciones con contenedores

Docker es una tecnología de virtualización "ligera" cuyo elemento básico es la
utilización de contenedores en vez de máquinas virtuales y cuyo objetivo
principal es el desliegue de aplicaciones encapsuladas. Elementos:

* Docker Engine --> demonio que expone una API externa para la gestión de 
imágenes y contenedores.

* Docker Client --> cliente de línea de comandos (CLI) que nos permite 
gestionar el Docker Engine.

* Docker Registry --> la finalidad de este componente es almacenar las imágenes
generadas por el DOcker Engine.

Comandos:

```
apt install docker.io

usermod -aG docker usuario

docker -version

docker run/stop imagen (si no está en el registro local, lo descarga)

docker ps -a 

docker rm contenedor (identificador o nombre)

docker ps -a -q --> muestra solo los identificadores

docker rm $(docker ps -a -q) --> borra los contenedores que están parados

docker images

docker run imagen proceso

docker run -it --name contenedor imagen consola  --> para hacerlo de manera
interactiva

docker attach contenedor

docker exec contenedor proceso

"""""""""""""""""""""" bash -c "comandos"

docker inspect contenedor

docker run -d --name loquesea imagen consola -c "comando"

docker logs contenedor

docker run -d --name my-apache-app -p  8080:80 httpd:2.4

El flag -e crea una variable de entorno en el contenedor

docker rmi imagen

docker build --> sirve para crear imágenes propias

docker ps -a -s --> ver cuanto ocupa
```

Cuando creas un volumen docker, es el propio docker quien crea un directorio
y lo monta donde le da la gana. Es el propio docker quien tiene control sobre
él. Sin embargo un bind mounts, no deja montar a docker el volumen, montamos
nosotros el directorio que queramos.

Trabajando con volúmenes docker:

```
docker volume ls

docker volume prune

docker volume create

docker volume rm

docker volume inspect
```

Tendriamos que tener cuidado a la hora de montar directorios en ciertas
imágenes, por eso debemos informarnos de eso, para saber que directorios son
importantes en los servicios ofrecidos (base de datos, web, etc.)


```
docker commit contenedor nombreusuario/capa

docker save nombreusuario/capa > capa.tar

docker load -i capa.tar

docker login

docker push

docker build DockerFile
```

Ejemplo de DockerFile:

```
FROM debian:buster-slim
MAINTAINER nombre "nombreusuario"
RUN apt update && apt install -y apache2
COPY index.html /var/www/html/index.html
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

Instrucciones:

```
FROM
MANTEINER
LABEL
RUN
COPY
ADD
WORKDIR --> es parecido a un cd en GNU/Linux
USER, EXPOSE, ENV --> variables de entorno
CMD
ENTRYPOINT
```

