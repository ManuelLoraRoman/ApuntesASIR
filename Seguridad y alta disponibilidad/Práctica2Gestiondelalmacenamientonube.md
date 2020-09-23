# Práctica 2: rclone - Gestionando nuestro almacenamiento en la nube


## Rclone

Rclone es una herramienta que nos permite trabajar con los ficheros que tenemos almacenados 
en distintos servicios de almacenamiento en la nube 
(dropbox, google drive, mega, box,… y muchos más que puedes ver en su página principal). 
Por lo tanto con rclone podemos gestionar y sincronizar los ficheros de 
nuestros servicios preferidos desde la línea de comandos.

* *Tarea 1*: Instala rclone en tu equipo.

* *Tarea 2*: Configura dos proveedores cloud en rclone (dropbox, google drive, mega, …).

* *Tarea 3*: Muestra distintos comandos de rclone para gestionar los ficheros 
	     de los proveedores cloud: lista los ficheros, copia un fichero local a la nube, 
	     sincroniza un directorio local con un directorio en la nube, 
	     copia ficheros entre los dos proveedores cloud, muestra alguna funcionalidad más,…

* *Tarea 4*: Monta en un directorio local de tu ordenador, los ficheros de un proveedor cloud. 
	     Comprueba que copiando o borrando ficheros en este directorio 
	     se crean o eliminan en el proveedor.


## Tarea 1

Con *sudo apt-get install rclone* instalamos en nuestra máquina el paquete.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/12.png)


## Tarea 2


Para empezar a configurar rclone, usaremos el siguiente comando:

```rclone config```

Si es la primera vez que usamos rclone, nos aparecerán 3 opciones:

* *New remote* --> permite crear un nuevo acceso a la nube.

* *Set configuration password* --> para crear una contraseña.

* *Quit config* --> para salir de rclone.

Por lo tanto, pondremos _n_ y le damos a _ENTER_.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/13.png)

Después nos preguntará por un nombre. En nuestro caso, ponemos drive.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/14.png)

Elegimos el numero correspondiente a Drive (Es decir, el número 13)

Una vez hecho esto, nos pedirá un id de Google y una clave secreta. Podemos crearla, pero si
no escribimos nada, usaremos el que incluye el propio rclone.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/15.png)

Ahora, nos pedirá que tipo de acceso queremos tener. En nuestro caso, vamos a elegir la
primera opción: acceso completo. Ponemos _1_ y le damos a _ENTER_.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/16.png)

Después nos pedirá una clave de root. No es necesario escribir nada, así que pulsamos _ENTER_.
Nos pedirá si queremos editar la configuración avanzada, y ponemos _n_ (no) y le damos a _ENTER_.
A continuación, nos pedirá si queremos usar la configuración automática. Ponemos _y_ para
confirmar, y le damos a _ENTER_.


![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/17.png)


Una vez hecho esto, tenemos que registrarnos mediante el link que se nos brinda. Lo siguiente
que se nos pregunta, es si queremos configurarlo como un equipo. Le damos a que no y continuamos.

Nos pedirá una confirmación a la vez que se nos da la información para ver si es correcta.
Hecho esto, ya tendríamos acceso a Drive.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/18.png)

Si queremos ver los diferentes archivos que tenemos, ejecutaremos el siguiente comando:

```rclone lsd drive:```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/19.png)

Seguiremos los mismos pasos para hacerlo con DropBox. Y el resultado, sería este:

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/20.png)
