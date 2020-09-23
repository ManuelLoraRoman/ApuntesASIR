# Práctica 3: Integridad de ficheros

En caso de que algún tipo de malware reemplace o falsifique archivos del sistema operativo,
ocultándose para realizar tareas no autorizadas, la búsqueda y detección del mismo se complica 
ya que los análisis antimalware y de los procesos sospechosos por parte de administradores 
de sistemas, no dudarán de la veracidad de dichos archivos y procesos. 
A este tipo de malware se le denomina rootkit, programa que sustituye los ejecutables binarios 
del sistema para ocultarse mejor, pudiendo servir de puertas trasera o backdoor 
para la ejecución malware remota.


* *Tarea 1*: Crea un manual lo más completo posible de las herramientas sfc y dism 
	     para comprobar la integridad de ficheros en Windows. 
	     Indica para qué sirven las opciones más usadas del programa y 
	     entrega capturas de pantallas para comprobar que has realizado la práctica.


* *Tarea 2*: Del mismo modo, crea un manual de la herramienta Rootkit Hunter (rkhunter) en Linux. 
	     Indica las opciones mñas usadas del programa y entrega 
	     capturas de pantallas para comprobar que has realizado la práctica.



## Tarea 1


### Manual de SFC


*SFC* es un comprobador de archivos de sistema de Windows. Permite a los usuarios detectar daños
en los archivos de sistema y restaurarlos y analizar y reemplazar los archivos protegidos del
sistema con una copia del caché.

Ante todo, el uso de SFC no garantiza la reparación total de los archivos dañados, dependerá
de la magnitud de dichos daños.


Para usarlo correctamente, ejecutaremos como administrador la CMD de Windows.

Escribimos lo siguiente:

```SFC /scannow```

A continuación, el proceso empezará y llevará un tiempo. Al final de este, se ofrecerá un informe.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/26.png)

Una vez ya terminado, aparecerá el informe.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/27.png)

Si recibes este mensaje:

> Protección de recursos de Windows no encontró ninguna infracción de integridad.

Entonces, no presenta errores y todo esta bien en el sistema.

Sin embargo pueden aparecer mensajes de error como los siguientes:


   *1. Protección de recursos de Windows no pudo realizar la operación solicitada*  

Sol: ejecutaremos de nuevo SFC, pero accediendo a Windows en modo seguro, asegurandote de tener
     las carpetas _PendingDeletes_ y _PendingRenames_ en la ruta _Windows\WinSxS\Temp_.


   *2. Protección de recursos de Windows encontró archivos dañados y los reparó correctamente.  
       Se incluye información de la CBS*  

Sol: para visualizar el archivo de errores, ejecutaremos esto en la CMD:

```findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log > "%userprofile%\Desktop\sfcdetails.txt"```

Dicho archivo aparecerá en nuestro escritorio.

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/28.png)

   *3. Protección de recursos de Windows encontró archivos dañados y no consiguió reparar algunos  
       de ellos*    

Sol: visualizamos el archivo de errores de la misma manera que el anterior punto, pero esta vez
     debemos reparar los archivos dañados de manera manual.

Algunos comandos adicionales en el uso de SFC son:


* *SFC /Revert* --> sirve para revertir la acción de escaneo de todos los archivos del sistema,

* *SFC /Purgecache* --> purga toda la caché de Windows y procede a examinar todos los archivos
			protegidos del sistema.

* *SFC /verifyonly* --> se utiliza para analizar todos los archivos protegidos de Windows, pero
			sin efectuar reparaciones.

* *SFC /scanfile* --> sirve para analizar la integridad de un archivo específico.


### Manual de DISM

DISM son las siglas de _Deployment Image Servicing and Management_. Herramienta que permite la
administración y el mantenimiento de las imágenes desde Windows. Busca daños en imágenes y
procede a repararlos a partir de un repositorio que posee el sistema operativo.

El comando DISM sirve para capturar imágenes de Windows, agregar o eliminar imágenes de un
archivo o dividirlos en más pequeños.

Para reparar el sistema con DISM, debes dirigirte a la CMD y ejecutarla con permisos de
administración.

Hecho ya esto, primero detectamos los daños en el sistema con el siguiente comando:

```Dism.exe /Online/Cleanup-image/CheckHealth```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/29.png)

Este, escanea los archivos en busca de errores:

```DISM.exe/Online/Cleanup-image/Scanhealth```

![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Imágenes/30.png)

Si queremos reparar el sistema, escribiremos lo siguiente:

```DISM /Online/Cleanup-image/RestoreHealth```

y presionamos _ENTER_.

Realizará una comprobación y después intentará repararlo.


Algunas opciones de DISM útiles adicionales son:


* *Analyze* --> utiliza el comando _analysecomponentstore y comprueba la memoria del componente
		si se puede liberar espacio de memoria.


* *Apply-Image* --> aplica una imagen.

* *Get_MountedImageInfo* --> muestra información de las imágenes WIM y VHD montadas.

* *Mount-Image* --> Monta una imagen desde un archivo WIN o VHD.

* *List-Image* --> Muestra una lista de los archivos y las carpetas de una imagen especificada.


