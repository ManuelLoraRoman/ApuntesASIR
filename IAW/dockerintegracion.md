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
