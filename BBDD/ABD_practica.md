<div align="center">

# Instalación de Servidores y Clientes

</div>

Tras la instalación de cada servidor,  debe crearse una base de datos con al 
menos tres tablas o colecciones y poblarse de datos adecuadamente. Debe crearse 
un usuario y dotarlo de los privilegios necesarios para acceder remotamente a 
los datos. Se proporcionará esta información al resto de los miembros del grupo.
Los clientes deben estar siempre en máquinas diferentes de los respectivos 
servidores a los que acceden.

* Instalación de un servidor Postgres y configuración para permitir el acceso
remoto desde la red local.

Primero, procederemos a instalarnos en Debian 10 el servidor Postgres mediante
la descarga del paquete llamado _postgresql-11_:

```
manuel@debian:~$ sudo apt-get install postgresql-11
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias       
Leyendo la información de estado... Hecho
Los paquetes indicados a continuación se instalaron de forma automática y ya no son necesarios.
  ffmpeg gnome-session-canberra libavdevice58 libdc1394-utils libqt5test5
  libsdl2-2.0-0
Utilice «sudo apt autoremove» para eliminarlos.
Se instalarán los siguientes paquetes adicionales:
  libpq5 postgresql-client-11 postgresql-client-common postgresql-common
  sysstat
Paquetes sugeridos:
  postgresql-doc-11 libjson-perl isag
Se instalarán los siguientes paquetes NUEVOS:
  libpq5 postgresql-11 postgresql-client-11 postgresql-client-common
  postgresql-common sysstat
0 actualizados, 6 nuevos se instalarán, 0 para eliminar y 41 no actualizados.
Se necesita descargar 16,5 MB de archivos.
Se utilizarán 55,4 MB de espacio de disco adicional después de esta operación.
¿Desea continuar? [S/n] S
Des:1 http://deb.debian.org/debian buster/main amd64 libpq5 amd64 11.9-0+deb10u1 [167 kB]
.
.
.
Completado. Ahora puede iniciar el servidor de bases de datos usando:

    pg_ctlcluster 11 main start

Ver Cluster Port Status Owner    Data directory              Log file
11  main    5432 down   postgres /var/lib/postgresql/11/main /var/log/postgresql/postgresql-11-main.log
update-alternatives: utilizando /usr/share/postgresql/11/man/man1/postmaster.1.gz para proveer /usr/share/man/man1/postmaster.1.gz (postmaster.1.gz) en modo automático
Configurando sysstat (12.0.3-2) ...

Creating config file /etc/default/sysstat with new version
update-alternatives: utilizando /usr/bin/sar.sysstat para proveer /usr/bin/sar (sar) en modo automático
Created symlink /etc/systemd/system/multi-user.target.wants/sysstat.service → /lib/systemd/system/sysstat.service.
Procesando disparadores para systemd (241-7~deb10u4) ...
Procesando disparadores para man-db (2.8.5-2) ...
Procesando disparadores para libc-bin (2.28-10) ...
```

Cuando descargamos el paquete, la base de datos de Postgres debería
inicializarse. Para comprobar si efectivamente lo está, ejecutamos uno de los
dos comandos:

```
manuel@debian:~$ pg_isready
/var/run/postgresql:5432 - aceptando conexiones

manuel@debian:~$ sudo systemctl status postgresql
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enab
   Active: active (exited) since Tue 2020-12-01 08:38:38 CET; 4min 3s ago
 Main PID: 5311 (code=exited, status=0/SUCCESS)
    Tasks: 0 (limit: 4915)
   Memory: 0B
   CGroup: /system.slice/postgresql.service

dic 01 08:38:38 debian systemd[1]: Starting PostgreSQL RDBMS...
dic 01 08:38:38 debian systemd[1]: Started PostgreSQL RDBMS.
```

Una vez ya instalado el servidor y comprobado que funciona, vamos a hacer lo
siguiente. Como al instalarse el servidor se nos crea automáticamente un
nuevo usuario llamado "postgres", vamos a cambiar la contraseña:

```
manuel@debian:~$ sudo passwd postgres
Nueva contraseña: 
Vuelva a escribir la nueva contraseña: 
passwd: contraseña actualizada correctamente
manuel@debian:~$ sudo su postgres
postgres@debian:/home/manuel$ exit
exit
```

A continuación, crearemos un nuevo usuario para el gestor con:

``` 
postgres@debian:/home/manuel$ createuser -s manuel -P 
Ingrese la contraseña para el nuevo rol: 
Ingrésela nuevamente: 
```

Con la opción -s le asignamos permisos de superusuario.

Ahora vamos a proceder a crear propiamente la base de datos. Para ello vamos a
ejecutar:

```
manuel@debian:~$ createdb bbddprueba
manuel@debian:~$ psql bbddprueba 
psql (11.9 (Debian 11.9-0+deb10u1))
Digite «help» para obtener ayuda.

bbddprueba=# 
```

Como nos pide el ejercicio, crearemos varias tablas y las poblaremos de datos.

```
bbddprueba=# create table temporadas
bbddprueba-# (
bbddprueba(#  codigo   varchar(9),
bbddprueba(#  Nombre   varchar(35),
bbddprueba(#  constraint pk_temporadas primary key (codigo)
bbddprueba(# );
CREATE TABLE

bbddprueba=# insert into temporadas
bbddprueba-# values ('01','Baja');
INSERT 0 1
bbddprueba=# insert into temporadas
bbddprueba-# values ('02','Alta');
INSERT 0 1
bbddprueba=# insert into temporadas
bbddprueba-# values ('03','Especial');
INSERT 0 1


bbddprueba=# create table regimenes
bbddprueba-# (
bbddprueba(#  codigo   varchar(9),
bbddprueba(#  Nombre   varchar(35),
bbddprueba(#  constraint pk_regimenes primary key (codigo),
bbddprueba(#  constraint contenido_codigo check( codigo in ('AD','MP','PC','TI'))
bbddprueba(# );
CREATE TABLE

bbddprueba=# insert into regimenes
bbddprueba-# values ('AD','Alojamiento y Desayuno');
INSERT 0 1
bbddprueba=# insert into regimenes
bbddprueba-# values ('MP','Media pension');
INSERT 0 1
bbddprueba=# insert into regimenes
bbddprueba-# values ('PC','Pension completa');
INSERT 0 1
bbddprueba=# insert into regimenes
bbddprueba-# values ('TI','Todo incluido');


bbddprueba=# create table tipos_de_habitacion
bbddprueba-# (
bbddprueba(#  codigo   varchar(9),
bbddprueba(#  nombre   varchar(35),
bbddprueba(#  constraint pk_tipohabit primary key (codigo)
bbddprueba(# );
CREATE TABLE

bbddprueba=# insert into tipos_de_habitacion
bbddprueba-# values ('01','Habitacion individual');
INSERT 0 1
bbddprueba=# insert into tipos_de_habitacion
bbddprueba-# values ('02','Habitacion doble');
INSERT 0 1
bbddprueba=# insert into tipos_de_habitacion
bbddprueba-# values ('03','Habitacion triple');
INSERT 0 1


bbddprueba=# create table habitaciones
bbddprueba-# (
bbddprueba(#  numero   varchar(4),
bbddprueba(#  codigotipo  varchar(9),
bbddprueba(#  constraint pk_habitaciones primary key (numero),
bbddprueba(#  constraint fk_habitaciones foreign key (codigotipo) references tipos_de_habitacion(codigo)
bbddprueba(# );
CREATE TABLE

bbddprueba=# insert into habitaciones
bbddprueba-# values ('00','01');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('01','02');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('02','03');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('03','01');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('04','02');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('05','02');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('06','02');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('07','02');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('08','03');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('09','02');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('10','01');
INSERT 0 1
bbddprueba=# insert into habitaciones
bbddprueba-# values ('11','03');
INSERT 0 1
```

Y por último, nos quedaría conectarnos mediante un usuario remoto desde nuestra 
red local. Para que esto sea posible, primero es necesario modificar algunos
ficheros de configuración. 

En primer lugar, nos iremos al directorio _/etc/postgresql/11/main_ y 
modificamos el fichero _postgresql.conf_. Descomentamos la siguiente línea, y
como queremos que sea de nuestra red local, pondremos lo siguiente:

```
listen_addresses = '*'
```

Esto nos permitirá aceptar solo peticiones de dichas redes (la del instituto y
la personal)

Ahora, modificaremos el fichero de configuración de clientes, que se llama
_/etc/postgresql/11/main/pg_hba.conf_ y cambiamos la siguiente información:

```
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
host    all             all             172.22.0.0/24           md5
host    all             all             149.59.196.0/32         md5
host    bbddprueba	all		149.59.196.92/32	md5
```

Una vez ya configurado, reiniciamos el servicio de Postgresql.

Ahora para comprobar que efectivamente nos podemos conectar mediante un usuario
a nuestro servidor, nos meteremos en una máquina cuya IP es 172.22.200.190
(IP permitida) y nos descargaremos el paquete ```postgresql-cliente-11```.

Una vez descargado, comprobamos la conexión:

```

```
