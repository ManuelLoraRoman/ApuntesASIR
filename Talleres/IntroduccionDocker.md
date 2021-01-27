# Introducción a contenedores y Docker

## Aplicación monolítica


* Todos los componentes en el mismo nodo.

* Escalado vertical.

* Arquitectura muy sencilla.

* Suele utilizarse un solo lenguaje.

* No pueden utilizarse diferentes versiones de un lenguaje.

* Interferencias entre componentes en producción.

* Complejidad en las actualizaciones. Puede ocasionar paradas en producción.

* Normalmente usan infraestructura estática y fija.

* No tolerante a fallos la aplicación.


## Introducción a Docker

Pertenece a los denominados contenedores de aplicaciones y es capaz de gestionar
contenedores a alto nivel proporcionando todas las capas y funcionalidad 
adicional. 

Presenta un nuevo paradigma, cambiando completamente la forma de desplegar y 
distribuir una aplicación. 

* Docker: build, ship and run

El contenedor ejecuta un comando y se para cuando éste termina, no es un
sistema operativo al uso, ni pretende serlo. Está escrito en go y es de
software libre.


* Docker-engine --> demonio docker - docker API - docker CLI.

* Docker-machine --> gestiona múltiples docker engines.

* Docker compose --> se usa para definir aplicaciones que corren en múltiples
contenedores.

* Docker swarm --> orquestador de contenedores.

## Instalación

```
sudo apt-get install docker.io
```

## Comandos

```
docker ps --> lista de contenedores

La opción -a es para los que estan parados

docker images --> imágenes para docker

docker pull loquesea --> se baja la imagen del repositorio (docker hub)

docker run loquesea --> ejecutar un contenedor a partir de la imagen

docker run -it(interactiva) --name loquesea debian bash --> 
nos metemos en el contenedor

docker rm contenedor --> borrar contenedor

docker rmi imagen --> borrar imagen

docker exec contenedor comando --> ejecuta un comando



```
