# Despliegue de CMS Java

En esta práctica vamos a desplegar un CMS escrito en java. Puedes escoger la 
aplicación que vas a desplegar de CMS escritos en Java o de Aplicaciones Java 
en Bitnami.

Se evaluará la complejidad de la instalación (por ejemplo, necesidad de tener 
que instalar un conector de base de datos, …), ejemplo de puntuación 
(de un máximo de 10 puntos).

* Indica la aplicación escogida y su funcionalidad.

En nuestro caso elegiremos el CMS llamado Apache Guacamole, que es una 
herramienta de código abierto soportada por la Fundación Apache que se basa en
ofrecernos un acceso remoto centralizado bajo unas únicas credenciales para
acceder a nuestros equipos.
   
* Escribe una guía de los pasas fundamentales para realizar la instalación.
   
En primer lugar, necesitamos instalar TOMCAT:

```
debian@ldapej:~$ sudo apt-get install tomcat9
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  ca-certificates-java default-jre-headless fontconfig-config
  fonts-dejavu-core java-common libasound2 libasound2-data libavahi-client3
  libavahi-common-data libavahi-common3 libcups2 libeclipse-jdt-core-java
  libfontconfig1 libjpeg62-turbo liblcms2-2 libnspr4 libnss3 libpcsclite1
  libtcnative-1 libtomcat9-java libx11-6 libx11-data libxau6 libxcb1 libxdmcp6
  libxext6 libxi6 libxrender1 libxtst6 openjdk-11-jre-headless tomcat9-common
  x11-common
Suggested packages:
  default-jre libasound2-plugins alsa-utils cups-common liblcms2-utils pcscd
  libnss-mdns fonts-dejavu-extra fonts-ipafont-gothic fonts-ipafont-mincho
  fonts-wqy-microhei | fonts-wqy-zenhei fonts-indic tomcat9-admin tomcat9-docs
  tomcat9-examples tomcat9-user
The following NEW packages will be installed:
  ca-certificates-java default-jre-headless fontconfig-config
  fonts-dejavu-core java-common libasound2 libasound2-data libavahi-client3
  libavahi-common-data libavahi-common3 libcups2 libeclipse-jdt-core-java
  libfontconfig1 libjpeg62-turbo liblcms2-2 libnspr4 libnss3 libpcsclite1
  libtcnative-1 libtomcat9-java libx11-6 libx11-data libxau6 libxcb1 libxdmcp6
.
.
.
Creating config file /etc/default/tomcat9 with new version
Created symlink /etc/systemd/system/multi-user.target.wants/tomcat9.service → /lib/systemd/system/tomcat9.service.
Processing triggers for libc-bin (2.28-10) ...
Processing triggers for rsyslog (8.1901.0-1) ...
Processing triggers for systemd (241-7~deb10u4) ...
Processing triggers for ca-certificates (20200601~deb10u1) ...
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...

done.
done.
```

Una vez descargado el paquete _tomcat9_, debemos, si no se ha hecho 
automáticamente, descargar las dependencias necesarias:

```
debian@ldapej:~$ sudo apt install libcairo2-dev libjpeg62-turbo-dev libpng-dev libossp-uuid-dev libtool
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  autoconf automake autotools-dev binutils binutils-common
  binutils-x86-64-linux-gnu cpp cpp-8 gcc gcc-8 libasan5 libatomic1
  libbinutils libblkid-dev libc-dev-bin libc6-dev libcairo-gobject2
  libcairo-script-interpreter2 libcairo2 libcc1-0 libdpkg-perl libexpat1-dev
  libffi-dev libfile-fcntllock-perl libfontconfig1-dev libfreetype6
  libfreetype6-dev libgcc-8-dev libglib2.0-bin libglib2.0-data libglib2.0-dev
  libglib2.0-dev-bin libgomp1 libice-dev libice6 libisl19 libitm1
  libjpeg62-turbo liblsan0 libltdl-dev libltdl7 liblzo2-2 libmount-dev libmpc3
  libmpx2 libossp-uuid16 libpcre16-3 libpcre3-dev libpcre32-3 libpcrecpp0v5
  libpixman-1-0 libpixman-1-dev libpng-tools libpthread-stubs0-dev
  libquadmath0 libselinux1-dev libsepol1-dev libsm-dev libsm6 libtsan0
  libubsan1 libx11-dev libxau-dev libxcb-render0 libxcb-render0-dev
  libxcb-shm0 libxcb-shm0-dev libxcb1-dev libxdmcp-dev libxext-dev
  libxrender-dev linux-libc-dev m4 manpages manpages-dev pkg-config
  python3-distutils python3-lib2to3 uuid-dev x11proto-core-dev x11proto-dev
  x11proto-xext-dev xorg-sgml-doctools xtrans-dev xz-utils zlib1g-dev
Suggested packages:
  autoconf-archive gnu-standards autoconf-doc gettext binutils-doc cpp-doc
  gcc-8-locales gcc-multilib make flex bison gdb gcc-doc gcc-8-multilib
  gcc-8-doc libgcc1-dbg libgomp1-dbg libitm1-dbg libatomic1-dbg libasan5-dbg
  liblsan0-dbg libtsan0-dbg libubsan1-dbg libmpx2-dbg libquadmath0-dbg
  glibc-doc libcairo2-doc debian-keyring gnupg | gnupg2 patch git bzr
  freetype2-doc libglib2.0-doc libgdk-pixbuf2.0-bin | libgdk-pixbuf2.0-dev
  libxml2-utils libice-doc libtool-doc uuid libsm-doc gfortran
  | fortran95-compiler gcj-jdk libx11-doc libxcb-doc libxext-doc m4-doc
  man-browser dpkg-dev
The following NEW packages will be installed:
  autoconf automake autotools-dev binutils binutils-common
  binutils-x86-64-linux-gnu cpp cpp-8 gcc gcc-8 libasan5 libatomic1
  libbinutils libblkid-dev libc-dev-bin libc6-dev libcairo-gobject2
  libcairo-script-interpreter2 libcairo2 libcairo2-dev libcc1-0 libdpkg-perl
  libexpat1-dev libffi-dev libfile-fcntllock-perl libfontconfig1-dev
  libfreetype6-dev libgcc-8-dev libglib2.0-bin libglib2.0-data libglib2.0-dev
  libglib2.0-dev-bin libgomp1 libice-dev libice6 libisl19 libitm1
  libjpeg62-turbo-dev liblsan0 libltdl-dev libltdl7 liblzo2-2 libmount-dev
  libmpc3 libmpx2 libossp-uuid-dev libossp-uuid16 libpcre16-3 libpcre3-dev
  libpcre32-3 libpcrecpp0v5 libpixman-1-0 libpixman-1-dev libpng-dev
  libpng-tools libpthread-stubs0-dev libquadmath0 libselinux1-dev
  libsepol1-dev libsm-dev libsm6 libtool libtsan0 libubsan1 libx11-dev
  libxau-dev libxcb-render0 libxcb-render0-dev libxcb-shm0 libxcb-shm0-dev
  libxcb1-dev libxdmcp-dev libxext-dev libxrender-dev linux-libc-dev m4
  manpages manpages-dev pkg-config python3-distutils python3-lib2to3 uuid-dev
  x11proto-core-dev x11proto-dev x11proto-xext-dev xorg-sgml-doctools
  xtrans-dev xz-utils zlib1g-dev
The following packages will be upgraded:
  libfreetype6 libjpeg62-turbo
2 upgraded, 89 newly installed, 0 to remove and 30 not upgraded.
Need to get 2,681 kB/52.9 MB of archives.
After this operation, 196 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
.
.
.
Processing triggers for libglib2.0-0:amd64 (2.58.3-2+deb10u2) ...
No schema files found: doing nothing.
Processing triggers for libc-bin (2.28-10) ...
Setting up libcairo2-dev:amd64 (1.16.0-4) ...
```

Estas dependencias son las obligatorias para que tomcat9 funcione, pero hay
otras tantas que son opcionales. En caso de querer descargarlas, serían:

> libavcodec-dev libavutil-dev libswscale-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev libfreerdp-dev

Ahora vamos a proceder con la instalación de Guacamole Server, y para ello,
vamos a descargar tanto el server como el cliente de la siguiente [página](https://guacamole.apache.org/releases/1.2.0/).
Nos descargamos el .war y lo pasaremos mediante scp hacia nuestra máquina en
el cloud.

```
root@ldapej:/home/debian# ls
gonzalonazareno.crt  guacamole-1.2.0.war
```

Ahora, añadiremos dicho archivo .war en el directorio _/var/lib/tomcat9/webapps_:

```
root@ldapej:/home/debian# cp guacamole-1.2.0.war /var/lib/tomcat9/webapps/
```

Ahora nos descargaremos el server (guacamole-server-1.2.0.tar.gz) de la misma
página e igualmente nos lo pasamos por scp a la máquina del cloud.

```
root@ldapej:/home/debian# ls
gonzalonazareno.crt  guacamole-1.2.0.war  guacamole-server-1.2.0.tar.gz
```

Lo descomprimimos y compilamos:

```
root@ldapej:/home/debian/guacamole-server-1.2.0# ./configure --with-init-dir=/etc/init.d
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... no
checking whether make supports nested variables... no
checking whether make supports nested variables... (cached) no
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking how to print strings... printf
checking for style of include used by make... none
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking whether gcc understands -c and -o together... yes
checking dependency style of gcc... none
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking how to convert x86_64-pc-linux-gnu file names to x86_64-pc-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-pc-linux-gnu file names to toolchain format... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for a working dd... /usr/bin/dd
checking how to truncate binary pipes... /usr/bin/dd bs=4096 count=1
checking for mt... mt
checking if mt is a manifest tool... no
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking for shl_load... no
checking for shl_load in -ldld... no
checking for dlopen... no
checking for dlopen in -ldl... yes
checking whether a program can dlopen itself... yes
checking whether a statically linked program can dlopen itself... no
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking whether gcc understands -c and -o together... (cached) yes
checking dependency style of gcc... (cached) none
checking for gcc option to accept ISO C99... none needed
checking fcntl.h usability... yes
checking fcntl.h presence... yes
checking for fcntl.h... yes
checking for stdlib.h... (cached) yes
checking for string.h... (cached) yes
checking sys/socket.h usability... yes
checking sys/socket.h presence... yes
checking for sys/socket.h... yes
checking time.h usability... yes
checking time.h presence... yes
checking for time.h... yes
checking sys/time.h usability... yes
checking sys/time.h presence... yes
checking for sys/time.h... yes
checking syslog.h usability... yes
checking syslog.h presence... yes
checking for syslog.h... yes
checking for unistd.h... (cached) yes
checking cairo/cairo.h usability... yes
checking cairo/cairo.h presence... yes
checking for cairo/cairo.h... yes
checking pngstruct.h usability... no
checking pngstruct.h presence... no
checking for pngstruct.h... no
checking for cos in -lm... yes
checking for png_write_png in -lpng... yes
checking for jpeg_start_compress in -ljpeg... yes
checking for cairo_create in -lcairo... yes
checking for pthread_create in -lpthread... yes
checking for dlopen in -ldl... (cached) yes
checking for uuid_make in -lossp-uuid... yes
checking ossp/uuid.h usability... yes
checking ossp/uuid.h presence... yes
checking for ossp/uuid.h... yes
checking whether uuid_make is declared... yes
checking for CU_run_test in -lcunit... no
checking for clock_gettime... yes
checking for gettimeofday... yes
checking for memmove... yes
checking for memset... yes
checking for select... yes
checking for strdup... yes
checking for nanosleep... yes
checking whether png_get_io_ptr is declared... yes
checking whether cairo_format_stride_for_width is declared... yes
checking whether poll is declared... yes
checking whether strlcpy is declared... no
checking whether strlcat is declared... no
checking for size_t... yes
checking for ssize_t... yes
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for AVCODEC... no
checking for AVFORMAT... no
checking for AVUTIL... no
checking for SWSCALE... no
checking openssl/ssl.h usability... no
checking openssl/ssl.h presence... no
checking for openssl/ssl.h... no
checking for SSL_CTX_new in -lssl... no
configure: WARNING:
  --------------------------------------------
   Unable to find libssl.
   guacd will not support SSL connections.
  --------------------------------------------
checking for main in -lwsock32... no
checking vorbis/vorbisenc.h usability... no
checking vorbis/vorbisenc.h presence... no
checking for vorbis/vorbisenc.h... no
checking for ogg_stream_init in -logg... no
checking for vorbis_block_init in -lvorbis... no
checking for vorbis_encode_init in -lvorbisenc... no
configure: WARNING:
  --------------------------------------------
   Unable to find libogg / libvorbis / libvorbisenc.
   Sound will not be encoded with Ogg Vorbis.
  --------------------------------------------
checking for pa_context_new in -lpulse... no
configure: WARNING:
  --------------------------------------------
   Unable to find libpulse
   Sound support for VNC will be disabled
  --------------------------------------------
checking for PANGO... no
checking for PANGOCAIRO... no
checking for rfbInitClient in -lvncclient... no
checking for RDP... no
configure: WARNING:
  --------------------------------------------
   Unable to find FreeRDP (libfreerdp2 / libfreerdp-client2 / libwinpr2)
   RDP will be disabled.
  --------------------------------------------
checking for libssh2_session_init_ex in -lssh2... no
checking for telnet_init in -ltelnet... no
checking webp/encode.h usability... no
checking webp/encode.h presence... no
checking for webp/encode.h... no
checking for WebPEncode in -lwebp... no
configure: WARNING:
  --------------------------------------------
   Unable to find libwebp.
   Images will not be encoded using WebP.
  --------------------------------------------
checking for lws_create_context in -lwebsockets... no
configure: WARNING:
  --------------------------------------------
   Unable to find libwebsockets.
   Support for Kubernetes will be disabled.
  --------------------------------------------
checking whether LWS_CALLBACK_CLIENT_CLOSED is declared... no
checking whether LWS_SERVER_OPTION_DO_SSL_GLOBAL_INIT is declared... no
checking whether LCCSCF_USE_SSL is declared... no
checking whether lws_callback_http_dummy is declared... no
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating Makefile
config.status: creating doc/Doxyfile
config.status: creating src/common/Makefile
config.status: creating src/common/tests/Makefile
config.status: creating src/common-ssh/Makefile
config.status: creating src/common-ssh/tests/Makefile
config.status: creating src/terminal/Makefile
config.status: creating src/libguac/Makefile
config.status: creating src/libguac/tests/Makefile
config.status: creating src/guacd/Makefile
config.status: creating src/guacd/man/guacd.8
config.status: creating src/guacd/man/guacd.conf.5
config.status: creating src/guacenc/Makefile
config.status: creating src/guacenc/man/guacenc.1
config.status: creating src/guaclog/Makefile
config.status: creating src/guaclog/man/guaclog.1
config.status: creating src/pulse/Makefile
config.status: creating src/protocols/kubernetes/Makefile
config.status: creating src/protocols/rdp/Makefile
config.status: creating src/protocols/rdp/tests/Makefile
config.status: creating src/protocols/ssh/Makefile
config.status: creating src/protocols/telnet/Makefile
config.status: creating src/protocols/vnc/Makefile
config.status: creating config.h
config.status: executing depfiles commands
config.status: executing libtool commands

------------------------------------------------
guacamole-server version 1.2.0
------------------------------------------------

   Library status:

     freerdp2 ............ no
     pango ............... no
     libavcodec .......... no
     libavformat.......... no
     libavutil ........... no
     libssh2 ............. no
     libssl .............. no
     libswscale .......... no
     libtelnet ........... no
     libVNCServer ........ no
     libvorbis ........... no
     libpulse ............ no
     libwebsockets ....... no
     libwebp ............. no
     wsock32 ............. no

   Protocol support:

      Kubernetes .... no
      RDP ........... no
      SSH ........... no
      Telnet ........ no
      VNC ........... no

   Services / tools:

      guacd ...... yes
      guacenc .... no
      guaclog .... yes

   FreeRDP plugins: no
   Init scripts: /etc/init.d
   Systemd units: no

Type "make" to compile guacamole-server.
```

Y ahora lo instalamos:

```
root@ldapej:/home/debian/guacamole-server-1.2.0# make
make  all-recursive
make[1]: Entering directory '/home/debian/guacamole-server-1.2.0'
Making all in src/libguac
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/libguac'
Making all in .
make[3]: Entering directory '/home/debian/guacamole-server-1.2.0/src/libguac'
  CC       libguac_la-audio.lo
  CC       libguac_la-client.lo
  CC       libguac_la-encode-jpeg.lo
  CC       libguac_la-encode-png.lo
  CC       libguac_la-error.lo
  CC       libguac_la-hash.lo
  CC       libguac_la-id.lo
  CC       libguac_la-palette.lo
  CC       libguac_la-parser.lo
  CC       libguac_la-pool.lo
  CC       libguac_la-protocol.lo
  CC       libguac_la-raw_encoder.lo
  CC       libguac_la-socket.lo
  CC       libguac_la-socket-broadcast.lo
  CC       libguac_la-socket-fd.lo
  CC       libguac_la-socket-nest.lo
  CC       libguac_la-socket-tee.lo
  CC       libguac_la-string.lo
  CC       libguac_la-timestamp.lo
  CC       libguac_la-unicode.lo
  CC       libguac_la-user.lo
  CC       libguac_la-user-handlers.lo
  CC       libguac_la-user-handshake.lo
  CC       libguac_la-wait-fd.lo
  CC       libguac_la-wol.lo
  CCLD     libguac.la
ar: `u' modifier ignored since `D' is the default (see `U')
make[3]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/libguac'
Making all in tests
make[3]: Entering directory '/home/debian/guacamole-server-1.2.0/src/libguac/tests'
make[3]: Nothing to be done for 'all'.
make[3]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/libguac/tests'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/libguac'
Making all in src/common
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/common'
Making all in .
make[3]: Entering directory '/home/debian/guacamole-server-1.2.0/src/common'
  CC       libguac_common_la-io.lo
  CC       libguac_common_la-blank_cursor.lo
  CC       libguac_common_la-clipboard.lo
  CC       libguac_common_la-cursor.lo
  CC       libguac_common_la-display.lo
  CC       libguac_common_la-dot_cursor.lo
  CC       libguac_common_la-ibar_cursor.lo
  CC       libguac_common_la-iconv.lo
  CC       libguac_common_la-json.lo
  CC       libguac_common_la-list.lo
  CC       libguac_common_la-pointer_cursor.lo
  CC       libguac_common_la-recording.lo
  CC       libguac_common_la-rect.lo
  CC       libguac_common_la-string.lo
  CC       libguac_common_la-surface.lo
  CCLD     libguac_common.la
ar: `u' modifier ignored since `D' is the default (see `U')
make[3]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/common'
Making all in tests
make[3]: Entering directory '/home/debian/guacamole-server-1.2.0/src/common/tests'
make[3]: Nothing to be done for 'all'.
make[3]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/common/tests'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/common'
Making all in src/guacd
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/guacd'
  CC       guacd-conf-args.o
  CC       guacd-conf-file.o
  CC       guacd-conf-parse.o
  CC       guacd-connection.o
  CC       guacd-daemon.o
  CC       guacd-log.o
  CC       guacd-move-fd.o
  CC       guacd-proc.o
  CC       guacd-proc-map.o
  CCLD     guacd
sed -e 's,[@]sbindir[@],/usr/local/sbin,g' < init.d/guacd.in > init.d/guacd
chmod +x init.d/guacd
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/guacd'
Making all in src/guaclog
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/guaclog'
  CC       guaclog-guaclog.o
  CC       guaclog-instructions.o
  CC       guaclog-instruction-key.o
  CC       guaclog-interpret.o
  CC       guaclog-keydef.o
  CC       guaclog-log.o
  CC       guaclog-state.o
  CCLD     guaclog
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/guaclog'
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0'
make[1]: Leaving directory '/home/debian/guacamole-server-1.2.0'


root@ldapej:/home/debian/guacamole-server-1.2.0# make install
Making install in src/libguac
make[1]: Entering directory '/home/debian/guacamole-server-1.2.0/src/libguac'
Making install in .
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/libguac'
make[3]: Entering directory '/home/debian/guacamole-server-1.2.0/src/libguac'
 /usr/bin/mkdir -p '/usr/local/lib'
 /bin/bash ../../libtool   --mode=install /usr/bin/install -c   libguac.la '/usr/local/lib'
libtool: install: /usr/bin/install -c .libs/libguac.so.17.1.0 /usr/local/lib/libguac.so.17.1.0
libtool: install: (cd /usr/local/lib && { ln -s -f libguac.so.17.1.0 libguac.so.17 || { rm -f libguac.so.17 && ln -s libguac.so.17.1.0 libguac.so.17; }; })
libtool: install: (cd /usr/local/lib && { ln -s -f libguac.so.17.1.0 libguac.so || { rm -f libguac.so && ln -s libguac.so.17.1.0 libguac.so; }; })
libtool: install: /usr/bin/install -c .libs/libguac.lai /usr/local/lib/libguac.la
libtool: install: /usr/bin/install -c .libs/libguac.a /usr/local/lib/libguac.a
libtool: install: chmod 644 /usr/local/lib/libguac.a
libtool: install: ranlib /usr/local/lib/libguac.a
libtool: finish: PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin" ldconfig -n /usr/local/lib
----------------------------------------------------------------------
Libraries have been installed in:
   /usr/local/lib

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the '-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the 'LD_RUN_PATH' environment variable
     during linking
   - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to '/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
 /usr/bin/mkdir -p '/usr/local/include/guacamole'
 /usr/bin/install -c -m 644 guacamole/audio.h guacamole/audio-fntypes.h guacamole/audio-types.h guacamole/client-constants.h guacamole/client.h guacamole/client-fntypes.h guacamole/client-types.h guacamole/error.h guacamole/error-types.h guacamole/hash.h guacamole/layer.h guacamole/layer-types.h guacamole/object.h guacamole/object-types.h guacamole/parser-constants.h guacamole/parser.h guacamole/parser-types.h guacamole/plugin-constants.h guacamole/plugin.h guacamole/pool.h guacamole/pool-types.h guacamole/protocol.h guacamole/protocol-constants.h guacamole/protocol-types.h guacamole/socket-constants.h guacamole/socket.h guacamole/socket-fntypes.h guacamole/socket-types.h guacamole/stream.h guacamole/stream-types.h guacamole/string.h guacamole/timestamp.h guacamole/timestamp-types.h guacamole/unicode.h guacamole/user.h guacamole/user-constants.h guacamole/user-fntypes.h guacamole/user-types.h guacamole/wol.h guacamole/wol-constants.h '/usr/local/include/guacamole'
make[3]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/libguac'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/libguac'
Making install in tests
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/libguac/tests'
make[3]: Entering directory '/home/debian/guacamole-server-1.2.0/src/libguac/tests'
make[3]: Nothing to be done for 'install-exec-am'.
make[3]: Nothing to be done for 'install-data-am'.
make[3]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/libguac/tests'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/libguac/tests'
make[1]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/libguac'
Making install in src/common
make[1]: Entering directory '/home/debian/guacamole-server-1.2.0/src/common'
Making install in .
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/common'
make[3]: Entering directory '/home/debian/guacamole-server-1.2.0/src/common'
make[3]: Nothing to be done for 'install-exec-am'.
make[3]: Nothing to be done for 'install-data-am'.
make[3]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/common'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/common'
Making install in tests
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/common/tests'
make[3]: Entering directory '/home/debian/guacamole-server-1.2.0/src/common/tests'
make[3]: Nothing to be done for 'install-exec-am'.
make[3]: Nothing to be done for 'install-data-am'.
make[3]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/common/tests'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/common/tests'
make[1]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/common'
Making install in src/guacd
make[1]: Entering directory '/home/debian/guacamole-server-1.2.0/src/guacd'
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/guacd'
 /usr/bin/mkdir -p '/usr/local/sbin'
  /bin/bash ../../libtool   --mode=install /usr/bin/install -c guacd '/usr/local/sbin'
libtool: install: /usr/bin/install -c .libs/guacd /usr/local/sbin/guacd
 /usr/bin/mkdir -p '/etc/init.d'
 /usr/bin/install -c init.d/guacd '/etc/init.d'
 /usr/bin/mkdir -p '/usr/local/share/man/man5'
 /usr/bin/install -c -m 644 man/guacd.conf.5 '/usr/local/share/man/man5'
 /usr/bin/mkdir -p '/usr/local/share/man/man8'
 /usr/bin/install -c -m 644 man/guacd.8 '/usr/local/share/man/man8'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/guacd'
make[1]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/guacd'
Making install in src/guaclog
make[1]: Entering directory '/home/debian/guacamole-server-1.2.0/src/guaclog'
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0/src/guaclog'
 /usr/bin/mkdir -p '/usr/local/bin'
  /bin/bash ../../libtool   --mode=install /usr/bin/install -c guaclog '/usr/local/bin'
libtool: install: /usr/bin/install -c .libs/guaclog /usr/local/bin/guaclog
 /usr/bin/mkdir -p '/usr/local/share/man/man1'
 /usr/bin/install -c -m 644 man/guaclog.1 '/usr/local/share/man/man1'
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/guaclog'
make[1]: Leaving directory '/home/debian/guacamole-server-1.2.0/src/guaclog'
make[1]: Entering directory '/home/debian/guacamole-server-1.2.0'
make[2]: Entering directory '/home/debian/guacamole-server-1.2.0'
make[2]: Nothing to be done for 'install-exec-am'.
make[2]: Nothing to be done for 'install-data-am'.
make[2]: Leaving directory '/home/debian/guacamole-server-1.2.0'
make[1]: Leaving directory '/home/debian/guacamole-server-1.2.0'


root@ldapej:/home/debian/guacamole-server-1.2.0# ldconfig
```

En principio, ya tendríamos instalado Apache Guacamole.

Ahora pasaremos a la configuración de Guacamole Server.

En primer lugar, crearemos dos directorios:

```
root@ldapej:/etc# mkdir /etc/guacamole /usr/share/tomcat9/.guacamole
```















* ¿Has necesitado instalar alguna librería?¿Has necesitado instalar un 
conector de una base de datos?
   
* Entrega una captura de pantalla donde se vea la aplicación funcionando.
   
* Realiza la configuración necesaria en apache2 y tomcat (utilizando el 
protocolo AJP) para que la aplicación sea servida por el servidor web.
   
* Entrega una captura de pantalla donde se vea la aplicación funcionando 
servida por apache2.


