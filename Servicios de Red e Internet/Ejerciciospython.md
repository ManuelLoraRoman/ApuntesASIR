# Ejercicios

Realiza un script en python que realice la siguiente función:

**Tarea 1.** Muestra el directorio de trabajo.

**Tarea 2.** Muestra cuantos usuarios hay definido en el sistema

**Tarea 3.** Muestra los usuarios conectados al equipo.

**Tarea 4.** Script que lea el nombre de un usuario, si existe dice si es 
administrador o no, si no existe da un mensaje de error. 
Realiza el script leyendo el usuario por teclado, y realiza otra 
versión indicándolo como parámetro.

**Tarea 5.** Pasa por parámetros una dirección ip y un nombre de máquina e 
inserta en /etc/hosts (en la tercera línea) la resolución estática. 
Si no se introducen dos parámetros se da un error.

**Tarea 6.** Para crear un usuario "a mano":
        
 * Editar /etc/passwd y agregar una nueva linea por cada nueva cuenta. 
   Teniendo cuidado con la sintaxis. Debería hacer que el campo de la 
   contraseña sea '*', de esta forma es imposible ingresar al sistema.
 * De forma similar, edite /etc/group para crear también un grupo.
 * Crea el directorio Inicio del usuario con el comando mkdir.
 * Copia los archivos de /etc/skel al nuevo directorio creado
 * Corrige la pertenencia del dueño y permisos con los comandos chown y chmod 
   (Ver paginas de manual de los respectivos comandos). La opción -R es 
   muy útil. Los permisos correctos varían un poco de un sitio a otro, 
   pero generalmente los siguientes comandos harán lo correcto:

	> cd /home/nuevo-nombre-de-usuario  
	> chown -R nombre-de-usuario:group  
	> chmod -R 755  

 * Asigne una contraseña con el comando passwd
 * Crea un script python que cree un usuario, para ello debe recibir el nombre 
   de usuario y nombre completo por parámetros, por defecto se pone uid y gid 
   a 2000. Mejorar el programa para que:
 * Da un error si se intenta dar de alta un usuario que ya existe
 * Al ir dando de alta a distintos usuarios vaya incrementando automáticamente 
   el uid y el gid a partir de 2000 {% endcapture %} 
   {{ notice-text | markdownify }}

## Tarea 1

#!/usr/bin/env python	
> import os  
> import subprocess  

>salida=subprocess.check_output("ls")  

>print("Nuestro directorio de trabajo es ", os.getcwd() ,
>" y está compuesto por: \n", salida.decode())  

# Tarea 2

#!/usr/bin/env python   
> import os  
> import subprocess  

> salida=subprocess.check_output(["cut","-d:","-f1","/etc/password"])  
> lista=len(salida.decode())  

> print("Número de usuarios definidos en el sistema: , lista , ".")  

# Tarea 3

#!/usr/bin/env python   
> import os  
> import subprocess  

> salida=subprocess.check_output("w")  

> print("Usuarios conectados: \n", salida.decode() ,".")  


## Tarea 4

#!/usr/bin/env python

> import os  
> import subprocess  

> usuario=raw_input("Usuario:")  
> f=open("/etc/passwd","r")  
> lineas=f.read()  
> if lineas.find(usuario)==-1:  
>	print "Usuario no existe"  
> if lineas.find(usuario+":x:0:0")==-1:  
>	print "No es administrador"  
> else:  
>	print "Es administrador"  

## Tarea 5

#!/usr/bin/env python

> import os  
> import subprocess  

> f=open("/etc/hosts","r")  
> lineas=f.readlines()  
> lineas.insert(3,"192.168.6.5\tpepito.com\n")  
> f.close()  
> f=open("/etc/hosts","w")  
> for linea in lineas:  
>	f.write(linea)  
> f.close()  

## Tarea 6

#!/usr/bin/env python

> import os  

> usuario=raw_input("Usuario:")  
> usuariol=raw_input("Nombre:")  
> f=open("/etc/passwd","a")  
> f.write(usuario+":x:2000:2000:"+usuariol+",,,:/home/"+usuario+":/bin/bash")  
> f.close()  
  
> f=open("/etc/group","a")  
> f.write(usuario+":x:2001:")  
> f.close()  

> os.mkdir("/home/"+usuario)  
