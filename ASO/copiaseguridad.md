# Sistema de copias de seguridad

Implementa un sistema de copias de seguridad para las instancias del cloud y 
el VPS, teniendo en cuenta las siguientes características:

* Selecciona una aplicación para realizar el proceso: bacula, amanda, shell 
script con tar, rsync, dar, afio, etc.

Vamos a utilizar Bacula como aplicación para realizar las copias de seguridad.

Bacula es un software libre que permite al administrador de sistemas el manejo
de las copias de seguridad, respaldos y verificación de datos a través de una
red de ordenadores de toda índole.
   
* Utiliza una de las instancias como servidor de copias de seguridad, 
añadiéndole un volumen y almacenando localmente las copias de seguridad que 
consideres adecuadas en él.
   
Vamos a utilizar la máquina de Sancho (Ubuntu 20.04 LTS) para la realización
de esta práctica, ya que como tal, no tiene asociado ningún servicio más allá
de la base de datos (necesario para la instalación de Bacula).

Como ya tenemos instalado el servidor de mariadb en Ubuntu, solo instalaremos
los siguientes paquetes:

```
root@sancho:~# apt-get install apache2 php
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  apache2-bin apache2-data apache2-utils libapache2-mod-php7.4 libapr1
  libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libjansson4 liblua5.2-0
  php-common php7.4 php7.4-cli php7.4-common php7.4-json php7.4-opcache
  php7.4-readline ssl-cert
Suggested packages:
  apache2-doc apache2-suexec-pristine | apache2-suexec-custom www-browser
  php-pear openssl-blacklist
The following NEW packages will be installed:
  apache2 apache2-bin apache2-data apache2-utils libapache2-mod-php7.4 libapr1
  libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libjansson4 liblua5.2-0
  php php-common php7.4 php7.4-cli php7.4-common php7.4-json php7.4-opcache
  php7.4-readline ssl-cert
.
.
.
Processing triggers for ufw (0.36-6) ...
Processing triggers for systemd (245.4-4ubuntu3.2) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.1) ...
Processing triggers for php7.4-cli (7.4.3-4ubuntu2.4) ...
Processing triggers for libapache2-mod-php7.4 (7.4.3-4ubuntu2.4) ...
```

Acto seguido, instalaremos también bacula por completo:

```
root@sancho:~# apt-get install bacula bacula-client bacula-common-mysql bacula-director-mysql bacula-server
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  bacula-bscan bacula-common bacula-console bacula-director bacula-fd
  bacula-sd bsd-mailx dbconfig-common dbconfig-mysql liblockfile-bin
  liblockfile1 mt-st mtx postfix
Suggested packages:
  gdb bacula-doc dds2tar scsitools procmail postfix-mysql postfix-pgsql
  postfix-ldap postfix-pcre postfix-lmdb postfix-sqlite sasl2-bin
  | dovecot-common resolvconf postfix-cdb postfix-doc
The following NEW packages will be installed:
  bacula bacula-bscan bacula-client bacula-common bacula-common-mysql
  bacula-console bacula-director bacula-director-mysql bacula-fd bacula-sd
  bacula-server bsd-mailx dbconfig-common dbconfig-mysql liblockfile-bin
  liblockfile1 mt-st mtx postfix
.
.
.
Setting up bacula (9.4.2-2ubuntu5) ...
Processing triggers for rsyslog (8.2001.0-1ubuntu1.1) ...
Processing triggers for ufw (0.36-6) ...
Processing triggers for systemd (245.4-4ubuntu3.2) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.1) ...
```

En el proceso de instalación, nos aparecerá lo siguiente:

```
  ┌────────────────────────┤ Postfix Configuration ├────────────────────────┐
  │                                                                         │ 
  │                                                                           
  │  No configuration:                                                        
  │   Should be chosen to leave the current configuration unchanged.          
  │  Internet site:                                                           
  │   Mail is sent and received directly using SMTP.                          
  │  Internet with smarthost:                                                 
  │   Mail is received directly using SMTP or by running a utility such       
  │   as fetchmail. Outgoing mail is sent using a smarthost.                  
  │  Satellite system:                                                        
  │   All mail is sent to another machine, called a 'smarthost', for          
  │ delivery.                                                                 
  │  Local only:                                                              
  │   The only delivered mail is the mail for local users. There is no        
  │ network.                                                                  
  │                                                                           
  │                                 <Ok>                                      
  │                                                                         │ 
  └─────────────────────────────────────────────────────────────────────────┘ 
```

Pulsamos OK y continuamos. A continuación, tendremos que elegir la configuración
del mail:

```



                    ┌──────┤ Postfix Configuration ├───────┐
                    │ General type of mail configuration:  │ 
                    │                                      │ 
                    │       No configuration               │ 
                    │       Internet Site                  │ 
                    │       Internet with smarthost        │ 
                    │       Satellite system               │ 
                    │       Local only                     │ 
                    │                                      │ 
                    │                                      │ 
                    │       <Ok>           <Cancel>        │ 
                    │                                      │ 
                    └──────────────────────────────────────┘ 
                                                             
```

Elegimos _No Configuration_ y continuamos. En esta última parte, nos pregunta
si queremos configurar la base de datos para el uso de bacula:

```

 ┌───────────────────┤ Configuring bacula-director-mysql ├───────────────────┐
 │                                                                           │ 
 │ The bacula-director-mysql package must have a database installed and      │ 
 │ configured before it can be used. This can be optionally handled with     │ 
 │ dbconfig-common.                                                          │ 
 │                                                                           │ 
 │ If you are an advanced database administrator and know that you want to   │ 
 │ perform this configuration manually, or if your database has already      │ 
 │ been installed and configured, you should refuse this option. Details on  │ 
 │ what needs to be done should most likely be provided in                   │ 
 │ /usr/share/doc/bacula-director-mysql.                                     │ 
 │                                                                           │ 
 │ Otherwise, you should probably choose this option.                        │ 
 │                                                                           │ 
 │ Configure database for bacula-director-mysql with dbconfig-common?        │ 
 │                                                                           │ 
 │                    <Yes>                       <No>                       │ 
 │                                                                           │ 
 └───────────────────────────────────────────────────────────────────────────┘ 
                                                                               
```

Le damos a la opción de _Yes_ y continuamos:

```

 ┌───────────────────┤ Configuring bacula-director-mysql ├───────────────────┐
 │ Please provide a password for bacula-director-mysql to register with the  │ 
 │ database server. If left blank, a random password will be generated.      │ 
 │                                                                           │ 
 │ MySQL application password for bacula-director-mysql:                     │ 
 │                                                                           │ 
 │ _________________________________________________________________________ │ 
 │                                                                           │ 
 │                    <Ok>                        <Cancel>                   │ 
 │                                                                           │ 
 └───────────────────────────────────────────────────────────────────────────┘ 

```                                                                          

A continuación, nos pedirá la contraseña de la base de datos de bacula. Una
vez introducido, continuamos. Ya tendríamos instalado bacula con todas
sus funcionalidades.

Ahora pasaremos a la configuración de Bacula.

En primer lugar, empezaremos por Bacula Director. Bacula Director se
encuentra en un fichero ubicado en _/etc/bacula/bacula-dir.conf_ y en él,
vamos a configurar como vamos a realizar nuestras copias de seguridad.
La configuración será la siguiente:

```
Director {                            # define myself
  Name = sancho-dir		
  DIRport = 9101                
  QueryFile = "/etc/bacula/scripts/query.sql"   
  WorkingDirectory = "/var/lib/bacula"
  PidDirectory = "/run/bacula"
  Maximum Concurrent Jobs = 20
  Password = "1q2w3e4r5t"         # Console password
  Messages = Daemon
  DirAddress = 127.0.0.1
}
```

Parámetros:

- Name --> nombre del director.

- DIRPort --> especifica el puerto por el cual, el director va a escuchar 
las conexiones por consola de Bacula.

- QueryFile --> es obligatoria y especifica el directorio y el fichero usados
por el Director, donde se encuentran las declaraciones SQL para las consultas
en la consola de comandos.

- WorkingDirectory --> obligatoria y especifica el directorio en donde el
Director colocará los ficheros estáticos.

- PidDirectory --> obligatoria y especifica el directorio en el que el 
Director colocará los ficheros de id de los procesos.

- Maximum Concurrent Jobs --> número máximo de trabajos que el Director puede
correr al mismo tiempo.

- Password --> contraseña de la consola de Bacula.

- Messages --> especifica donde tiene que entregar el DIrector los mensajes
que no están asociados con un trabajo especifíco.

- DirAddress --> especifica los puertos y las direcciones IP donde escuchará
el Director por conexiones Bacula mediante consola.


El único parámetro que tenemos que podemos cambiar ahora si queremos sería
la dirección del Director, ya que podríamos poner tanto localhost como su
IP estática. En nuestro caso, vamos a cambiarla:

```
Director {                            # define myself
  Name = sancho-dir
  DIRport = 9101                # where we listen for UA connections
  QueryFile = "/etc/bacula/scripts/query.sql"
  WorkingDirectory = "/var/lib/bacula"
  PidDirectory = "/run/bacula"
  Maximum Concurrent Jobs = 20
  Password = "1q2w3e4r5t"         # Console password
  Messages = Daemon
  DirAddress = 10.0.1.11
}
```

Configurado el Director, ahora vamos a pasar a configurar la tarea que realizará
las copias de seguridad.

* El proceso debe realizarse de forma completamente automática
   


* Selecciona qué información es necesaria guardar (listado de paquetes, 
ficheros de configuración, documentos, datos, etc.)

   
* Realiza semanalmente una copia completa

Para configurar la copia completa semanal, debemos crear un trabajo definido en
el fichero anteriormente comentado:

```
JobDefs {
  Name = "Backups"
  Type = Backup
  Level = Incremental
  Client = sancho-fd
  FileSet = "Full Set"
  Schedule = "Semanal"
  Storage = File1
  Messages = Standard
  Pool = File
  SpoolAttributes = yes
  Priority = 10
  Write Bootstrap = "/var/lib/bacula/%c.bsr"
}
```
 
Esto define una plantilla para los trabajos (jobs), es decir, no se ejecutan
pero si a algún trabajo le falta algún parámetro lo toma del JobDefs.

Ahora vamos a configurar las tareas de cada cliente:

```
Job {
  Name = "BackupSancho"
  JobDefs = "Backups"
  Client = "sancho-fd"
}

Job {
  Name = "BackupQuijote"
  JobDefs = "Backups"
  Client = "quijote-fd"
}

Job {
  Name = "BackupFreston"
  JobDefs = "Backups"
  Client = "freston-fd"
}

Job {
  Name = "BackupDulcinea"
  JobDefs = "Backups"
  Client = "dulcinea-fd"
}
```

Y hecho esto, pasamos a los Backups de cada una de ellas:

```
Job {
 Name = "RestoreSancho"
 Type = Restore
 Client = sancho-fd
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

Job {
 Name = "RestoreQuijote"
 Type = Restore
 Client = quijote-fd
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

Job {
 Name = "RestoreQuijote"
 Type = Restore
 Client = quijote-fd
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

Job {
 Name = "RestoreFreston"
 Type = Restore
 Client = freston-fd
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

```

Vamos a definir a continuación que ficheros queremos incluir o excluir en el 
trabajo de restauración:

```
FileSet {
  Name = "Full Set"
  Include {
    Options {
      signature = MD5
      compression = GZIP
    }
    File = /home       
    File = /etc
    File = /var
  }
  Exclude {
    File = /var/lib/bacula
    File = /nonexistant/path/to/file/archive/dir
    File = /proc
    File = /var/tmp
    File = /var/cache
    File = /tmp
    File = /sys
    File = /.journal
    File = /.fsck
  }
}
```

Pasamos ahora a la configuración del ciclo semanal y de los clientes en 
Bacula. Para el ciclo tendremos que editar el parámetro _Schedule_:

```
Schedule {
  Name = "Semanal"
  Run = Level = Full sun at 23:05
  Run = Level = Incremental mon-sat at 23:05
}
```

Y para los clientes haremos lo siguiente:

```
Client {
  Name = sancho-fd
  Address = 10.0.1.11
  FDPort = 9102
  Catalog = MyCatalog
  Password = "1q2w3e4r5t"          # password for FileDaemon
  File Retention = 60 days            # 60 days
  Job Retention = 6 months            # six months
  AutoPrune = yes                     # Prune expired Jobs/Files
}

Client {
  Name = quijote-fd
  Address = 10.0.2.10
  FDPort = 9102
  Catalog = MyCatalog
  Password = "1q2w3e4r5t"          # password for FileDa>
  File Retention = 60 days            # 60 days
  Job Retention = 6 months            # six months
  AutoPrune = yes                     # Prune expired Jobs/Files
}

Client {
  Name = freston-fd
  Address = 10.0.1.10
  FDPort = 9102
  Catalog = MyCatalog
  Password = "1q2w3e4r5t"          # password for FileDa>
  File Retention = 60 days            # 60 days
  Job Retention = 6 months            # six months
  AutoPrune = yes                     # Prune expired Jobs/Files
}

Client {
  Name = dulcinea-fd
  Address = 10.0.1.4
  FDPort = 9102
  Catalog = MyCatalog
  Password = "1q2w3e4r5t"          # password for FileDa>
  File Retention = 60 days            # 60 days
  Job Retention = 6 months            # six months
  AutoPrune = yes                     # Prune expired Jobs/Files
}
```

Lo siguiente en configurar va a ser el almacenamiento. Se encarga de manejar
los dispositivos físicos donde se guardarán los datos.

```
Storage {
 Name = File
 Address = 10.0.1.11 # No usar localhost
 SDPort = 9103
 Password = "1q2w3e4r5t"
 Device = FileChgr1
 Media Type = File
 Maximum Concurrent Jobs = 10 # run up to 10 jobs a the same time
}
```

Y el acceso a la base de datos:

```
Catalog {
  Name = MyCatalog
  dbname = "bacula"; DB Address = "localhost";  dbuser = "bacula"; dbpassword = "1q2w3e4r5t"
}
```

Definimos de paso el Pool:

```
Pool {
  Name = File
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
  Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
  Label Format = "Vol1"               # Auto label
}
```

Y hasta aquí, configuración para proceder a la creación de Backups semanalmente.

Comprobamos que la sintaxis puesta en el fichero anterior es correcta:

```
root@sancho:~# bacula-dir -tc /etc/bacula/bacula-dir.conf 
root@sancho:~# 
```

* Realiza diariamente una copia incremental, diferencial o delta diferencial 
(decidir cual es más adecuada).
   
* Implementa una planificación del almacenamiento de copias de seguridad para 
una ejecución prevista de varios años, detallando qué copias completas se 
almacenarán de forma permanente y cuales se irán borrando.
   

* Crea un registro de las copias, indicando fecha, tipo de copia, si se 
realizó correctamente o no y motivo.

   
* Selecciona un directorio de datos "críticos" que deberá almacenarse cifrado 
en la copia de seguridad, bien encargándote de hacer la copia manualmente o 
incluyendo la contraseña de cifrado en el sistema

   
* Incluye en la copia los datos de las nuevas aplicaciones que se vayan 
instalando durante el resto del curso

   
* Utiliza saturno u otra opción que se te facilite como equipo secundario 
para almacenar las copias de seguridad. Solicita acceso o la instalación de 
las aplicaciones que sean precisas.

Para este punto, vamos a implementar un volumen que servirá como equipo de
almacenamiento para las copias de seguridad:

```
root@sancho:/home/ubuntu# mkfs.ext4 /dev/vdb
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 2621440 4k blocks and 655360 inodes
Filesystem UUID: d652223b-56e9-4ba5-884a-d142c4553cd5
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

root@sancho:/home/ubuntu# mkdir /bacula
root@sancho:/home/ubuntu# mount /dev/vdb /bacula
root@sancho:/home/ubuntu# lsblk -f
.
.
.
vda                                                                    
├─vda1
│    ext4   cloudimg-rootfs
│                  e9243f3d-cfed-4d68-8705-7f40911ce19a      3G    47% /
├─vda14
│                                                                      
└─vda15
     vfat   UEFI   F8B5-A9F0                             100.5M     4% /boot/efi
vdb  ext4          d652223b-56e9-4ba5-884a-d142c4553cd5    9.2G     0% /bacula
root@sancho:/home/ubuntu# cd /bacula/
root@sancho:/bacula# mkdir backups
root@sancho:/bacula# chown bacula:bacula /bacula/backups/ -R
root@sancho:/bacula# chmod 755 /bacula/backups/ -R
```



El sistema de copias debe estar operativo para la fecha de entrega, aunque se 
podrán hacer correcciones menores que se detecten a medida que vayan 
ejecutándose las copias. La corrección se realizará la última semana de curso 
y consistirá tanto en la restauración puntual de un fichero en cualquier 
fecha como la restauración completa de una de las máquinas.
