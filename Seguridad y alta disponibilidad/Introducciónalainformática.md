# Introducción a la Seguridad Informática

## 1. Gestión del almacenamiento

A la hora de diseñar una política de almacenamiento, tenemos en cuenta lo
siguiente:

* *Rendimiento*

* *Disponibilidad*

* *Accesibilidad*

El almacenamiento en la nube está creciendo a alta velocidad en los últimos
tiempos. Dicho esto, estas son algunas de sus ventajas e inconvenientes:

<div align="center">

#### Ventajas

 Actualización de los datos en tiempo real

 Acceso a los datos en cualquier lugar

 Costes


#### Inconvenientes

 Seguridad

 Dependencia

</div>

## 2. RAID

Ahora hablaremos del Almacenamiento redundante, o RAID. Consiste en un conjunto
de discos entre los que se distribuyen o se replican datos. Gracias a estos,
tenemos:

* Mayor integridad

* Mayor tolerancia a fallos

* Mayor rendimiento

* Mayor capacidad

Aunque nosotros trabajaremos con RAID software, existen también RAIDs hardware 
y RAIDs HÍBRIDOS.


### RAID 0 --> Striping/división


Reparte los datos en varios discos duros, sin haber redundancia de datos.
Se puede leer y escribir a la vez. Aumenta el rendimiento y son necesarios al
menos 2 discos. Las capacidades de estos se visualizan como si fuese una sola.
Los discos pueden ser de varias capacidades, pero siempre se reduce al menor.
0 tolerancia a fallos


### RAID 1 --> Mirroring/ESpejo

Redundancia total de datos, por lo tanto, aumenta la fiabilidad. Al menos 2
discos. Capacidad idéntica al anterior RAID. (n - 1) tolerancia a fallos.


### RAID 5 --> Mirroring + paridad distribuida

La información del usuario se graba por bloques y de forma alternativa en todos
los discos. Gracias a la información de paridad es capaz de salvar pérdidas. 
Máxima fiabilidad. Se requiere de 3 discos como mínimo, 1 tolerancia a fallos.


## 3. Discos de reserva

En la mayoría de las configuraciones RAID, cuando se produce un fallo, los 
datos no son accesibles hasta que se sustituya el disco y se restaure el
contenido. 

Por eso, es recomendable utilizar un disco de reserva o *hot spare* como
suplente. Permanece inactivo hasta que falla el RAID. 

Utilizando un *hot spare* se reduce mucho el tiempo de recuperación de los
datos.
