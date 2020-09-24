# Introducción a Vagrant

Vagrant es una aplicación libre que nos permite crear y personalizar
entornos de desarrollo livianos, reproducibles y portables.

Nos permite automatizar la creación y gestión de máquinas virtuales. Estas 
máquinas se pueden ejecutar con los diferentes gestores de máquinas virtuales.

Es importante fijarnos que todo lo que hagamos con vagrant, lo hacemos con
usuarios sin privilegios.

## Práctica con Vagrant


**Práctica 1: Instalación de vagrant**

Instalar virtualbox y vagrant (en Debian Buster lo podemos instalar de 
repositorios, si queremos la última versión lo podemos descargar desde 
la página oficial):

```apt-get install virtualbox-6.0 vagrant```

En nuestro caso, como ya tenemos VirtualBox, solamente instalaremos la 
aplicación de Vagrant:

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/install-vagrant.png)


**Práctica 2: Instalación de un "box" debian/buster**

Nos descargamos desde el repositorio oficial el box de Debian buster 
de 64 bits, esto lo hacemos un usuario sin privilegios:

```vagrant box add debian/buster64```

Si el box lo tenemos en la nas de nuestro instituto (o en otro servidor web):

```vagrant box add debian/buster64 http://nas.gonzalonazareno.org/...```

Puedo ver la lista de boxes que tengo instalada en mi usuario ejecutando 
la siguiente instrucción:

```vagrant box list```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/box-debian.png)

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/list-box.png)


**Práctica 3: Creación de una máquina virtual**

1. Nos creamos un directorio (en este caso, llamado Vagrant) y dentro vamos 
a crear el fichero Vagrantfile, podemos crear uno vacío con la instrucción:

```vagrant init```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/vagrant-init.png)


2. Modificamos el fichero Vagrantfile y los dejamos de la siguiente manera:

> Vagrant.configure("2") do |config|  
>		config.vm.box = "debian/buster64"  
>		config.vm.hostname = "mimaquina"  
>		config.vm.network :public_network,:bridge=>"eth0"  
> end  

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/vagrantfile.png)

3. Iniciamos la máquina estando dentro del directorio creado:

```vagrant up```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/vagrant-up1.png)
![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/vagrant-up2.png)


4. Para acceder a la instancia:

```vagrant ssh default```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/sshdefault.png)


5. Suspender, apagar o destruir:

```vagrant suspend```
```vagrant halt```
```vagrant destroy```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/comandosvagrant.png)


