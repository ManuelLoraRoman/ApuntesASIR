# Sistemas de ficheros "avanzados" ZFS/Btrfs

Elige uno de los dos sistemas de ficheros "avanzados".

Vamos a elegir el sistema de ficheros ZFS.
    
* Crea un escenario que incluya una máquina y varios discos asociados a ella.
    
Tenemos una máquina Debian al cual le hemos añadido 4 discos. 3 de ellos de 1 GB
y el otro de 2 GB. La máquina tiene 4 GB de RAM y un disco duro de 12 GB.

```
root@debian:~$ lsblk -l
NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda    8:0    0   12G  0 disk 
sda1   8:1    0    8G  0 part /
sda2   8:2    0    1K  0 part 
sda5   8:5    0    4G  0 part [SWAP]
sdb    8:16   0    1G  0 disk 
sdc    8:32   0    1G  0 disk 
sdd    8:48   0    1G  0 disk 
sde    8:64   0    2G  0 disk 
sr0   11:0    1 73,8M  0 rom  /media/cdrom0
```

* Instala si es necesario el software de ZFS/Btrfs
   
Para instalar ZFS, en primer lugar debemos descargar los siguientes paquetes:

```
root@debian:~$ apt-get install build-essential autoconf automake libtool gawk 
alien fakeroot ksh zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev 
libudev-dev libacl1-dev libaio-dev libdevmapper-dev libssl-dev libelf-dev

root@debian:~$ apt-get install linux-headers-$(uname -r)
```

Tras instalarlos, modificamos el fichero _/etc/apt/sources.list_ y añadimos las
lineas:

```
deb http://deb.debian.org/debian buster-backports main contrib
deb-src http://deb.debian.org/debian buster-backports main contrib
```

Una vez hecho eso, ejecutamos un ```apt-get update``` e instalamos los
paquetes necesarios:

```
root@debian:~$ apt-get install zfs-dkms zfsutils-linux
```

Terminada la instalación, ya podríamos realizar los ejercicios.

* Gestiona los discos adicionales con ZFS/Btrfs
   

La comprobación del estado de los discos no está disponible debido a que
todavía no se han configurado:

```
root@debian:~$ zpool status
no pools available
```

* Configura los discos en RAID, haciendo pruebas de fallo de algún disco y 
sustitución, restauración del RAID. Comenta ventajas e inconvenientes respecto 
al uso de RAID software con mdadm.
   
Vamos a realizar una configuración de RAID 1 con los 3 discos de 1 GB:

```
root@debian:~$ zpool create -f RAID1 mirror /dev/sdb /dev/sdc /dev/sdd
```

Y se vuelve a comprobar el estado de las pools:

```
root@debian:~$ zpool status
  pool: RAID1
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0

errors: No known data errors
```

Añadimos el último disco como reserva en el RAID:

```
root@debian:~$ zpool add -f RAID1 spare /dev/sde
```

Y comprobamos de nuevo el estado de las pools:

```
root@debian:~$ zpool status
  pool: RAID1
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	spares
	  sde       AVAIL   

errors: No known data errors
```

A continuación, simularemos un error en el RAID1:

```
root@debian:~$ zpool offline -f RAID1 /dev/sdc
```

Y volveremos a comprobar el estado del RAID:

```
root@debian:~$ zpool status
  pool: RAID1
 state: DEGRADED
status: One or more devices are faulted in response to persistent errors.
	Sufficient replicas exist for the pool to continue functioning in a
	degraded state.
action: Replace the faulted device, or use 'zpool clear' to mark the device
	repaired.
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       DEGRADED     0     0     0
	  mirror-0  DEGRADED     0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     FAULTED      0     0     0  external device fault
	    sdd     ONLINE       0     0     0
	spares
	  sde       AVAIL   

errors: No known data errors
```

Para reemplazar el disco fallido haremos lo siguiente:

```
root@debian:~$ zpool replace -f RAID1 /dev/sdc /dev/sde
```

Y comprobamos de nuevo el estado:

```
root@debian:~$ zpool status
  pool: RAID1
 state: DEGRADED
status: One or more devices are faulted in response to persistent errors.
	Sufficient replicas exist for the pool to continue functioning in a
	degraded state.
action: Replace the faulted device, or use 'zpool clear' to mark the device
	repaired.
  scan: resilvered 273K in 0 days 00:00:03 with 0 errors on Sat Jan 16 21:29:09 2021
config:

	NAME         STATE     READ WRITE CKSUM
	RAID1        DEGRADED     0     0     0
	  mirror-0   DEGRADED     0     0     0
	    sdb      ONLINE       0     0     0
	    spare-1  DEGRADED     0     0     0
	      sdc    FAULTED      0     0     0  external device fault
	      sde    ONLINE       0     0     0
	    sdd      ONLINE       0     0     0
	spares
	  sde        INUSE     currently in use

errors: No known data errors
```

Y restauraremos el disco fallido:

```
root@debian:~$ zpool clear RAID1 /dev/sdc
```

Estado de las pools:

```
root@debian:~$ zpool status
  pool: RAID1
 state: ONLINE
  scan: resilvered 273K in 0 days 00:00:03 with 0 errors on Sat Jan 16 21:29:09 2021
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
spares
	  sde       AVAIL   

errors: No known data errors
```

Podemos automatizar todos los anteriores procesos, pero para ello debemos
modificar algunos parámetros. En primer lugar, modificaremos el parámetro
_autoreplace_ y lo pondremos en on:

```
root@debian:~$ zpool get all RAID1 | grep autoreplace
RAID1  autoreplace		      off			default
root@debian:~$ zpool autoreplace=on RAID1
root@debian:~$ zpool get all RAID1 | grep autoreplace
RAID1  autoreplace		      on			local
```

Para restaurar el RAID1 mediante un checkpoint, debemos realizar los siguientes
pasos: 

```
root@debian:~$ zpool checkpoint RAID1
```

Esto creará el checkpoint. Vemos el estado:

```
root@debian:~$ zpool get all RAID1 | grep checkpoint
RAID1  checkpoint                     104K                           -
RAID1  feature@zpool_checkpoint       active                         local
```

Por último, vamos a comprobar que la restauración mediante el checkpoint
funciona:

```
root@debian:~$ zpool offline -f RAID1 /dev/sdc /dev/sdd
root@debian:~$ zpool status
  pool: RAID1
 state: DEGRADED
status: One or more devices are faulted in response to persistent errors.
	Sufficient replicas exist for the pool to continue functioning in a
	degraded state.
action: Replace the faulted device, or use 'zpool clear' to mark the device
	repaired.
  scan: resilvered 72K in 0 days 00:00:05 with 0 errors on Sat Jan 16 21:38:17 2021
checkpoint: created Sun Jan 17 13:27:04 2021, consumes 108K
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       DEGRADED     0     0     0
	  mirror-0  DEGRADED     0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     FAULTED      0     0     0  external device fault
	    sdd     FAULTED      0     0     0  external device fault
	spares
	  sde       AVAIL   

errors: No known data errors
vagrant@nfs:~$ sudo zpool export RAID1
vagrant@nfs:~$ sudo zpool status
no pools available
vagrant@nfs:~$ sudo zpool import --rewind-to-checkpoint RAID1
vagrant@nfs:~$ sudo zpool status
  pool: RAID1
 state: ONLINE
  scan: resilvered 72K in 0 days 00:00:05 with 0 errors on Sat Jan 16 21:38:17 2021
config:

	NAME        STATE     READ WRITE CKSUM
	RAID1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	spares
	  sde       AVAIL   

errors: No known data errors
```

Otro tipo de RAID que podemos crear es el RAIDZ. Este RAID es parecido al RAID5
ya que tiene un esquema de redundancia y existen tres tipos de este RAID. 
A continuación, vamos a crear un RAIDZ 2 ya que tiene 2 bits de paridad:

```
root@debian:~$ zpool export RAID1
root@debian:~$ zpool create -f RAIDZ raidz2 /dev/sdb /dev/sdc /dev/sdd /dev/sde
root@debian:~$ zpool status -v RAIDZ
  pool: RAIDZ
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	RAIDZ       ONLINE       0     0     0
	  raidz2-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	    sde     ONLINE       0     0     0

errors: No known data errors
```

Ventajas de ZFS
----------------

1. Se ha diseñado de manera que no tengamos limitaciones reales. Permite crear
2⁴⁸ instántaneas, 2⁴⁸ número de ficheros en el sistema de ficheros.
16 hexabytes para el tamaño máximo de ficheros y con una capacidad máxima de 
256 cuatrillones de Zettabytes.

2. Espacios de almacenamiento virtuales que permite agregar discos de manera
dinámica.

3. Modelo transaccional de _copy-on-write_.

4. La información nueva que se va añadiendo se escribe en diferentes discos,
lo que asegura que en caso de fallo sobreescribiendo, se conservan los datos
antiguos.


Ventajas de mdadm
-------------------

1. Incluida en el kernel Linux ya que posee licencia GPL.


* Realiza ejercicios con pruebas de funcionamiento de las principales 
funcionalidades: compresión, cow, deduplicación, cifrado, etc.



Esta tarea se puede realizar en una instancia de OpenStack y documentarla 
como habitualmente o bien grabar un vídeo con una demo de las características 
y hacer la entrega con el enlace del vídeo.

