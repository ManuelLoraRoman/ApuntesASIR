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

## Compilación de módulos de Linux (DKMS)

```
apt-get install build-essential --> paquete que incluye por dependencia
				    diferentes compiladores.
  
apt-get install linux-headers-'uname -r' --> son necesarios los ficheros .h que
					     se incluyen en los headers.
  
module-assistant --> se ha quedado obsoleto.
  
Se descomprime el paquete que incluye los ficheros fuentes del módulo en 
/usr/src y se sigue el README.
```

Usaremos DKMS (Dynamic Kernel Module Support), ya que compila módulos que están
fuera de la rama principal del kernel. Con módulos sin licencias compatibles
con GPL o que no son libres.

Recompila los módulos cada vez que se instala un nuevo núcleo.

## Configuración y compilación del kernel Linux


En primer lugar, buscaremos si tenemos _linux-source_ con y procedemos:

```
apt search linux-source=.... build-essential qtbase5-dev (instalación de un
							  gestor visual según el
							  paquete de linux-source)
uname -r

```

Es recomendable hacerlo todo en un directorio cuyo propietario no sea root.

Limpieza --> clean / mrpropper / distclean (cuando se vuelve a compilar)

Configuración --> oldconfig / localmodconfig / xconfig (gráfica)

```make oldconfig``` --> sobreescribe el .config

Empaquetar kernel --> bindeb-pkg 

Al usar make sin ningún parámetro, solo usará un procesador.

