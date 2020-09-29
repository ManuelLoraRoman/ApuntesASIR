# Introducción a Vagrant

Vagrant es una aplicación libre que nos permite crear y personalizar
entornos de desarrollo livianos, reproducibles y portables. Desarrollada en
Ruby. Su objetivo es aproximar los entornos de desarrollo y producción.

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


### Ejercicios

1. Entra en virtualbox y comprueba las características de la máquina
que se ha creado.

2. ¿Qué usuario tiene creado por defecto el sistema?¿Cómo se ejecutan
instrucciones de superusuario?

3. ¿Cuántas tarjetas de red tiene?¿Para qué sirve la _eth0_?

4. Investiga el funcionamiento de la instrucción _vagrant ssh_.
¿Por qué interfaz se conecta?¿Qué certificado se utiliza para acceder?


**1.** Características:

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/carac1.png)

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/carac2.png)

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/carac3.png)


**2.** 
El usuario que tiene creado por defecto es "mimaquina" y podremos 
acceder al superusuario con la siguiente instrucción:

```sudo su```


**3.** 

Para ver cuantas tarjetas de red tiene nuestra máquina, usaremos el 
siguiente comando:

```sudo ip a```

La _eth0_ actúa como bridge entre la máquina y nuestro equipo local.


**4.**

En nuestro caso, al iniciar la conexión a la máquina vagrant por ssh, 
podemos elegir la interfaz por la que conectarnos, la wlp2s0. Normalmente
se usa la que acostumbra a conectar Internet.

Primero, accede con una clave insegura para comprobar la máquina, después empieza 
Utilizando una clave privada que se encuentra en la máquina Vagrant ./machines....
