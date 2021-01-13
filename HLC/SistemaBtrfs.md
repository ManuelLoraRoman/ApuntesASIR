# Sistema de ficheros

Controla cómo se almacenan y obtienen los datos.
Se interactúa mediante una capa lógica y su implementación se produce mediante
el enlace de la capa lógica con los dispositivos de almacenamiento.

Se ubican en _/dev_ y existen varios tipos. Los que nos interesan son los 
dispositivos de bloques, ya que con todo lo que interactuemos (disco duro, CD,
DVD, RAID, etc.)

* Direct Attached Storage (DAS)

Los sistemas de ficheros usados son: ext2/3/4, xfs, jfs, vfat, zfs, btrfs

* Network Attached Storage (NAS)

## Características generales avanzadas

* Copy On Write --> se descomponen los datos a almacenar en diferentes bloques.
Al crear la copia solo se crea un enlace simbólico al original. Cuando se van
modificando los datos, se van creando nuevos bloques.

* Deduplicación --> utiliza las propiedades de CoW, identificando bloques 
idénticos y los reorganiza con CoW. Permite aprovechar las características de
CoW sin intervención del usuario. 

* Cifrado --> permite el cifrado de ficheros al vuelo sin utilizar software
adicional.

* Compresión --> de la misma manera que el cifrado, permite hacerlo al vuelo.

* Gestión de volúmenes --> equivalente a LVM. Permite gestionarlos de forma
independiente de los dispositivos de bloques físicos. Estos pueden contener
varios volúmenes que pueden estar distribuidos en varios dispositivos de 
bloques.

* Instantáneas --> utiliza instantáneas de forma nativa.

* Redundancia (RAID) --> RAID software nativo en el sistema de ficheros. No es
necesario el uso de mdadm.

* Sumas de comprobación (checksum) --> utilizadas para verificar la integridad
de los ficheros.

## Sistema de ficheros Zfs

Sistema completo de almacenamiento que no requiere de herramientas adicionales.
Gestiona los dispositivos de bloques directamente, incluyendo su propia 
implementación de RAID. CoW, deduplicación, instantáneas, compresión, cifrado...

Siempre consistente sin necesidad de chequeos, se autorepara de forma continua,
muy escalable y exigente en recursos. 

* Para su instalación, debemos instalar los módulos del kérnel: 

```
sudo apt-get install spl-dkms zfs-dkms
```

* Y para la instalación de herramientas del espacio de usuario:

```
sudo apt-get install zfsutils-linux
```

## Sistema de ficheros Btrfs

Es un sistema completo de almacenamiento que no requiere de herramientas
adicionales. Con licencia GPL y completamente integrado en el kérnel.

Puede gestionar los dispositivos de bloques directamente, con implementación
de RAID. CoW, deduplicación, instantáneas, compresión, cifrado.....

Permite la autoreparación.

* Para instalar las herramientas del espacio de usuario:

```
sudo apt-get install btrfs-progs
```

## Storage Area Network (SAN)

Es una red de almacenamiento, constituida en una red dedicada que proporciona
dispositivos de bloques a servidores. Sus características son:

* Red de alta velocidad.

* Equipos o servidores que proporcionan el almacenamiento.

* Servidores que utilizan los dispositivos de bloques.

Los protocolos más usados son iSCI y FCP.


