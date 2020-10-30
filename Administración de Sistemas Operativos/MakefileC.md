# Compilación de un programa en C utilizando un Makefile.

Elige el programa escrito en C que prefieras y comprueba en las fuentes que
exista un fichero Makefile para compilarlo.

Realiza los pasos necesarios para compilarlo e instálalo en tu equipo en un
directorio que no interfiera con tu sistema de paquetes (/opt, /usr/local, etc.)

La corrección se hará en clase y deberás ser capaz de explicar qué son todos
los ficheros que se hayan instalado y realizar una desinstalación limpia.

Vamos a utilizar el paquete _FIGlet_. FIGlet es un programa que permite
crear palabras por la terminal hechas con texto ordinario.

Nos descargaremos su repositorio desde el siguiente enlace: _https://github.com/cmatsuoka/figlet_.

Una vez tengamos el directorio de _figlet_ en nuestra posesión, debemos en
primer lugar el fichero README. En este, nos comenta (en este caso), el
proceso de instalación del paquete _figlet_.

1. Editaremos el fichero Makefile, concretamente los parámetros llamados
_DEFAULTFONTDIR_ y _DEFAULTFONTFILE_. El primer parámetro nos indica donde
se guardarán los ficheros de las distintas fuentes de figlet, y el segundo
nos indicará donde se guardará el fichero de fuente predeterminado.
Seguiremos las recomendaciones y modificaremos las siguientes líneas:

```
# Where figlet will search first for fonts (the ".flf" files).
DEFAULTFONTDIR = /usr/games/lib/figlet.dir
# Use this definition if you can't put things in $(prefix)/share/figlet
#DEFAULTFONTDIR = fonts

# The filename of the font to be used if no other is specified,
#   without suffix.(standard is recommended, but any other can be
#   used). This font file should reside in the directory specified
#   by DEFAULTFONTDIR.
DEFAULTFONTFILE = standard
```

Una vez hecho esto, tenemos dos opciones. Primero, podemos proceder directamente
a la compilación de FIGlet haciendo un ```make figlet``` y después copiar varios
ficheros en sus localizaciones apropiadas, junto con el ejecutable de figlet,
con _figlist y showfigfonts_, las fuentes y ficheros de control y la página de
man. Esto puede llegar a resultar un tanto tedioso, por lo tanto, tenemos la
segunda opción que es una instalación completa.

Para la instalación completa, en primer lugar debemos iniciar las variables
BINDIR y MANDIR en el Makefile con los valores adecuados. BINDIR es la ruta
completa del directorio donde se encuentra el ejecutable de FIGlet y MANDIR
sería la ruta del directorio donde se encontraría la página del man de FIGlet.

```
# Where the executables should be put
BINDIR  = /usr/games

# Where the man page should be put
MANDIR  = /usr/man/man6
```

Y una vez hecho esto, hacemos un ```make install```.

La primera vez que lo ejecutamos nos salta el siguiente error:

```
vagrant@Makefile:~/figlet-master$ make install
gcc -c -g -O2 -Wall -Wno-unused-value -DTLF_FONTS -DDEFAULTFONTDIR=\"/usr/games/lib/figlet.dir\" \
	-DDEFAULTFONTFILE=\"standard.flf\" -o figlet.o figlet.c
make: gcc: Command not found
make: *** [Makefile:65: figlet.o] Error 127
```

Nos indica que no tenemos el paquete gcc instalado. Procedemos a instalarlo y
volvemos a ejecutar la instrucción.

```
vagrant@Makefile:~/figlet-master$ sudo make install
gcc -c -g -O2 -Wall -Wno-unused-value -DTLF_FONTS -DDEFAULTFONTDIR=\"/usr/games/lib/figlet.dir\" \
	-DDEFAULTFONTFILE=\"standard.flf\" -o figlet.o figlet.c
gcc -c -g -O2 -Wall -Wno-unused-value -DTLF_FONTS -DDEFAULTFONTDIR=\"/usr/games/lib/figlet.dir\" \
	-DDEFAULTFONTFILE=\"standard.flf\" -o zipio.o zipio.c
gcc -c -g -O2 -Wall -Wno-unused-value -DTLF_FONTS -DDEFAULTFONTDIR=\"/usr/games/lib/figlet.dir\" \
	-DDEFAULTFONTFILE=\"standard.flf\" -o crc.o crc.c
gcc -c -g -O2 -Wall -Wno-unused-value -DTLF_FONTS -DDEFAULTFONTDIR=\"/usr/games/lib/figlet.dir\" \
	-DDEFAULTFONTFILE=\"standard.flf\" -o inflate.o inflate.c
gcc -c -g -O2 -Wall -Wno-unused-value -DTLF_FONTS -DDEFAULTFONTDIR=\"/usr/games/lib/figlet.dir\" \
	-DDEFAULTFONTFILE=\"standard.flf\" -o utf8.o utf8.c
gcc  -o figlet figlet.o zipio.o crc.o inflate.o utf8.o
gcc -c -g -O2 -Wall -Wno-unused-value -DTLF_FONTS -DDEFAULTFONTDIR=\"/usr/games/lib/figlet.dir\" \
	-DDEFAULTFONTFILE=\"standard.flf\" -o chkfont.o chkfont.c
gcc  -o chkfont chkfont.o
mkdir -p /usr/games
mkdir -p /usr/man/man6/man6
mkdir -p /usr/games/lib/figlet.dir
cp figlet chkfont figlist showfigfonts /usr/games
cp figlet.6 chkfont.6 figlist.6 showfigfonts.6 /usr/man/man6/man6
cp fonts/*.flf /usr/games/lib/figlet.dir
cp fonts/*.flc /usr/games/lib/figlet.dir
```

Y comprobamos que se ha instalado bien FIGlet.

```
vagrant@Makefile:~/figlet-master$ figlet -f standard hola

| |__   ___ | | __ _
| '_ \ / _ \| |/ _` |
| | | | (_) | | (_| |
|_| |_|\___/|_|\__,_|
```

Ahora vamos a probar con otro tipo de fuente:

```
vagrant@Makefile:~/figlet-master$ figlet -f slant hola

   / /_  ____  / /___ _
  / __ \/ __ \/ / __ `/
 / / / / /_/ / / /_/ /
/_/ /_/\____/_/\__,_/

```

```
vagrant@Makefile:~/figlet-master$ figlet -f shadow hola
 |           |
 __ \   _ \  |  _` |
 | | | (   | | (   |
_| |_|\___/ _|\__,_|

```

Hay algunos paquetes que permiten el uso de ```make uninstall```. En el caso
del paquete _FIGlet_, no permite el uso de dicho comando. Por lo tanto, otra
opción para la desinstalación de dicho paquete que podemos hacer es la
siguiente:

En primera instancia, ejecutaremos: ```whereis [paquete en cuestión]```.

En nuestro caso, los directorios se hallan en estas ubicaciones:

```
vagrant@Makefile:~$ whereis figlet
figlet: /usr/games/figlet /usr/games/lib/figlet.dir /usr/local/bin/figlet
```

Así conseguimos listar los directorios donde nuestro binario ha sido instalado.
Y uno a uno, eliminamos los directorios/ficheros que se han creado con la
instalación.

En nuestro caso, es necesario también eliminar los ficheros _figlist_,
_showfigfonts_ y _chkfont_.
