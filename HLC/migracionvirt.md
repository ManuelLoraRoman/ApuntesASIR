# Migración de una aplicación entre máquinas virtuales

1. Crea con `virt-install` una imagen de Debian Buster con formato qcow2 y un 
tamaño máximo de 3GiB. Esta imagen se denominará `buster-base,qcow2`. El 
sistema de ficheros del sistema instalado en esta imagen será XFS. La imagen 
debe estar configurada para poder usar hasta dos interfaces de red por dhcp. 
El usuario `debian` con contraseña `debian` puede utilizar sudo sin contraseña.



2. Crea un par de claves ssh en formato ecdsa y sin frase de paso y agrega la 
clave pública al usuario `debian`

3. Utiliza la herramienta `virt-sparsify` para reducir al máximo el tamaño de 
la imagen.

4. Sube la imagen y la clave privada ssh a alguna ubicación pública desde la 
que se pueda descargar.

5. Escribe un shell script que ejecutado por un usuario con acceso a 
`qemu:///system` realice los siguientes pasos:

* Crea una imagen nueva, que utilice `buster-base.qcow2` como imagen base y 
tenga 5 GiB de tamaño máximo. Esta imagen se denominará `maquina1.qcow2`

* Crea una red interna de nombre `intra` con salida al exterior mediante NAT 
que utilice el direccionamiento `10.10.20.0/24`

* Crea una máquina virtual (`maquina1`) conectada a la red `intra`, con 1 GiB 
de RAM, que utilice como disco raíz `maquina1.qcow2` y que se inicie 
automáticamente. Arranca la máquina.

* Crea un volumen adicional de 1 GiB de tamaño en formato RAW ubicado en el pool 
por defecto.

* Una vez iniciada la MV `maquina1`, conecta el volumen a la máquina, crea un 
sistema de ficheros XFS en el volumen y móntalo en el directorio 
`/var/lib/pgsql`. Ten cuidado con los propietarios y grupos que pongas, para 
que funcione adecuadamente el siguiente punto.

* Instala en `maquina1` el sistema de BBDD `PostgreSQL` que ubicará sus ficheros
con las bases de datos en `/var/lib/pgsql` utilizando una conexión ssh.

* (Opcional) Puebla la base de datos con una BBDD de prueba (escribe
en la tarea el nombre de usuario y contraseña para acceder a la
BBDD).

* Crea una regla de NAT para que la base de datos sea accesible desde el 
exterior.

* Pausa la ejecución para comprobar los pasos hasta este punto.

* Continúa la ejecución cuando el usuario pulse 'C'.

* Crea una imagen que utilice `buster-base.qcow2` como imagen base y que tenga 
un tamaño de 4 GiB. Esta imagen se llamará `maquina2.qcow2`.

* Crea una nueva máquina (`maquina2`) que utilice imagen anterior, con 1 GiB 
de RAM y que también esté conectada a `intra`.

* Para el servicio `postgreSQL`, desmonta el dispositivo de bloques, desmonta 
el volumen de `maquina1`, monta el volumen en `maquina2` en el directorio 
`/var/lib/pgsql` teniendo de nuevo cuidado con los propietarios y permisos del 
directorio.

* Copia de forma adecuada todos los ficheros de configuración de `PostgreSQL` 
de `maquina1` a `maquina2`

* Instala `PostgreSQL` en `maquina2` a través de ssh.

* Conecta `maquina2` al bridge exterior de tu equipo, comprueba la IP que tiene 
el equipo en el bridge exterior y muéstrala por la salida estándar. Desconecta 
`maquina2` de `intra`.

* Comprueba que el servicio `PostgreSQL` funciona accediendo a través del 
bridge exterior.

* Apaga `maquina1` y aumenta la RAM de `maquina2` a 2 GiB.

