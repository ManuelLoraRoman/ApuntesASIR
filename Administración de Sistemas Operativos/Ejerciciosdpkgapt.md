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



**Tarea 12.** ¿Cómo encontrarías qué paquetes dependen de un paquete específico.

**Tarea 13.** Como procederías para encontrar el paquete al que pertenece un 
determinado archivo.

**Tarea 14.** ¿Qué procedimientos emplearías para eliminar liberar la cache 
en cuanto a descargas de paquetería?

