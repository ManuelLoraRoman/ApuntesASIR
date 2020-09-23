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

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/2.png)

Tenemos que conectar dos como mínimo, y como en este caso, tenemos 2 discos
de 1 GB cada uno, conectaremos los dos.

Las diferencias entre ambos las podemos encontrar [aquí](./Introducciónalainformática.md)


## Tarea 2


Para comprobar las características del RAID, usaremos el siguiente comando:

```mdadm -D /dev/md5```

La capacidad del RAID será la combinación de ambos discos.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/1.png)

## Tarea 3


Antes de crear un volumen lógico, debemos crear un volumen físico, y acto seguido,
un grupo de volúmenes. Para ello, debemos instalar el paquete *lvm2*.

Para el volumen físico, haremos lo siguiente:

```sudo pvcreate /dev/sdd```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/3.png)

y para el grupo de volúmenes:

```sudo vgcreate vgs /dev/sdd```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/4.png)

Por último, para crear un volumen lógico, debemos usar _lvcreate_. Usaremos los siguientes
parámetros:

* *-n* --> esta opción se utiliza para asignar el nombre al nuevo volumen lógico. 

* *Volumen de grupo* --> debemos indicar en cual volumen de grupo vamos a crear el 
			 volumen lógico.

* *-L* --> establece el tamaño que vamos a asignar, M para Megabytes o G para
	   Gigabytes.

Por lo tanto, ejecutaremos el siguiente comando:

```lvcreate -n vol1 vgs -L 500M```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/5.png)

## Tarea 4


Para formatear el volumen anterior, debemos ejecutar lo siguiente:

```mkfs.xfs /dev/mapper/vgs-vol1```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/6.png)

## Tarea 5

Para montar el nuevo sistema de archivos, en primer lugar crearemos el directorio
raid5 en el directorio /mnt.

```mount /dev/mapper/vgs-vol1 /mnt/raid5```

## Tarea 6

Para marcar un disco como estropeado, haremos lo siguiente:

```sudo mdadm --fail /dev/md5 /dev/sdb```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/7.png)

Y si, efectivamente, se puede visualizar el fichero, ya que el RAID5 lo permite.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/8.png)


## Tarea 7

Para extraer un disco estropeado del RAID, debemos ejecutar este comando:

```sudo mdadm --remove /dev/md5 /dev/sdb```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/9.png)

## Tarea 8

Para añadir un disco nuevo al RAID, haríamos esto:

```sudo mdadm --add /dev/md5 /dev/sdb```

Como solo tenemos dos discos, pues lo haríamos de esta manera:

```sudo mdadm --re-add /dev/md5 /dev/sdb```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/10.png)

## Tarea 9

Para añadir un disco de reserva usamos:

```mdadm --add-spare /dev/md5 /dev/sdd```

Esta operación se realiza de manera muy fácil.

Para volver a simular el fallo, usaremos el comando usado anteriormente en la tarea 7.


## Tarea 10

Para redimensionar el volumen lógico, haremos esto:

```sudo lvresize -l +100%FREE /dev/mapper/vgs-vol1```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/11.png)
