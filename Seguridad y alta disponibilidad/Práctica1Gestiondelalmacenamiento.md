# Práctica 1: Gestión del almacenamiento de la información


## Ejercicio: RAID 5

Vamos a crear una máquina virtual con un sistema operativo Linux. 
En esta máquina, queremos crear un raid 5 de 2 GB, para ello vamos a utilizar
discos virtuales de 1 GB. Crea un fichero Vagrantfile para crear la máquina.

* *Tarea 1*: Crea una raid llamado md5 con los discos que hemos conectado
   a la máquina. ¿Cuantós discos tienes que conectar? 
   ¿Qué diferencia existe entre el RAID 5 y el RAID1?
    
* *Tarea 2*: Comprueba las características del RAID. Comprueba el estado 
   del RAID. ¿Qué capacidad tiene el RAID que hemos creado?
    
* *Tarea 3*: Crea un volumen lógico (LVM) de 500Mb en el raid 5.
    
* *Tarea 4*: Formatea ese volumen con un sistema de archivo xfs.
    
* *Tarea 5*: Monta el volumen en el directorio /mnt/raid5 y crea un fichero. 
   ¿Qué tendríamos que hacer para que este punto de montaje sea permanente?
    
* *Tarea 6*: Marca un disco como estropeado. Muestra el estado del raid 
   para comprobar que un disco falla. ¿Podemos acceder al fichero?
    
* *Tarea 7*: Una vez marcado como estropeado, lo tenemos que retirar del raid.

* *Tarea 8*: Imaginemos que lo cambiamos por un nuevo disco nuevo 
   (el dispositivo de bloque se llama igual), añádelo al array 
   y comprueba como se sincroniza con el anterior.
    
* *Tarea 9*: Añade otro disco como reserva. Vuelve a simular el fallo 
   de un disco y comprueba como automática se realiza la sincronización
   con el disco de reserva.
    
* *Tarea 10*: Redimensiona el volumen y el sistema de archivo de 500Mb
   al tamaño del raid.

 

## Tarea 1

Primero, instalaremos el paquete _mdadm_ para poder realizar RAIDs.

```apt-get install mdadm```


Para crear una raid llamada md5, ejecutaremos lo siguiente en la shell:

```mdadm --create /dev/md5 -l5 -n2 /dev/sdb /dev/sdc```

Tenemos que conectar dos como mínimo, y como en este caso, tenemos 2 discos
de 1 GB cada uno, conectaremos los dos.

Las diferencias entre ambos las podemos encontrar [aquí](./Introducciónalainformática.md)


## Tarea 2


Para comprobar las características del RAID, usaremos el siguiente comando:

```mdadm -D /dev/md5```

La capacidad del RAID será la combinación de ambos discos.


## Tarea 3


Para crear un volumen lógico, debemos usar _lvcreate_. Usaremos los siguientes
parámetros:

* *-n* --> esta opción se utiliza para asignar el nombre al nuevo volumen lógico. 
