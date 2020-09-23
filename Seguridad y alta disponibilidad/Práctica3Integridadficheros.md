# Práctica 3: Integridad de ficheros

En caso de que algún tipo de malware reemplace o falsifique archivos del sistema operativo,
ocultándose para realizar tareas no autorizadas, la búsqueda y detección del mismo se complica 
ya que los análisis antimalware y de los procesos sospechosos por parte de administradores 
de sistemas, no dudarán de la veracidad de dichos archivos y procesos. 
A este tipo de malware se le denomina rootkit, programa que sustituye los ejecutables binarios 
del sistema para ocultarse mejor, pudiendo servir de puertas trasera o backdoor 
para la ejecución malware remota.


* *Tarea 1*: Crea un manual lo más completo posible de las herramientas sfc y dsim 
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


   *3. Protección de recursos de Windows encontró archivos dañados y no consiguió reparar algunos  
       de ellos*    

Sol: visualizamos el archivo de errores de la misma manera que el anterior punto, pero esta vez
     debemos reparar los archivos dañados de manera manual.
