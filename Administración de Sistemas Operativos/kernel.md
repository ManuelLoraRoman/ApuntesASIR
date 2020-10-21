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

Soluciones para hardware no detectado en el arranque:

* Se aumenta el tamaño del fichero ejecutable (_bzImage_).

* Se montan temporalmente algunos módulos en memoria (_initramfs_).

Distribuciones de uso general en sistemas _X86_:

* Enorme variedad de hardware.

* Se incluyen gran cantidad de módulos.

Es posible compilar un kérnel para hardware determinado y reducir mucho 
su tamaño.

## Módulos del kérnel

La mayoría se cargan automáticamente cuando es necesario, pero es posible
hacerlo manualmente:

```
lsmod --> módulos cargados

modprobe 'módulo' --> carga el módulo en memoria

modprobe -r 'módulo' --> descarga el módulo de la memoria

find /lib/modules/'uname -r' -type f -iname '*.ko' --> módulos disponibles

modinfo 'módulo' --> información del módulo

depmod --> actualiza las dependencias de los módulos

dmesg --> controla los logs del kérnel

journalctl -k -f --> muestra los logs
```

