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

El listado de ficheros que queremos incluir o excluir está en el siguiente punto.
   
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
 Name = "RestoreFreston"
 Type = Restore
 Client = freston-fd
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

Job {
 Name = "RestoreDulcinea"
 Type = Restore
 Client = dulcinea-fd
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

Y hasta aquí, la configuración para proceder a la creación de Backups 
semanalmente.

Comprobamos que la sintaxis puesta en el fichero anterior es correcta:

```
root@sancho:~# bacula-dir -tc /etc/bacula/bacula-dir.conf 
root@sancho:~# 
```

También tenemos que configurar el demonio de bacula, que se encuentra en el
fichero de configuración _/etc/bacula/bacula-sd.conf (Bacula's Storage Daemon).

```
Storage {                             # definition of myself
  Name = sancho-sd
  SDPort = 9103                  # Director's port
  WorkingDirectory = "/var/lib/bacula"
  Pid Directory = "/run/bacula"
  Plugin Directory = "/usr/lib/bacula"
  Maximum Concurrent Jobs = 20
  SDAddress = 10.0.1.11
}

Director {
  Name = sancho-dir
  Password = "1q2w3e4r5t"
}

Director {
  Name = sancho-mon
  Password = "1q2w3e4r5t"
  Monitor = yes
}

Autochanger {
  Name = FileChgr1
  Device = FileChgr1-Dev1             
  Changer Command = ""
  Changer Device = /dev/null
}

Device {
  Name = FileChgr1-Dev1
  Media Type = File 
  Archive Device = /bacula/backups
  LabelMedia = yes;                   # lets Bacula label unlabeled media
  Random Access = Yes;
  AutomaticMount = yes;               # when device opened, read it
  RemovableMedia = no;
  AlwaysOpen = no;
  Maximum Concurrent Jobs = 5
}
```

Terminada la configuración, vamos a comprobar su funcionamiento y reiniciamos
ambos servicios:

```
root@sancho:/etc/bacula# bacula-sd -tc bacula-sd.conf 
root@sancho:/etc/bacula# systemctl restart bacula-sd.service
root@sancho:/etc/bacula# systemctl restart bacula-director.service
root@sancho:/etc/bacula# 
```

Ahora pasamos a la configuración de la consola de Bacula, cuyo fichero de 
configuración podemos encontrarlo en la ubicación _/etc/bacula/bconsole.conf_:

```
Director {
  Name = sancho-dir
  DIRport = 9101
  address = 10.0.1.11
  Password = "1q2w3e4r5t"
}
```

* Realiza diariamente una copia incremental, diferencial o delta diferencial 
(decidir cual es más adecuada).
   
DIARIA

* Implementa una planificación del almacenamiento de copias de seguridad para 
una ejecución prevista de varios años, detallando qué copias completas se 
almacenarán de forma permanente y cuales se irán borrando.

Para realizar una configuración de copias anual, debemos seguir editando
el fichero _/etc/bacula/bacula-dir.conf_:

```
# Configuración anual

JobDefs {
 Name = "Backups-Anual"
 Type = Backup
 Level = Full
 Client = sancho-fd
 FileSet = "Full Set"
 Schedule = "Anual"
 Storage = File
 Messages = Standard
 Pool = File
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Sancho_Anual"
 JobDefs = "Backups-Anual"
 Client = "sancho-fd-anual"
}

Job {
 Name = "Quijote-Anual"
 JobDefs = "Backups-Anual"
 Client = "quijote-fd-anual"
}

Job {
 Name = "Freston-Anual"
 JobDefs = "Backups-Anual"
 Client = "freston-fd-anual"
}

Job {
 Name = "Dulcinea-Anual"
 JobDefs = "Backups-Anual"
 Client = "dulcinea-fd-anual"
}

Job {
 Name = "RestoreSancho-Anual"
 Type = Restore
 Client = sancho-fd-anual
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

Job {
 Name = "RestoreQuijote-Anual"
 Type = Restore
 Client = quijote-fd-anual
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

Job {
 Name = "RestoreFreston-Anual"
 Type = Restore
 Client = Freston-fd-anual
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

Job {
 Name = "RestoreDulcinea-Anual"
 Type = Restore
 Client = dulcinea-fd-anual
 FileSet = "Full Set"
 Storage = File
 Pool = File
 Messages = Standard
}

Schedule {
 Name = "Anual"
 Run = Full on 31 Dec at 23:50
}

Client {
 Name = sancho-fd-anual
 Address = 10.0.1.11
 FDPort = 9102
 Catalog = MyCatalog
 Password = "1q2w3e4r5t" # password for FileDaemon
 File Retention = 15 years # 60 days
 Job Retention = 15 years # six months
 AutoPrune = yes # Prune expired Jobs/Files
}

Client {
 Name = quijote-fd-anual
 Address = 10.0.2.10
 FDPort = 9102
 Catalog = MyCatalog
 Password = "1q2w3e4r5t" # password for FileDaemon 2
 File Retention = 15 years # 60 days
 Job Retention = 15 years # six months
 AutoPrune = yes # Prune expired Jobs/Files
}

Client {
 Name = freston-fd-anual
 Address = 10.0.1.10
 FDPort = 9102
 Catalog = MyCatalog
 Password = "1q2w3e4r5t" # password for FileDaemon 2
 File Retention = 15 years # 60 days
 Job Retention = 15 years # six months
 AutoPrune = yes # Prune expired Jobs/Files
}

Client {
 Name = dulcinea-fd-anual
 Address = 10.0.1.4
 FDPort = 9102
 Catalog = MyCatalog
 Password = "1q2w3e4r5t" # password for FileDaemon 2
 File Retention = 15 years # 60 days
 Job Retention = 15 years # six months
 AutoPrune = yes # Prune expired Jobs/Files
}
```

Y comprobamos que funciona:

```
root@sancho:/etc/bacula# bacula-dir -tc bacula-dir.conf 
root@sancho:/etc/bacula# 
```

Casi para ir acabando, debemos irnos a cada cliente, incluyendo a Sancho e
instalar el cliente de Bacula y realizar los cambios pertinentes en los
ficheros de configuración de _/etc/bacula/bacula-fd.conf_:

* Sancho

```
Director {
  Name = sancho-dir
  Password = "1q2w3e4r5t"
}

Director {
  Name = sancho-mon
  Password = "1q2w3e4r5t"
  Monitor = yes
}

FileDaemon {                          # this is me
  Name = sancho-fd
  FDport = 9102                  # where we listen for the director
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib/bacula
  FDAddress = 10.0.1.11
}

Messages {
  Name = Standard
  director = sancho-dir = all, !skipped, !restored
}
```

Y reiniciamos el servicio tanto de _bacula-fd.service_ y aprovechando que hemos
hecho el cambio en la configuración anual, pues lo haremos también de
_bacula-dir.conf_:

```
root@sancho:/etc/bacula# systemctl restart bacula-fd.service
root@sancho:/etc/bacula# systemctl restart bacula-director.service
root@sancho:/etc/bacula# 
```

* Quijote

```
[centos@quijote ~]$ sudo dnf -y install bacula-client
Last metadata expiration check: 2:31:11 ago on Wed 20 Jan 2021 03:44:34 PM UTC.
Dependencies resolved.
================================================================================
 Package              Architecture  Version              Repository        Size
================================================================================
Installing:
 bacula-client        x86_64        9.0.6-6.el8          AppStream        153 k
Installing dependencies:
 bacula-common        x86_64        9.0.6-6.el8          AppStream         36 k
 bacula-libs          x86_64        9.0.6-6.el8          AppStream        502 k

Transaction Summary
================================================================================
Install  3 Packages

Total download size: 692 k
Installed size: 1.7 M
Downloading Packages:
(1/3): bacula-common-9.0.6-6.el8.x86_64.rpm     211 kB/s |  36 kB     00:00    
(2/3): bacula-client-9.0.6-6.el8.x86_64.rpm     627 kB/s | 153 kB     00:00    
(3/3): bacula-libs-9.0.6-6.el8.x86_64.rpm       1.6 MB/s | 502 kB     00:00    
--------------------------------------------------------------------------------
Total                                           409 kB/s | 692 kB     00:01     
.
.
.
Installed:
  bacula-client-9.0.6-6.el8.x86_64       bacula-common-9.0.6-6.el8.x86_64      
  bacula-libs-9.0.6-6.el8.x86_64        

Complete!
```

Y configuramos el fichero:

```
Director {
  Name = sancho-dir
  Password = "1q2w3e4r5t"
}

Director {
  Name = sancho-mon
  Password = "1q2w3e4r5t"
  Monitor = yes
}

FileDaemon {                          # this is me
  Name = quijote-fd
  FDport = 9102                  # where we listen for the director
  WorkingDirectory = /var/spool/bacula
  Pid Directory = /var/run
  Maximum Concurrent Jobs = 20
}

Messages {
  Name = Standard
  director = sancho-dir = all, !skipped, !restored
}

```

Y reiniciamos el servicio:

```
[centos@quijote ~]$ sudo systemctl restart bacula-fd.service
[centos@quijote ~]$ 
```

Y configuramos el firewall propio de CentOS para permitir la conexión:

```
[centos@quijote ~]$ sudo firewall-cmd --zone=public --permanent --add-port 9102/tcp
success
[centos@quijote ~]$ sudo firewall-cmd --reload
success
```

* Freston

```
debian@freston:~$ sudo apt-get install bacula-client 
```

Y configuramos el fichero _bacula-fd.conf_:

```
Director {
  Name = sancho-dir
  Password = "1q2w3e4r5t"
}

Director {
  Name = sancho-mon
  Password = "1q2w3e4r5t"
  Monitor = yes
}

FileDaemon {                          # this is me
  Name = freston-fd
  FDport = 9102                  # where we listen for the director
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib/bacula
  FDAddress = 10.0.1.11
}

Messages {
  Name = Standard
  director = sancho-dir = all, !skipped, !restored
}
```

Y reiniciamos el servicio:

```
debian@freston:~$ sudo systemctl restart bacula-fd.service 
debian@freston:~$ 
```


* Dulcinea

```
debian@dulcinea:~$ sudo apt-get install bacula-client
```

Y configuramos el fichero anteriormente comentado:

```
Director {
  Name = sancho-dir
  Password = "1q2w3e4r5t"
}

Director {
  Name = sancho-mon
  Password = "1q2w3e4r5t"
  Monitor = yes
}

FileDaemon {                          # this is me
  Name = dulcinea-fd
  FDport = 9102                  # where we listen for the director
  WorkingDirectory = /var/lib/bacula
  Pid Directory = /run/bacula
  Maximum Concurrent Jobs = 20
  Plugin Directory = /usr/lib/bacula
  FDAddress = 10.0.1.11
}

Messages {
  Name = Standard
  director = sancho-dir = all, !skipped, !restored
}
```

Y reiniciamos:

```
debian@dulcinea:~$ sudo systemctl restart bacula-fd.service 
debian@dulcinea:~$ 
```

Hecho ya en las cuatro máquinas, reiniciamos de nuevo los servicios en 
Sancho:

```
ubuntu@sancho:~$ sudo systemctl restart bacula-fd.service 
ubuntu@sancho:~$ sudo systemctl restart bacula-sd.service 
ubuntu@sancho:~$ sudo systemctl restart bacula-director.service 
```

Ahora, accedemos a la consola de Bacula y comprobamos que tenemos los 
clientes:

```
root@sancho:/home/ubuntu# cd /bacula/
root@sancho:/bacula# bconsole 
Connecting to Director 10.0.1.11:9101
1000 OK: 103 sancho-dir Version: 9.4.2 (04 February 2019)
Enter a period to cancel a command.
*status client
The defined Client resources are:
     1: sancho-fd
     2: quijote-fd
     3: freston-fd
     4: dulcinea-fd
     5: sancho-fd-anual
     6: quijote-fd-anual
     7: freston-fd-anual
     8: dulcinea-fd-anual
Select Client (File daemon) resource (1-8): 
```

A continuación, usaremos la consola para etiquetar el volumen físico:

```
root@sancho:/bacula# bconsole
Connecting to Director 10.0.1.11:9101
1000 OK: 103 sancho-dir Version: 9.4.2 (04 February 2019)
Enter a period to cancel a command.
*label
Automatically selected Catalog: MyCatalog
Using Catalog "MyCatalog"
The defined Storage resources are:
     1: File
     2: File1
     3: File2
Select Storage resource (1-3): 1
Enter new Volume name: bacula
Defined Pools:
     1: Default
     2: File
     3: Scratch
Select the Pool (1-3): 2
Connecting to Storage daemon File at 10.0.1.11:9103 ...
Sending label command for Volume "bacula" Slot 0 ...
3000 OK label. VolBytes=213 VolABytes=0 VolType=1 Volume="bacula" Device="FileChgr1-Dev1" (/bacula/backups)
Catalog record for Volume "bacula", Slot 0  successfully created.
Requesting to mount FileChgr1 ...
3906 File device ""FileChgr1-Dev1" (/bacula/backups)" is always mounted.
You have messages.
```

* Crea un registro de las copias, indicando fecha, tipo de copia, si se 
realizó correctamente o no y motivo.

LOGS
   
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
