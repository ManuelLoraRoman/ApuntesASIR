# Ejercicios de dpkg / APT


## Trabajo con apt, aptitude, dpkg


**Tarea 1.** Que acciones consigo al realizar apt update y apt upgrade. 
Explica detalladamente.

* **apt-get update** --> lo que hace es actualizar los repositorios, para ver 
si hay algo nuevo que actualizar de la lista de todos los paquetes, con la
dirección de dónde obtenerlos.Esta lista la coge de los servidores con 
repositorios que tenemos definidos en el _sources.list_.

* **apt-get upgrade** --> intentará actualizar con cuidado todo el sistema. 
upgrade nunca intentará instalar un paquete nuevo o eliminar un paquete 
existente, y en ningún caso actualizará un paquete que pueda causar un problema 
de dependencias rotas a otro paquete. upgrade mostrará todos los paquetes 
que no pudo actualizar, lo cual generalmente significa que dependen 
de paquetes nuevos o que entran en conflicto con otro paquete.

**Tarea 2.** Lista la relación de paquetes que pueden ser actualizados. 
¿Qué información puedes sacar a tenor de lo mostrado en el listado?.

```sudo apt list```

Podemos sacar el nombre del paquete, desde donde se descargó el paquete y la 
versión.

**Tarea 3.** Indica la versión instalada, candidata así como la prioridad 
del paquete openssh-client.

Con el siguiente comando, podemos mostrar características del paquete:

```sudo apt policy [paquete]```

En el caso de _ssh-client_, la versión instalada es la 1:7.9p1-10+deb10u2 y la
candidata es la misma versión.

**Tarea 4.** ¿Cómo puedes sacar información de un paquete oficial instalado o 
que no este instalado?

Para verlo, tenemos que usar el comando:

```sudo apt show```

**Tarea 5.** Saca toda la información que puedas del paquete openssh-client 
que tienes actualmente instalado en tu máquina.

```sudo apt-cache showpkg [paquete]```

Podemos añadirle un paginador para visualizar el contenido mejor.

**Tarea 6.** Saca toda la información que puedas del paquete openssh-client 
candidato a actualizar en tu máquina.

```sudo dpkg -L [paquete]```

Si queremos ver los paquetes binarios, usaremos el siguiente:

```sudo dpkg -L [paquete] | grep bin```

**Tarea 7.** Lista todo el contenido referente al paquete openssh-client 
actual de tu máquina. Utiliza para ello tanto dpkg como apt.

```sudo apt-file list [paquete]```

**Tarea 8.** Listar el contenido de un paquete sin la necesidad de 
instalarlo o descargarlo.

Para simular una instalación de paquetería haremos esto:

```sudo apt-get install -s [paquete]```

**Tarea 9.** Simula la instalación del paquete openssh-client.

```sudo apt-get install -s [paquete]```

**Tarea 10.** ¿Qué comando te informa de los posible bugs que presente un 
determinado paquete?

```sudo apt-listbugs list [paquete] -s all```

**Tarea 11.** Después de realizar un apt update && apt upgrade. Si quisieras 
actualizar únicamente los paquetes que tienen de cadena openssh. 
¿Qué procedimiento seguirías?. Realiza esta acción, con las estructuras 
repetitivas que te ofrece bash, así como con el comando xargs.

```dpkg -l | grep openssh | cut -d' ' -f 3 | sudo xargs apt update && sudo apt upgrade```

**Tarea 12.** ¿Cómo encontrarías qué paquetes dependen de un paquete específico.

```sudo apt-cache depends [paquete]```

```sudo apt-cache rdepends [paquete]```

**Tarea 13.** Como procederías para encontrar el paquete al que pertenece un 
determinado archivo.

```apt-file search /usr/bin/less``` 

**Tarea 14.** ¿Qué procedimientos emplearías para eliminar liberar la cache 
en cuanto a descargas de paquetería?

```sudo apt-get clean``` --> se guarda en /var/cache/apt/archives

**Tarea 15.** Realiza la instalación del servidor de bases de datos MariaDB 
pasando previamente los valores de los parámetros de configuración como 
variables de entorno.

```sudo apt-get install mariadb-server....```

```sudo dpkg-reconfigure debconf``` --> paquete de configuración de paquetes

```sudo apt-get install debconf-utils```

```debconf-get-selections.....```


**Tarea 16.** Reconfigura el paquete locales de tu equipo, añadiendo una 
localización que no exista previamente. Comprueba a modificar las 
variables de entorno correspondientes para que la sesión del usuario 
utilice otra localización.

Para agregar locales hacemos:

```sudo dpkg-reconfigure locales```

**Tarea 17.** Interrumpe la configuración de un paquete y explica los pasos a 
dar para continuar la instalación.

* **Paso 1.** Ejecutamos el siguiente comando:

```sudo dpkg --configure -a```

* **Paso 2.** Si no se soluciona, limpiamos cache local:

```sudo apt-get clean && sudo apt-get autoclean```

* **Paso 3.** Acto seguido haremos, lo siguiente para regenerar la cache de los 
repositorios con el parámetro _--fix-missing_.

```sudo apt-get update --fix-missing```

* **Paso 4.** Corregimos las dependencias rotas:

```sudo apt-get install -f```

**Tarea 18.** Explica la instrucción que utilizarías para hacer una 
actualización completa de todos los paquetes de tu sistema de manera 
completamente no interactiva.

```export DEBIAN_FRONTEND=noninteractive yes "| sudo apt-get -y -o DPkg::options::=" --force-confdef " -o DPkg::options::=" --force-confold" dist upgrade```

**Tarea 19.** Bloquea la actualización de determinados paquetes.

Para evitar que se actualize un paquete en concreto, debemos hacer lo siguiente:

```echo "[paquete] hold" | sudo dpkg --set-selections```


## Trabajo con ficheros .deb


**Tarea 1.** Descarga un paquete sin instalarlo, es decir, descarga el fichero 
.deb correspondiente. Indica diferentes formas de hacerlo.

```sudo apt download [paquete]```

**Tarea 2.** ¿Cómo puedes ver el contenido, que no extraerlo, de lo que se 
instalará en el sistema de un paquete deb?

```sudo dpkg -x [paquete]```

**Tarea 3.** Sobre el fichero .deb descargado, utiliza el comando ar. ar 
permite extraer el contenido de una paquete deb. Indica el procedimiento para 
visualizar con ar el contenido del paquete deb. Con el paquete que has 
descargado y utilizando el comando ar, descomprime el paquete. ¿Qué información
dispones después de la extracción?. Indica la finalidad de lo extraído.

```ar -x [paquete]```

**Tarea 4.** Indica el procedimiento para descomprimir lo extraído por ar del 
punto anterior. ¿Qué información contiene?


## Trabajo con repositorios



**Tarea 1.** Añade a tu fichero sources.list los repositorios de 
buster-backports y sid.

Hecho en clase

**Tarea 2.** Configura el sistema APT para que los paquetes de debian buster 
tengan mayor prioridad y por tanto sean los que se instalen por defecto.

Hecho en clase

**Tarea 3.** Configura el sistema APT para que los paquetes de 
buster-backports tengan mayor prioridad que los de unstable.

```/etc/apt/preferences.d/priorities```

```
Package: *
Pin: release a=buster-backports
Pin-priority: 960
```

```
Package: *
Pin: release a=unstable
Pin-priority: 850
```

**Tarea 4.** ¿Cómo añades la posibilidad de descargar paquetería de la 
arquitectura i386 en tu sistema. ¿Que comando has empleado?. Lista 
arquitecturas no nativas. ¿Cómo procederías para desechar la posibilidad 
de descargar paquetería de la arquitectura i386?

```dpkg -add-architecture ...```

```dpkg -remove-architecture ...```

[paquete]=[arquitectura]

**Tarea 5.** Si quisieras descargar un paquete, ¿cómo puedes saber todas 
las versiones disponible de dicho paquete?

```sudo apt-show-versions [paquete]```

**Tarea 6.** Indica el procedimiento para descargar un paquete del 
repositorio stable.

**Tarea 7.** Indica el procedimiento para descargar un paquete del 
repositorio de buster-backports.

**Tarea 8.** Indica el procedimiento para descargar un paquete del 
repositorio de sid.

**Tarea 9.** Indica el procedimiento para descargar un paquete de 
arquitectura i386.


## Trabajo con directorios


**Tarea 1.** Que cometidos tienen:
        
* _/var/lib/apt/lists/_ --> contenido/características de los repositorios.

* _/var/lib/dpkg/available_ --> lista de los paquetes disponibles en el momento.

* _/var/lib/dpkg/status_ --> contiene información sobre los paquetes instalados.

* _/var/cache/apt/archives/_ --> archivos .deb instalados.

