# Kérnel del Sistema Operativo

Es la parte fundamental del sistema operativo y se encarga de manejar los
recursos y permitir que los programas hagan uso de los mismos.

Es el que permite acceder a la CPU, a la memoria y a los dispositivos de
entrada/salida.

El kernel suele utilizar al menos dos niveles para acceder tanto a la CPU, como
a la memoria:

* _kernel mode_ (Sin restricciones)

* _user mode_ (Restringido)

Un kernel monolítico es aquel que todo se hace a través de _kernel mode_.


## Características de la compilación del kernel

Los componentes del kernel se compilan de dos formas:

* Se incluyen dentro de un fichero que se denomina _vmlinuz_ o _zImage_.

* Se compilan individualmente en ficheros objetos con extensión _.ko_ que se
cargan en memoria a demanda (/lib/modules).
