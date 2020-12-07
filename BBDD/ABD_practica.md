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
debian@bbdd:~$ sudo apt-get install postgresql-11
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
debian@bbdd:~$ pg_isready
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
debian@bbdd:~$ sudo passwd postgres
Nueva contraseña: 
Vuelva a escribir la nueva contraseña: 
passwd: contraseña actualizada correctamente
debian@bbdd:~$ sudo su postgres
postgres@debian:/home/debian$ exit
exit
```

A continuación, crearemos un nuevo usuario para el gestor con:

``` 
postgres@bbdd:/home/debian$ createuser -s manuel -P 
Ingrese la contraseña para el nuevo rol: 
Ingrésela nuevamente: 
```

Con la opción -s le asignamos permisos de superusuario.

Ahora vamos a proceder a crear propiamente la base de datos. Para ello vamos a
ejecutar:

```
debian@bbdd:~$ createdb bbddprueba
debian@bbdd:~$ psql bbddprueba 
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
host    all             all             0.0.0.0/0            md5
```

Una vez ya configurado, reiniciamos el servicio de Postgresql.

Ahora para comprobar que efectivamente nos podemos conectar mediante un usuario
a nuestro servidor, nos meteremos en una máquina cuya IP es 172.22.200.190
(IP permitida) y nos descargaremos el paquete ```postgresql-cliente-11```.

Una vez descargado, comprobamos la conexión desde la máquina cliente:

```
manuel@debian:~$ psql -h 172.22.200.117 -p 5432 -U bbdd -d bbddprueba
Contraseña para usuario bbdd: 
psql (11.9 (Debian 11.9-0+deb10u1))
conexión SSL (protocolo: TLSv1.3, cifrado: TLS_AES_256_GCM_SHA384, bits: 256, compresión: desactivado)
Digite «help» para obtener ayuda.

bbddprueba=# \dt
             Listado de relaciones
 Esquema |       Nombre        | Tipo  | Dueño  
---------+---------------------+-------+--------
 public  | habitaciones        | tabla | debian
 public  | regimenes           | tabla | debian
 public  | temporadas          | tabla | debian
 public  | tipos_de_habitacion | tabla | debian
(4 filas)

bbddprueba=# 
```

Tras indagar en el problema hallado con el problema de conexión al permitir 
solamente la red X (aún teniendo la configuración correctamente), hemos acordado
con el profesor que permitamos todo, y continuar con los ejercicios.

* Prueba desde un cliente remoto el intérprete de comandos de MongoDB.

En primer lugar instalaremos en una máquina, el servidor de MongoDB. Para ello,
debemos realizar los siguientes pasos:

Primero, debemos ejecutar el siguiente comando para añadir las keys necesarias
del servidor de MongoDB:

```
vagrant@mongo:~$ wget https://www.mongodb.org/static/pgp/server-4.4.asc -qO- | sudo apt-key add -
OK
```

Después, editaremos el fichero _/etc/apt/sources.list.d/mongodb-org.list_ y le
añadiremos la siguiente línea:

```
deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main
```

Hecho esto, hacemos un update del sistema y a continuación, nos descargamos el 
paquete llamado _mongodb-org_:

```
vagrant@mongo:~$ sudo apt-get install mongodb-org
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  mongodb-database-tools mongodb-org-database-tools-extra mongodb-org-mongos
  mongodb-org-server mongodb-org-shell mongodb-org-tools
The following NEW packages will be installed:
  mongodb-database-tools mongodb-org mongodb-org-database-tools-extra
  mongodb-org-mongos mongodb-org-server mongodb-org-shell mongodb-org-tools
0 upgraded, 7 newly installed, 0 to remove and 55 not upgraded.
Need to get 104 MB of archives.
After this operation, 200 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4/main amd64 mongodb-database-tools amd64 100.2.1 [54.5 MB]
Get:2 http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4/main amd64 mongodb-org-shell amd64 4.4.2 [13.2 MB]
Get:3 http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4/main amd64 mongodb-org-server amd64 4.4.2 [20.4 MB]
Get:4 http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4/main amd64 mongodb-org-mongos amd64 4.4.2 [15.7 MB]
Get:5 http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4/main amd64 mongodb-org-database-tools-extra amd64 4.4.2 [5,636 B]
Get:6 http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4/main amd64 mongodb-org-tools amd64 4.4.2 [2,892 B]
Get:7 http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4/main amd64 mongodb-org amd64 4.4.2 [3,520 B]
Fetched 104 MB in 23s (4,496 kB/s)                                             
Selecting previously unselected package mongodb-database-tools.
(Reading database ... 32165 files and directories currently installed.)
Preparing to unpack .../0-mongodb-database-tools_100.2.1_amd64.deb ...
Unpacking mongodb-database-tools (100.2.1) ...
Selecting previously unselected package mongodb-org-shell.
Preparing to unpack .../1-mongodb-org-shell_4.4.2_amd64.deb ...
Unpacking mongodb-org-shell (4.4.2) ...
Selecting previously unselected package mongodb-org-server.
Preparing to unpack .../2-mongodb-org-server_4.4.2_amd64.deb ...
Unpacking mongodb-org-server (4.4.2) ...
Selecting previously unselected package mongodb-org-mongos.
Preparing to unpack .../3-mongodb-org-mongos_4.4.2_amd64.deb ...
Unpacking mongodb-org-mongos (4.4.2) ...
Selecting previously unselected package mongodb-org-database-tools-extra.
Preparing to unpack .../4-mongodb-org-database-tools-extra_4.4.2_amd64.deb ...
Unpacking mongodb-org-database-tools-extra (4.4.2) ...
Selecting previously unselected package mongodb-org-tools.
Preparing to unpack .../5-mongodb-org-tools_4.4.2_amd64.deb ...
Unpacking mongodb-org-tools (4.4.2) ...
Selecting previously unselected package mongodb-org.
Preparing to unpack .../6-mongodb-org_4.4.2_amd64.deb ...
Unpacking mongodb-org (4.4.2) ...
Setting up mongodb-org-server (4.4.2) ...
Setting up mongodb-org-shell (4.4.2) ...
Setting up mongodb-database-tools (100.2.1) ...
Setting up mongodb-org-mongos (4.4.2) ...
Setting up mongodb-org-database-tools-extra (4.4.2) ...
Setting up mongodb-org-tools (4.4.2) ...
Setting up mongodb-org (4.4.2) ...
Processing triggers for man-db (2.8.5-2) ...
```

Una vez hecho esto, debemos activar el servicio con:

```
sudo systemctl restart mongod.service
```

Ahora configuraremos el acceso. En primer lugar ejecutamos mongo:

```
vagrant@mongo:~$ mongo
MongoDB shell version v4.4.2
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("39a6b935-e95c-495c-b6c5-e37471fbe92c") }
MongoDB server version: 4.4.2
---
The server generated these startup warnings when booting: 
        2020-12-05T17:39:41.197+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
        2020-12-05T17:39:41.656+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
---
---
        Enable MongoDB's free cloud-based monitoring service, which will then receive and display
        metrics about your deployment (disk utilization, CPU, operation statistics, etc).

        The monitoring data will be available on a MongoDB website with a unique URL accessible to you
        and anyone you share the URL with. MongoDB may use this information to make product
        improvements and to suggest MongoDB products and deployment options to you.

        To enable free monitoring, run the following command: db.enableFreeMonitoring()
        To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
---
> 
```

Y ahora seleccionamos la base de datos admin y creamos un usuario:

```
> use admin
switched to db admin
> db.createUser({user: "mongodb", pwd: "1q2w3e4r5t", roles: [{role: "root", db: "admin"}]})
Successfully added user: {
	"user" : "mongodb",
	"roles" : [
		{
			"role" : "root",
			"db" : "admin"
		}
	]
}
> exit
bye
```

Con esto, ya podremos ejecutar el servicio de MongoDB correctamente. Ahora, 
para poder acceder remotamente, debemos modificar el fichero _/etc/mongod.conf_,
la directiva de _bindIP_:

```
net:
  port: 27017
  bindIp: 127.0.0.1
```

Y modificamos dicho parámetro por _0.0.0.0_.

En caso necesario, si tenemos activado el firewall UFW, debemos añadir la regla:

```
sudo ufw allow 27017/tcp
```

Ahora pasando al cliente, seguiremos los mismo pasos hasta llegar a iniciar el 
servicio por primera vez, y para conectarnos debemos ejecutar el siguiente
comando:

```
vagrant@mongocliente:~$ mongo --host 172.28.128.7 -u mongodb
MongoDB shell version v4.4.2
Enter password: 
connecting to: mongodb://172.28.128.7:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("e7777754-7e99-46ba-a9fa-e22516c95c8d") }
MongoDB server version: 4.4.2
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
	https://docs.mongodb.com/
Questions? Try the MongoDB Developer Community Forums
	https://community.mongodb.com
---
The server generated these startup warnings when booting: 
        2020-12-05T17:52:27.652+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
        2020-12-05T17:52:28.359+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
---
---
        Enable MongoDB's free cloud-based monitoring service, which will then receive and display
        metrics about your deployment (disk utilization, CPU, operation statistics, etc).

        The monitoring data will be available on a MongoDB website with a unique URL accessible to you
        and anyone you share the URL with. MongoDB may use this information to make product
        improvements and to suggest MongoDB products and deployment options to you.

        To enable free monitoring, run the following command: db.enableFreeMonitoring()
        To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
---
> exit
bye
```

Y ya nos podríamos conectar.


* Realización de una aplicación web en cualquier lenguaje que conecte con el 
servidor MySQL desde un cliente remoto tras autenticarse y muestre alguna 
información almacenada en el mismo.



* Instalación de SQL Developer sobre Windows como cliente remoto de ORACLE.

En primer lugar, nos descargaremos el archivo .zip de SQL Developer de la 
sección de descarga de recursos de la página web de Oracle.

Una vez descargado, extraeremos dicho archivo y ejecutaremos el binario
SQLDeveloper.exe.

Y empezará la instalación. Nos dirá si queremos importar alguna configuración
anterior. Le damos que no y una vez haya terminado la instalación, nos 
aparece la ventana de inicio de SQL Developer:

![alt text](../Imágenes/sqldevinicio.png)

Una vez aquí, pulsamos el botón verde e intentamos rellenar la información
necesaria para conectarnos al servidor de Oracle que queramos. 

Ejemplo:

```

```

* Instalación y prueba desde un cliente remoto de Oracle Enterprise Manager.

Nos descargamos flashplayer de la siguiente [página](https://get.adobe.com/flashplayer/).

Una vez descargado el archivo .tar.gz, lo descomprimimos y después ejecutamos
los siguientes comandos:

```
manuel@debian:~/Descargas/flashplayer$ sudo cp libflashplayer.so /usr/lib/mozilla/plugins/
manuel@debian:~/Descargas/flashplayer$ sudo cp -r usr/* /usr/
```

Ahora instalaremos Oracle para tener un Servidor con el que conectarnos.

Primero, nos descargaremos los siguientes paquetes:

```
build-essential sysstat unzip libstdc++5 numactl expat libaio-dev 
unixodbc-dev lesstif2-dev elfutils libelf-dev binutils libcap-dev gcc g++
ksh xorg xauth rpm libxcb1-dev libxau-dev libxtst-dev libxi-dev 
```

Añadiremos los grupos y usuarios pertinentes:

```
addgroup --system oinstall
addgroup --system dba
adduser --system --ingroup oinstall -shell /bin/bash oracle
adduser oracle dba
passwd oracle
```

Y los directorios:

```
mkdir -p /opt/oracle/product/12.2.0.1
mkdir -p /opt/oraInventory
chown -R oracle:dba /opt/ora*
```

A continuación, crearemos los enlaces simbólicos necesarios:

```
ln -s /usr/bin/awk /bin/awk
ln -s /usr/bin/basename /bin/basename
ln -s /usr/bin/rpm /bin/rpm
ln -s /usr/lib/x86_64-linux-gnu /usr/lib64
```

Crearemos los límites del sistema:

```
echo """
## Valor del número máximo de manejadores de archivos. ##
fs.file-max = 65536
fs.aio-max-nr = 1048576
## Valor de los parámetros de semáforo en el orden listado. ##
## semmsl, semmns, semopm, semmni ##
kernel.sem = 250 32000 100 128
## Valor de los tamaños de segmento de memoria compartida. ##
## (Oracle recomienda total de RAM -1 byte) 2GB ##
kernel.shmmax = 2107670527
kernel.shmall = 514567
kernel.shmmni = 4096
## Valor del rango de números de puerto. ##
net.ipv4.ip_local_port_range = 1024 65000
## Valor del número gid del grupo dba. ##
vm.hugetlb_shm_group = 121
## Valor del número de páginas de memoria. ##
vm.nr_hugepages = 64
""" > /etc/sysctl.d/local-oracle.conf
```

Y tras esto, cargaremos dichas variables con el siguiente comando:

```
sysctl -p /etc/sysctl.d/local-oracle.conf
```

Y una vez hecho, realizaremos un configuración de seguridad:

```
echo """
## Número máximo de procesos disponibles para un solo usuario. ##
oracle          soft    nproc           2047
oracle          hard    nproc           16384
## Número máximo de descriptores de archivo abiertos para un solo usuario. ##
oracle          soft    nofile          1024
oracle          hard    nofile          65536
## Cantidad de RAM para el uso de páginas de memoria. ##
oracle          soft    memlock         204800
oracle          hard    memlock         204800
""" > /etc/security/limits.d/local-oracle.conf
```

Creamos las variables de entorno para Oracle:

```
echo """
## Nombre del equipo ##
export ORACLE_HOSTNAME=localhost
## Usuario con permiso en archivos Oracle. ##
export ORACLE_OWNER=oracle
## Directorio que almacenará los distintos servicios de Oracle. ##
export ORACLE_BASE=/opt/oracle
## Directorio que almacenará la base de datos Oracle. ##
export ORACLE_HOME=/opt/oracle/product/12.2.0.1/dbhome_1
## Nombre único de la base de datos. ##
export ORACLE_UNQNAME=oraname
## Identificador de servicio de escucha. ##
export ORACLE_SID=orasid
## Ruta a archivos binarios. ##
export PATH=$PATH:/opt/oracle/product/12.2.0.1/dbhome_1/bin
## Ruta a la biblioteca. ##
export LD_LIBRARY_PATH=/opt/oracle/product/12.2.0.1/dbhome_1/lib
## Idioma
export NLS_LANG='SPANISH_SPAIN.AL32UTF8'
""" >> /etc/bash.bashrc
```

Una vez hayamos hecho esto, nos descargamos la versión de Oracle que queramos.
Nos descargamos el fichero .zip y los descomprimimos.


