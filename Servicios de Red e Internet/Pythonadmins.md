# Python para sysadmins


Muchas veces, para automatizar los procesos que realizan los administradores
es necesario crear scripts. 

## Módulo os

Nos permite acceder a funcionalidades dependientes del SO.

* **os.access(path, modo_de_acceso) --> saber si se puede acceder a un archivo o
					directorio.

* **os.getcwd()** --> conocer el directorio actual.

* **os.chdir(nuevo_path)** --> cambiar de directorio de trabajo.

* **os.chroot()** --> cambiar al directorio de trabajo raíz.

* **os.chmod(path, permisos)** --> cambiar los permisos.

* **os.chown(path, permisos)** --> cambiar propietarios.

* **os.mkdir(path[, modo])** --> crear un directorio.

* **os.mkdirs(path[, modo])** --> crear directorios recursivamente.

* **os.remove(path)** --> eliminar un archivo.

* **os.rmdir(path)** --> eliminar un directorio.

* **os.removedirs(path)** --> eliminar directorios recursivamente.

* **os.rename(actual, nuevo)** --> renombrar un archivo.

* **os.symlink(path, nombre_destino)** --> crear enlace simbólico.


###Ejemplo:

> import os  
> os.getcwd()  
> '/home/manuel/ApuntesASIR/HLC'  
> os.chdir("..")  
> os.getcwd()  
> '/home/manuel/ApuntesASIR/'  

El módulo os nos provee un submódulo _path_ el cual nos permite acceder a
ciertas funcionalidades:


* **os.path.abspath(path)** --> ruta absoluta.

* **os.path.basename(path)** --> directorio base.

* **os.path.exists(path)** --> saber si existe el directorio.

* **os.path.getatime(path)** --> conocer último acceso al directorio.

* **os.path.getsize(path)** --> conocer tamaño.

* **os.path.isabs(path)** --> saber si es ruta absoluta.

* **os.path.isfile(path)** --> saber si es archivo.

* **os.path.isdir(path)** --> saber si es directorio.

* **os.path.islink(path)** --> saber si es enlace simbólico.

* **os.path.ismount(path)** --> saber si es punto de montaje.


## Módulo subprocess

Con _system() del módulo _os_ nos permite ejecutar comandos del SO.

> os.system("ls")  
ApuntesASIR Escritorio Descargas Videos Imágenes.....  
0  

Si expresa el 0, entonces el comando se ejecutó correctamente.

El módulo subprocess permite esto mismo, con la funcionalidad añadida de 
poder guardar la salida en una variable.

> import subprocess  
> subprocess.call("ls")
 ApuntesASIR Escritorio Descargas Videos Imágenes....  
 0  

> salida = subprocess.check_output("ls")  
> print(salida.decode())  
ApuntesASIR  
Escritorio  
Descargas  
...  

> salida=subprocess.check_output(["df","-h"])  
> Así sería si pusieses parámetros en el comando.  


## Módulo shutil

Sirve para realizar operaciones de alto nivel con archivos y directorios.

* **shutil.copyfileobj(fsrc, fdst[, length])** --> copia un fichero completo o
parte.

* **shutil.copyfile(src, dst, *, follow_symlinks=True)** --> copia el contenido
completo de un archivo.

* **shutil.copymode(src, dst, *, follow_symlinks=True)** --> copia los permisos
de un archivo origen a uno destino.

* **shutil.copystat(src, dst, *, follow_symlinks=True)** --> copia permisos,
fecha-hora de la última modificación y atributos.

* **shutil.copy(src, dst, *, follow_symlinks=True)** --> copia un archivo.

* **shutil.move(src, dst, *, follow_symlinks=True)** --> copia archivos.

* **shutil.disk_usage(path)** --> obtiene información del espacio total.

* **shutil.chown(path, user=None, group=None)** --> obtiene la ruta de un
archivo ejecutable.

* **shutil.which(cmd, mode=os.F_OK | os.X_OK, path=None)** --> saber si una
ruta es un enlace simbólico.


## Módulo sys

Encargado de proveer variables y funcionalidades, directamente relacionadas
con el intérprete.

* **sys.argv** --> retorna una lista con todos los argumentos pasados por 
línea de comandos. Al ejecutar python modulo.py arg1 arg2, retornará una lista:
['modulo.py', 'arg1', 'arg2']

* **sys.executable** -->  retorna el path absoluto del binario ejecutable del
intérprete de Python.

* **sys.platform** --> retorna la plataforma sobre la cuál se está ejecutando el
intérprete.

* **sys.version** --> retorna el número de la version de Python.

* **sys.exit()** --> forzar la salida del intérprete.

* **sys.getdefaultencoding()** --> retorna la codificación de caracteres por
defecto.

## Ejecución de scripts con argumentos


```#!/usr/bin/env python    
 import sys  
 print("Has instroducido",len(sys.argv),"argumento")  
 suma=0  
 for i in range(1,len(sys.argv)):  
	suma=suma+int(sys.argv[i])  
print("La suma es ",suma)  
```

> python3 sumar.py 3 4 5  
Has introducido 4 argumentos  
La suma es 12  
