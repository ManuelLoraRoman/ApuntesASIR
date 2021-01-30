# Interconexión de Servidores de Bases de Datos

Las interconexiones de servidores de bases de datos son operaciones que pueden 
ser muy útiles en diferentes contextos. Básicamente, se trata de acceder a datos
que no están almacenados en nuestra base de datos, pudiendo combinarlos con 
los que ya tenemos.

En esta práctica veremos varias formas de crear un enlace entre distintos 
servidores de bases de datos.

Esta práctica se realizará de forma individual.

Los servidores enlazados siempre tendrán que estar instalados en máquinas 
diferentes.

Se pide:

* Realizar un enlace entre dos servidores de bases de datos ORACLE, explicando 
la configuración necesaria en ambos extremos y demostrando su funcionamiento.


En primer lugar, disponemos de un Servidor Oracle en CentOS 8 con
ip 192.168.0.38/24 y otro en Windows 10 con ip 192.168.0.159/24.

En la máquina Windows, vamos a crear un usuario llamado interconexion
el cual va a tener los privilegios que deseemos, y el cual será con el
que nos conectemos al otro servidor.


```
SQL> CREATE USER interconexion
  2  IDENTIFIED BY interconexion;

Usuario creado.

SQL> GRANT CONNECT, RESOURCE, DBA TO interconexion

Concesion terminada correctamente.
```

Hecho ya el usuario, debemos modificar el fichero listerner.ora en este servidor
Windows. En nuestro caso, el directorio se encuentra en 
_C:\WINDOWS.X64_193000_db_home\network\admin\listener.ora_:


```
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = CLRExtProc)
      (ORACLE_HOME = C:\WINDOWS.X64_193000_db_home)
      (PROGRAM = extproc)
      (ENVS = "EXTPROC_DLLS=ONLY:C:\WINDOWS.X64_193000_db_home\bin\oraclr19.dll")
    )
  )LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.0.38)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )
```

Lo único que se ha cambiado ha sido el parámetro HOST del protocolo TCP, el
cuál se ha cambiado su valor de localhost a la ip del otro servidor.

Procedemos a continuación a modificar también el fichero tnsnames.ora en 
la misma máquina y añadimos la siguiente información (el directorio es
el mismo que para el listener.ora):

```
LISTENER_ORCL =
  (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))ORACLR_CONNECTION_DATA =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
    (CONNECT_DATA =
      (SID = CLRExtProc)
      (PRESENTATION = RO)
    )
  )ORCL =
  (DESCRIPTION = Servidor CentOS
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.0.38)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = orcl)
    )
  )
```

Ahora procedemos a modificar el fichero encontrado en el directorio
_/u01/app/oracle/product/19.3.0/dbhome_1/network/admin/listener.ora_:

```
LISTENER =
 (DESCRIPTION_LIST =
	(DESCRIPTION =
		(ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.0.159)(PORT = 1521))
		(ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
	)
 )
```

A continuación, debemos detener el servicio de listener en ambas máquinas
y reiniciarlo. Caundo lo hagamos nos debe aparecer el siguiente mensaje:

```
El servicio "orcl" tiene 1 instancia(s).
  La instancia "orcl", con estado UNKNOWN, tiene 1 manejador(es) para este servicio...
```

Hecho esto pasamos a la creación del enlace en la base de datos de la
máquina Windows;

```
SQL> CREATE DATABASE LINK Interconexion
  2  CONNECT TO interconexion
  3  IDENTIFIED BY interconexion
  4  USING 'orcl';

Enlace con la base de datos creado.
```

Ahora creamos alguna tabla en el Servidor Windows junto con algunos registros.
Comprobamos que la conexión es correcta:

```
SQL> SELECT * FROM TEMPORADAS@Interconexion;

CODIGO	  NOMBRE
--------- -----------------------------------
01	  Baja
02	  Alta
03	  Especial
```


* Realizar un enlace entre dos servidores de bases de datos Postgres, explicando
la configuración necesaria en ambos extremos y demostrando su funcionamiento.

Creamos una máquina Debian 10 y vamos en primera instancia a instalar 
PostgreSQL:

```
root@debian:~# apt-get install postgresql
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias       
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes adicionales:
  libpq5 postgresql-11 postgresql-client-11 postgresql-client-common
  postgresql-common sysstat
Paquetes sugeridos:
  postgresql-doc postgresql-doc-11 libjson-perl isag
Se instalarán los siguientes paquetes NUEVOS:
  libpq5 postgresql postgresql-11 postgresql-client-11
  postgresql-client-common postgresql-common sysstat
0 actualizados, 7 nuevos se instalarán, 0 para eliminar y 15 no actualizados.
Se necesita descargar 16,6 MB de archivos.
Se utilizarán 55,5 MB de espacio de disco adicional después de esta operación.
¿Desea continuar? [S/n] S
Des:1 http://deb.debian.org/debian buster/main amd64 libpq5 amd64 11.9-0+deb10u1 [167 kB]
Des:2 http://deb.debian.org/debian buster/main amd64 postgresql-client-common all 200+deb10u4 [85,1 kB]
Des:3 http://deb.debian.org/debian buster/main amd64 postgresql-client-11 amd64 11.9-0+deb10u1 [1.401 kB]
Des:4 http://deb.debian.org/debian buster/main amd64 postgresql-common all 200+deb10u4 [225 kB]
Des:5 http://deb.debian.org/debian buster/main amd64 postgresql-11 amd64 11.9-0+deb10u1 [14,1 MB]
Des:6 http://deb.debian.org/debian buster/main amd64 postgresql all 11+200+deb10u4 [61,1 kB]
Des:7 http://deb.debian.org/debian buster/main amd64 sysstat amd64 12.0.3-2 [562 kB]
Descargados 16,6 MB en 8s (2.129 kB/s)                                         
Preconfigurando paquetes ...
Seleccionando el paquete libpq5:amd64 previamente no seleccionado.
(Leyendo la base de datos ... 184385 ficheros o directorios instalados actualmente.)
Preparando para desempaquetar .../0-libpq5_11.9-0+deb10u1_amd64.deb ...
Desempaquetando libpq5:amd64 (11.9-0+deb10u1) ...
Seleccionando el paquete postgresql-client-common previamente no seleccionado.
Preparando para desempaquetar .../1-postgresql-client-common_200+deb10u4_all.deb ...
Desempaquetando postgresql-client-common (200+deb10u4) ...
Seleccionando el paquete postgresql-client-11 previamente no seleccionado.
Preparando para desempaquetar .../2-postgresql-client-11_11.9-0+deb10u1_amd64.deb ...
Desempaquetando postgresql-client-11 (11.9-0+deb10u1) ...
Seleccionando el paquete postgresql-common previamente no seleccionado.
Preparando para desempaquetar .../3-postgresql-common_200+deb10u4_all.deb ...
Añadiendo `desviación de /usr/bin/pg_config a /usr/bin/pg_config.libpq-dev por postgresql-common'
Desempaquetando postgresql-common (200+deb10u4) ...
Seleccionando el paquete postgresql-11 previamente no seleccionado.
Preparando para desempaquetar .../4-postgresql-11_11.9-0+deb10u1_amd64.deb ...
Desempaquetando postgresql-11 (11.9-0+deb10u1) ...
Seleccionando el paquete postgresql previamente no seleccionado.
Preparando para desempaquetar .../5-postgresql_11+200+deb10u4_all.deb ...
Desempaquetando postgresql (11+200+deb10u4) ...
Seleccionando el paquete sysstat previamente no seleccionado.
Preparando para desempaquetar .../6-sysstat_12.0.3-2_amd64.deb ...
Desempaquetando sysstat (12.0.3-2) ...
Configurando postgresql-client-common (200+deb10u4) ...
Configurando libpq5:amd64 (11.9-0+deb10u1) ...
Configurando postgresql-client-11 (11.9-0+deb10u1) ...
update-alternatives: utilizando /usr/share/postgresql/11/man/man1/psql.1.gz para proveer /usr/share/man/man1/psql.1.gz (psql.1.gz) en modo automático
Configurando postgresql-common (200+deb10u4) ...
Añadiendo al usuario postgres al grupo ssl-cert

Creating config file /etc/postgresql-common/createcluster.conf with new version
Building PostgreSQL dictionaries from installed myspell/hunspell packages...
  en_us
  es
Removing obsolete dictionary files:
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /lib/systemd/system/postgresql.service.
Configurando postgresql-11 (11.9-0+deb10u1) ...
Creating new PostgreSQL cluster 11/main ...
/usr/lib/postgresql/11/bin/initdb -D /var/lib/postgresql/11/main --auth-local peer --auth-host md5
Los archivos de este cluster serán de propiedad del usuario «postgres».
Este usuario también debe ser quien ejecute el proceso servidor.

El cluster será inicializado con configuración regional «es_ES.UTF-8».
La codificación por omisión ha sido por lo tanto definida a «UTF8».
La configuración de búsqueda en texto ha sido definida a «spanish».

Las sumas de verificación en páginas de datos han sido desactivadas.

corrigiendo permisos en el directorio existente /var/lib/postgresql/11/main ... hecho
creando subdirectorios ... hecho
seleccionando el valor para max_connections ... 100
seleccionando el valor para shared_buffers ... 128MB
seleccionando el huso horario por omisión ... Europe/Madrid
seleccionando implementación de memoria compartida dinámica ...posix
creando archivos de configuración ... hecho
ejecutando script de inicio (bootstrap) ... hecho
realizando inicialización post-bootstrap ... hecho
sincronizando los datos a disco ... hecho

Completado. Ahora puede iniciar el servidor de bases de datos usando:

    pg_ctlcluster 11 main start

Ver Cluster Port Status Owner    Data directory              Log file
11  main    5432 down   postgres /var/lib/postgresql/11/main /var/log/postgresql/postgresql-11-main.log
update-alternatives: utilizando /usr/share/postgresql/11/man/man1/postmaster.1.gz para proveer /usr/share/man/man1/postmaster.1.gz (postmaster.1.gz) en modo automático
Configurando postgresql (11+200+deb10u4) ...
Configurando sysstat (12.0.3-2) ...

Creating config file /etc/default/sysstat with new version
update-alternatives: utilizando /usr/bin/sar.sysstat para proveer /usr/bin/sar (sar) en modo automático
Created symlink /etc/systemd/system/multi-user.target.wants/sysstat.service → /lib/systemd/system/sysstat.service.
Procesando disparadores para systemd (241-7~deb10u5) ...
Procesando disparadores para man-db (2.8.5-2) ...
Procesando disparadores para libc-bin (2.28-10) ...
root@debian:~# 
```

Instalado en esa máquina, vamos a proceder también a hacerlo en la otra:
Hecho con las dos, podemos en primer lugar, dirigirnos al directorio
_/etc/postgresql/11/main/_ y editar el fichero _postgresql.conf_:

```
listen_addresses = '*'    
```

Debemos cambiar el valor por defecto localhost por * en ambas máquinas.
A continuación, vamos a modificar el fichero _pg_hba.conf_ y vamos a 
añadirle la siguiente línea (ambas máquinas):

```
host    all             all             0.0.0.0/0               md5
```

Cambiado ambos ficheros, reiniciamos el servicio de postgresql:

```
systemctl restart postgresql
```

Ahora vamos a proceder con cada máquina por separado. Primero vamos a la
primera máquina y vamos a iniciar sesión con el usuario postgres y vamos
a crear un usuario, una base de datos y asignamos privilegios correspondientes
al usuario creado:

```
root@debian:~# su postgres
postgres@debian:/root$ psql
could not change directory to "/root": Permiso denegado
psql (11.9 (Debian 11.9-0+deb10u1))
Type "help" for help.

postgres=# create user usuario1 with password 'usuario';
CREATE ROLE
postgres=# create database prueba1;
CREATE DATABASE
postgres=# GRANT ALL PRIVILEGES ON DATABASE prueba1 TO usuario1;
GRANT
```

Ahora nos conectaremos con ese usuario y crearemos una tabla de prueba con
algunos registros:

```
postgres@debian:/root$ psql -h localhost -U usuario1 -W -d prueba1
could not change directory to "/root": Permiso denegado
Password: 
psql (11.9 (Debian 11.9-0+deb10u1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

prueba1=> create table temporadas
prueba1-> 
prueba1-> (
prueba1(> 
prueba1(> codigo   varchar(9),
prueba1(> 
prueba1(> Nombre   varchar(35),
prueba1(> 
prueba1(> constraint pk_temporadas primary key (codigo)
prueba1(> 
prueba1(> );
CREATE TABLE
prueba1=> insert into temporadas
prueba1-> 
prueba1-> values ('01','Baja');
INSERT 0 1
prueba1=> insert into temporadas
values ('02','Alta');
INSERT 0 1
prueba1=> insert into temporadas
values ('03','Especial');
INSERT 0 1
prueba1=> 
```

Ahora pasamos a la configuración en la otra máquina. Como hemos hecho 
anteriormente, vamos a iniciar sesión con el usuario postgres, y vamos a
proceder a la creación de usuario, base de datos y privilegios:

```
root@postgrescliente:~# su postgres
postgres@postgrescliente:/root$ psql
could not change directory to "/root": Permiso denegado
psql (11.9 (Debian 11.9-0+deb10u1))
Type "help" for help.

postgres=# create user usuario2 with password 'usuario';
CREATE ROLE
postgres=# create database prueba2;
CREATE DATABASE
postgres=# grant all privileges on database prueba2 to usuario2;
GRANT
```

Y volvemos a iniciar sesión con el usuario recientemente creado para crear
una tabla e insertar algunos registros:

```
postgres@postgrescliente:/root$ psql -h localhost -U usuario2 -W -d prueba2
could not change directory to "/root": Permiso denegado
Password: 
psql (11.9 (Debian 11.9-0+deb10u1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

prueba2=> create table regimenes
prueba2-> 
prueba2-> (
prueba2(> 
prueba2(> codigo   varchar(9),
prueba2(> 
prueba2(> Nombre   varchar(35),
prueba2(> 
prueba2(> constraint pk_regimenes primary key (codigo),
prueba2(> 
prueba2(> constraint contenido_codigo check( codigo in ('AD','MP','PC','TI'))
prueba2(> 
prueba2(> );
CREATE TABLE
prueba2=> insert into regimenes
prueba2-> 
prueba2-> values ('AD','Alojamiento y Desayuno');
INSERT 0 1
prueba2=> 
prueba2=> insert into regimenes
prueba2-> 
prueba2-> values ('MP','Media pension');
INSERT 0 1
prueba2=> 
prueba2=> insert into regimenes
prueba2-> 
prueba2-> values ('PC','Pension completa');
INSERT 0 1
prueba2=> 
prueba2=> insert into regimenes
prueba2-> 
prueba2-> values ('TI','Todo incluido');
INSERT 0 1
```

Para conectar la primera máquina con la segunda, vamos a crear el enlace 
con un usuario con privilegios para ello en la primera:

```
postgres@debian:/root$ psql -d prueba1
could not change directory to "/root": Permiso denegado
psql (11.9 (Debian 11.9-0+deb10u1))
Type "help" for help.

prueba1=# create extension dblink;
CREATE EXTENSION
```

Volvemos a iniciar sesión con usuario1 y vamos a realizar una consulta de la 
siguiente manera:

```
postgres@debian:/root$ psql -h localhost -U usuario1 -W -d prueba1
could not change directory to "/root": Permiso denegado
Password: 
psql (11.9 (Debian 11.9-0+deb10u1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

prueba1=> select * from dblink('dbname=prueba2 host=192.168.0.20 user=usuario2 password=usuario', 'select * from regimenes') as regimenes (codigo varchar, Nombre varchar);
 codigo |         nombre         
--------+------------------------
 AD     | Alojamiento y Desayuno
 MP     | Media pension
 PC     | Pension completa
 TI     | Todo incluido
(4 rows)

```

Si queremos hacer lo mismo desde la otra máquina, simplemente tendríamos que
crear un enlace en la máquina2 y realizar una consulta con el usuario2 con la
misma sintaxis.

* Realizar un enlace entre un servidor ORACLE y otro Postgres o MySQL empleando 
Heterogeneus Services, explicando la configuración necesaria en ambos extremos 
y demostrando su funcionamiento.

Para conectar dos servidores con gestores diferentes, es necesario en primer
lugar instalar en la máquina Oracle los siguientes paquetes:

```
[root@localhost ~]# dnf -y install postgresql unixODBC
Última comprobación de caducidad de metadatos hecha hace 7:43:37, el sáb 30 ene 2021 10:21:35 CET.
Dependencias resueltas.
================================================================================
 Paquete      Arq.     Versión                                Repositorio  Tam.
================================================================================
Instalando:
 postgresql   x86_64   10.15-1.module_el8.3.0+619+dbc95fbc    appstream   1.5 M
 unixODBC     x86_64   2.3.7-1.el8                            appstream   458 k
Instalando dependencias:
 libpq        x86_64   12.4-1.el8_2                           appstream   195 k
Activando flujos de módulos:
 postgresql            10                                                      

Resumen de la transacción
================================================================================
Instalar  3 Paquetes

Tamaño total de la descarga: 2.1 M
Tamaño instalado: 7.8 M
Descargando paquetes:
(1/3): libpq-12.4-1.el8_2.x86_64.rpm            461 kB/s | 195 kB     00:00    
(2/3): unixODBC-2.3.7-1.el8.x86_64.rpm          933 kB/s | 458 kB     00:00    
(3/3): postgresql-10.15-1.module_el8.3.0+619+db 2.2 MB/s | 1.5 MB     00:00    
--------------------------------------------------------------------------------
Total                                           1.8 MB/s | 2.1 MB     00:01     
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Prueba de operación exitosa.
Ejecutando operación
  Preparando          :                                                     1/1 
  Instalando          : libpq-12.4-1.el8_2.x86_64                           1/3 
  Instalando          : postgresql-10.15-1.module_el8.3.0+619+dbc95fbc.x8   2/3 
  Instalando          : unixODBC-2.3.7-1.el8.x86_64                         3/3 
  Ejecutando scriptlet: unixODBC-2.3.7-1.el8.x86_64                         3/3 
  Verificando         : libpq-12.4-1.el8_2.x86_64                           1/3 
  Verificando         : postgresql-10.15-1.module_el8.3.0+619+dbc95fbc.x8   2/3 
  Verificando         : unixODBC-2.3.7-1.el8.x86_64                         3/3 
Installed products updated.

Instalado:
  libpq-12.4-1.el8_2.x86_64                                                     
  postgresql-10.15-1.module_el8.3.0+619+dbc95fbc.x86_64                         
  unixODBC-2.3.7-1.el8.x86_64                                                   

¡Listo!
```

```
[root@localhost lib]# dnf -y install postgresql-odbc
Última comprobación de caducidad de metadatos hecha hace 0:45:06, el sáb 30 ene 2021 18:06:58 CET.
Dependencias resueltas.
================================================================================
 Paquete              Arq.        Versión                  Repositorio     Tam.
================================================================================
Instalando:
 postgresql-odbc      x86_64      10.03.0000-2.el8         appstream      432 k

Resumen de la transacción
================================================================================
Instalar  1 Paquete

Tamaño total de la descarga: 432 k
Tamaño instalado: 1.3 M
Descargando paquetes:
postgresql-odbc-10.03.0000-2.el8.x86_64.rpm     291 kB/s | 432 kB     00:01    
--------------------------------------------------------------------------------
Total                                           151 kB/s | 432 kB     00:02     
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Prueba de operación exitosa.
Ejecutando operación
  Preparando          :                                                     1/1 
  Instalando          : postgresql-odbc-10.03.0000-2.el8.x86_64             1/1 
  Ejecutando scriptlet: postgresql-odbc-10.03.0000-2.el8.x86_64             1/1 
  Verificando         : postgresql-odbc-10.03.0000-2.el8.x86_64             1/1 
Installed products updated.

Instalado:
  postgresql-odbc-10.03.0000-2.el8.x86_64                                       

¡Listo!
```

Instalado los paquetes, empezamos a configurar el servidor Oracle. Empezaremos
modificando el fichero _/etc/odbcinst.ini_, añadiendo lo siguiente:

```
[PostgreSQL]
Description     = ODBC for PostgreSQL
Driver          = /usr/lib64/psqlodbcw.so
Setup           = /usr/lib64/libodbcpsqlS.so
Driver64        = /usr/lib64/psqlodbcw.so
Setup64         = /usr/lib64/libodbcpsqlS.so
FileUsage	= 1
```

Terminada la configuración de este fichero, pasaremos al siguiente,
_odbc.ini_, ubicada en el mismo directorio:

```
[PSQL]
Debug = 0
CommLog = 0
ReadOnly = 0
Driver = PostgreSQL
Servername = 192.168.0.19
Username =  usuario1
Password = usuario
Port = 5432
Database = prueba1
Trace = 0
TraceFile = /tmp/sql.log

[Default]
 Driver = /usr/lib64/liboplodbcS.so.2
```

Y terminado esto, debemos comprobar que los cambios en el fichero se
han realizado correctamente. Para ello vamos a ejecutar los siguientes
comandos:

```
[root@localhost ~]# odbcinst -q -d
[PostgreSQL]
[root@localhost ~]# odbcinst -q -s
[PSQL]
[Default]
```

Si la salida es esta, pues está configurado correctamente.
Ya habiendo comprobado la sintaxis, procedemos a realizar la comprobación
de la conexión con el comando _isql_:

```
[root@localhost lib64]# isql -v PSQL
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL> 
```

Funcionando, ahora vamos a configurar los heterogeneus services y para ello,
tenemos que crear un fichero llamado _initPSQL.ora_ ubicado en
_/u01/app/oracle/product/19.3.0/dbhome_1/hs/admin/_. Su contenido será el
siguiente:

```
HS_FDS_CONNECT_INFO = PSQL 
HS_FDS_TRACE_LEVEL = Debug
HS_FDS_SHAREABLE_NAME = /usr/lib64/psqlodbcw.so
HS_LANGUAGE = AMERICAN_AMERICA.WE8ISO8859P9
set ODBCINI=/etc/odbc.ini
```

Ahora procederemos a configurar de nuevo los ficheros _tnsnames.ora_ y 
_listener.ora_:

* listener.ora

```
SID_LIST_LISTENER=
 (SID_LIST=
  (SID_DESC=
   (SID_NAME=PSQL)
   (ORACLE_HOME=/u01/app/oracle/product/19.3.0/dbhome_1)
   (PROGRAM = dg4odbc)

  )
 )

LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )
```

* tnsnames.ora

```
LISTENER_ORCL =
 (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))

ORCL =
   (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
      (CONNECT_DATA =
         (SERVER = DEDICATED)
         (SERVICE_NAME = cdb1)
      )
   )

PSQL =
   (DESCRIPTION=
      (ADDRESS=(PROTOCOL=tcp)(HOST=localhost)(PORT=1521))
      (CONNECT_DATA=(SID=PSQL))
         (HS=OK)
   )

```

Terminada la configuración de ambos ficheros, debemos reiniciar el listener:

```
[oracle@localhost admin]$ lsnrctl stop

LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 30-JAN-2021 19:51:10

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=0.0.0.0)(PORT=1521)))
The command completed successfully
[oracle@localhost admin]$ lsnrctl start

LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 30-JAN-2021 19:51:51

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Starting /u01/app/oracle/product/19.3.0/dbhome_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Log messages written to /u01/app/oracle/diag/tnslsnr/localhost/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=0.0.0.0)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                30-JAN-2021 19:51:52
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Log File         /u01/app/oracle/diag/tnslsnr/localhost/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
Services Summary...
Service "PSQL" has 1 instance(s).
  Instance "PSQL", status UNKNOWN, has 1 handler(s) for this service...
 The command completed successfully
```

Reiniciado el listener, debemos ir hacia nuestra máquina postgres y realizar
la misma configuración que hemos hecho en el segundo ejercicio. Hecho eso,
creamos un nuevo enlace en Oracle:

```
SQL> create database link psql1 connect to "usuario1" identified by "usuario"
  2  using 'PSQL';

Enlace con la base de datos creado.
```

Y comprobamos su funcionamiento:

```
SQL> SELECT * FROM "temporadas"@psql1;

CODIGO	  NOMBRE
--------- -----------------------------------
01	  Baja
02	  Alta
03	  Especial

```

