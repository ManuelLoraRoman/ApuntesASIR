# Compilación de un programa en C utilizando un Makefile.

Elige el programa escrito en C que prefieras y comprueba en las fuentes que
exista un fichero Makefile para compilarlo.

Realiza los pasos necesarios para compilarlo e instálalo en tu equipo en un
directorio que no interfiera con tu sistema de paquetes (/opt, /usr/local, etc.)

La corrección se hará en clase y deberás ser capaz de explicar qué son todos
los ficheros que se hayan instalado y realizar una desinstalación limpia.


En nuestro caso particular, vamos a elegir el paquete _git_.

El paquete _git_ está escrito en C y en Pearl.

Nos descargaremos el directorio de _git_ desde el siguiente repositorio:

```
https://github.com/git/git/archive/master.zip
```

Y lo enviaremos a la ubicación _/usr/local/_ para poder trabajar con ella
de manera segura.

Y en primer lugar, nos dirigimos hacia el _README.md_ para ver que
instrucciones podemos seguir para la instalación de dicho paquete.

Lo primero que nos pone es lo siguiente:

```
Git is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals.

Git is an Open Source project covered by the GNU General Public License version 2 (some parts of it are under different licenses, compatible with the GPLv2). It was originally written by Linus Torvalds with help of a group of hackers around the net.

Please read the file INSTALL for installation instructions.
```

Para instrucciones de instalación, debemos dirigirnos al fichero INSTALL.

Y una vez aquí, procederemos a la instalación.

En principio, podríamos directamente hacer un ```make install``` y con eso ya
instalaría git en nuestro propio directorio _~/bin/_. Bien, si queremos
realizar otro tipo de instalación, debemos hacer lo siguiente:

```
make prefix=/usr/local all doc info --> si lo hacemos desde nuestro usuario
make prefix=/usr/local install install-doc install-html install-info --> si lo
hacemos desde root
```
