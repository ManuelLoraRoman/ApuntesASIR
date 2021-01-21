# Sistema de copias de seguridad

Implementa un sistema de copias de seguridad para las instancias del cloud y 
el VPS, teniendo en cuenta las siguientes características:

* Selecciona una aplicación para realizar el proceso: bacula, amanda, shell 
script con tar, rsync, dar, afio, etc.

* Utiliza una de las instancias como servidor de copias de seguridad, 
añadiéndole un volumen y almacenando localmente las copias de seguridad que 
consideres adecuadas en él.
   
* El proceso debe realizarse de forma completamente automática

* Selecciona qué información es necesaria guardar (listado de paquetes, 
ficheros de configuración, documentos, datos, etc.)

* Realiza semanalmente una copia completa

Para configurar la copia completa semanal, debemos crear un trabajo definido en
el fichero anteriormente comentado:

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
```

* Realiza diariamente una copia incremental, diferencial o delta diferencial (decidir cual es más 
adecuada).

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
   
* Selecciona un directorio de datos "críticos" que deberá almacenarse cifrado 
en la copia de seguridad, bien encargándote de hacer la copia manualmente o 
incluyendo la contraseña de cifrado en el sistema
   
* Incluye en la copia los datos de las nuevas aplicaciones que se vayan 
instalando durante el resto del curso
   
* Utiliza saturno u otra opción que se te facilite como equipo secundario 
para almacenar las copias de seguridad. Solicita acceso o la instalación de 
las aplicaciones que sean precisas.

El sistema de copias debe estar operativo para la fecha de entrega, aunque se 
podrán hacer correcciones menores que se detecten a medida que vayan 
ejecutándose las copias. La corrección se realizará la última semana de curso 
y consistirá tanto en la restauración puntual de un fichero en cualquier 
fecha como la restauración completa de una de las máquinas.


Vamos a utilizar Bacula como aplicación para realizar las copias de seguridad.

Bacula es un software libre que permite al administrador de sistemas el manejo
de las copias de seguridad, respaldos y verificación de datos a través de una
red de ordenadores de toda índole.

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
root@sancho:~# apt-get install bacula bacula-client bacula-common-mysql bacula-director-mysql bacula-ser$
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

 PidDirectory --> obligatoria y especifica el directorio en el que el
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

Una vez configurado el Director, ahora vamos a pasar a configurar la tarea que 
realizará las copias de seguridad.

Siempre que se quieran hacer las copias, se ha de seguir el siguiente esquema:

1. Definir el Director.
2. Definir los trabajos. Es notable apuntar que se requerirá uno por cada
máquina de la cual queramos realizar una copia y tipo de copia (diaria, semanal,
mensual, anual, etc)
3. Inclusión y exclusión de ficheros de cada trabajo.
4. Horario del trabajo.
5. Definición de los clientes.
6. Definición de los demonios de almacenamiento.
7. Creación del catálogo (base de datos)
8. Selección del conjunto de volúmenes (Pool) que Bacula usará para el 
guardado de datos.
9. Opciones de la consola.

En primer lugar, pasaremos a la creación de las copias diarias, y después con 
las siguientes:

* Copias diarias

```
Job {
 Name = "Backup-diario-Sancho"
 Client = "sancho-fd"
 Type = Backup
 Level = Incremental
 Pool = "Diaria"
 FileSet = "CopiaSancho"
 Schedule = "Programacion-diaria"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-diario-Quijote"
 Client = "quijote-fd"
 Type = Backup
 Level = Incremental
 Pool = "Diaria"
 FileSet = "CopiaQuijote"
 Schedule = "Programacion-diaria"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-diario-Freston"
 Client = "freston-fd"
 Type = Backup
 Level = Incremental
 Pool = "Diaria"
 FileSet = "CopiaFreston"
 Schedule = "Programacion-diaria"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-diario-Dulcinea"
 Client = "dulcinea-fd"
 Type = Backup
 Level = Incremental
 Pool = "Diaria"
 FileSet = "CopiaDulcinea"
 Schedule = "Programacion-diaria"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}
```

* Copias semanales

```
Job {
 Name = "Backup-semanal-Sancho"
 Client = "sancho-fd"
 Type = Backup
 Level = Full
 Pool = "Semanal"
 FileSet = "CopiaSancho"
 Schedule = "Programacion-semanal"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-semanal-Quijote"
 Client = "quijote-fd"
 Type = Backup
 Level = Full
 Pool = "Semanal"
 FileSet = "CopiaQuijote"
 Schedule = "Programacion-semanal"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-semanal-Freston"
 Client = "freston-fd"
 Type = Backup
 Level = Full
 Pool = "Semanal"
 FileSet = "CopiaFreston"
 Schedule = "Programacion-semanal"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-semanal-Dulcinea"
 Client = "dulcinea-fd"
 Type = Backup
 Level = Full
 Pool = "Semanal"
 FileSet = "CopiaDulcinea"
 Schedule = "Programacion-semanal"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}
```

* Copias mensuales

```
Job {
 Name = "Backup-mensual-Sancho"
 Client = "sancho-fd"
 Type = Backup
 Level = Full
 Pool = "Mensual"
 FileSet = "CopiaSancho"
 Schedule = "Programacion-mensual"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-mensual-Quijote"
 Client = "quijote-fd"
 Type = Backup
 Level = Full
 Pool = "Mensual"
 FileSet = "CopiaQuijote"
 Schedule = "Programacion-mensual"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-mensual-Freston"
 Client = "freston-fd"
 Type = Backup
 Level = Full
 Pool = "Mensual"
 FileSet = "CopiaFreston"
 Schedule = "Programacion-mensual"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
 Name = "Backup-mensual-Dulcinea"
 Type = Backup
 Level = Full
 Pool = "Mensual"
 FileSet = "CopiaDulcinea"
 Schedule = "Programacion-mensual"
 Storage = Vol-Copias
 Messages = Standard
 SpoolAttributes = yes
 Priority = 10
 Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

```

* Restauraciones

```
Job {
 Name = "Restore-Sancho"
 Type = Restore
 Client = sancho-fd
 FileSet = "CopiaSancho"
 Storage = Vol-Copias
 Pool = Default
 Messages = Standard
}

Job {
 Name = "Restore-Quijote"
 Type = Restore
 Client = quijote-fd
 FileSet = "CopiaQuijote"
 Storage = Vol-Copias
 Pool = Default
 Messages = Standard
}

Job {
 Name = "Restore-Freston"
 Type = Restore
 Client = freston-fd
 FileSet = "CopiaFreston"
 Storage = Vol-Copias
 Pool = Default
 Messages = Standard
}

Job {
 Name = "Restore-Dulcinea"
 Type = Restore
 Client = dulcinea-fd
 FileSet = "CopiaDulcinea"
 Storage = Vol-Copias
 Pool = Default
 Messages = Standard
}
```

* Parámetros comunes:

```
FileSet {
 Name = "CopiaSancho"
 Include {
    Options {
        signature = MD5
        compression = GZIP
    }
    File = /home
    File = /etc
    File = /var
    File = /bacula
 }
 Exclude {
    File = /nonexistant/path/to/file/archive/dir
    File = /proc
    File = /var/cache
    File = /var/tmp
    File = /tmp
    File = /sys
    File = /.journal
    File = /.fsck
 }
}

FileSet {
 Name = "CopiaQuijote"
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
    File = /tmp
    File = /sys
    File = /.journal
    File = /.fsck
 }
}

FileSet {
 Name = "CopiaFreston"
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
    File = /var/cache
    File = /var/tmp
    File = /tmp
    File = /sys
    File = /.journal
    File = /.fsck
 }
}

FileSet {
 Name = "CopiaDulcinea"
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
    File = /var/cache
    File = /var/tmp
    File = /tmp
    File = /sys
    File = /.journal
    File = /.fsck
 }
}

Schedule {
 Name = "Programacion-diaria"
 Run = Level=Incremental Pool=Diaria sun-fri at 23:59
}

Schedule {
 Name = "Programacion-semanal"
 Run = Level=Full Pool=Semanal 2nd-5th sat at 23:59
}

Schedule {
 Name = "Programacion-mensual"
 Run = Level=Full Pool=Mensual 1st sat at 23:59
}

Client {
 Name = sancho-fd
 Address = 10.0.1.11
 FDPort = 9102
 Catalog = bacula
 Password = "1q2w3e4r5t"
 File Retention = 90 days
 Job Retention = 6 months
 AutoPrune = yes
}

Client {
 Name = quijote-fd
 Address = 10.0.2.10
 FDPort = 9102
 Catalog = bacula
 Password = "1q2w3e4r5t"
 File Retention = 90 days
 Job Retention = 6 months
 AutoPrune = yes
}

Client {
 Name = freston-fd
 Address = 10.0.1.10
 FDPort = 9102
 Catalog = bacula
 Password = "1q2w3e4r5t"
 File Retention = 90 days
 Job Retention = 6 months
 AutoPrune = yes
}

Client {
 Name = dulcinea-fd
 Address = 10.0.1.4
 FDPort = 9102
 Catalog = bacula
 Password = "1q2w3e4r5t"
 File Retention = 90 days
 Job Retention = 6 months
 AutoPrune = yes
}

Storage {
 Name = Vol-Copias
 Address = 10.0.1.11
 SDPort = 9103
 Password = "1q2w3e4r5t"
 Device = FileAutochanger1
 Media Type = File
 Maximum Concurrent Jobs = 10
}

Catalog {
 Name = bacula
 dbname = "bacula"; DB Address = "localhost";  dbuser = "bacula"; dbpassword = "1q2w3e4r5t"
}

Pool {
 Name = Vol-Backup
 Pool Type = Backup
 Recycle = yes 
 AutoPrune = yes
 Volume Retention = 365 days 
 Maximum Volume Bytes = 50G
 Maximum Volumes = 100
 Label Format = "Remoto"
}

Pool {
 Name = Diaria
 Pool Type = Backup
 Recycle = yes
 AutoPrune = yes
 Volume Retention = 14d
 Maximum Volumes = 10
 Label Format = "Remoto"
}

Pool {
 Name = Semanal
 Use Volume Once = yes
 Pool Type = Backup
 AutoPrune = yes
 VolumeRetention = 30d
 Recycle = yes
}

Pool {
 Name = Mensual
 Use Volume Once = yes
 Pool Type = Backup
 AutoPrune = yes
 VolumeRetention = 365d
 Recycle = yes
}
```

* Por defecto, estas son algunas de las opciones:

```

Messages {
  Name = Standard
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: %t %e of %c %l\" %r"
  operatorcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: Intervention needed for %j\" %r"
  mail = root = all, !skipped
  operator = root = mount
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
  catalog = all
}


Messages {
  Name = Daemon
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula daemon message\" %r"
  mail = root = all, !skipped
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
}


Pool {
  Name = Default
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
  Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
}


Pool {
  Name = Scratch
  Pool Type = Backup
}


Console {
  Name = sancho-mon
  Password = "rPNmB3G7UEOX7ztuXzmvjr08SRH5HJCMT"
  CommandACL = status, .status
}
```

Ahora, comprobamos que una vez escrito el fichero _/etc/bacula/bacula-dir.conf_
está bien su sintaxis:

```
ubuntu@sancho:/etc/bacula$ sudo bacula-dir -tc bacula-dir.conf 
ubuntu@sancho:/etc/bacula$ 
```

Y reiniciamos los servicios de bacula:

```
ubuntu@sancho:/etc/bacula$ sudo service bacula-dir start
ubuntu@sancho:/etc/bacula$ sudo service bacula-sd start
ubuntu@sancho:/etc/bacula$ sudo service bacula-fd start
ubuntu@sancho:/etc/bacula$ 
```

En este punto, vamos a implementar un volumen que servirá como equipo de
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

A continuación, configuramos el fichero llamado _/etc/bacula/bacula-sd.conf_:

```
Director {
  Name = sancho-mon
  Password = "1q2w3e4r5t"
  Monitor = yes
}

Autochanger {
  Name = FileAutochanger1
  Device = Dev1
  Changer Command = ""
  Changer Device = /dev/null
}

Device {
  Name = Dev1
  Media Type = File
  Archive Device = /bacula/backups
  LabelMedia = yes;                   # lets Bacula label unlabeled media
  Random Access = Yes;
  AutomaticMount = yes;               # when device opened, read it
  RemovableMedia = no;
  AlwaysOpen = no;
  Maximum Concurrent Jobs = 5
}

Messages {
  Name = Standard
  director = sancho-dir = all
}
```

Y como hemos hecho anteriormente, vamos a comprobar la sintaxis del fichero:

```
ubuntu@sancho:/etc/bacula$ sudo bacula-sd -tc bacula-sd.conf 
ubuntu@sancho:/etc/bacula$ 
```

Como hemos modificado los ficheros, debemos reiniciar los servicios 
anteriormente iniciados:

```
ubuntu@sancho:/etc/bacula$ sudo systemctl restart bacula-sd.service 
ubuntu@sancho:/etc/bacula$ sudo systemctl restart bacula-director.service 
ubuntu@sancho:/etc/bacula$ 
```

Y comprobamos el funcionamiento de los servicios:

```
ubuntu@sancho:/etc/bacula$ sudo systemctl status bacula-sd.service 
● bacula-sd.service - Bacula Storage Daemon service
     Loaded: loaded (/lib/systemd/system/bacula-sd.service; enabled; vendor pre>
     Active: active (running) since Thu 2021-01-21 17:25:57 UTC; 1min 31s ago
       Docs: man:bacula-sd(8)
    Process: 160382 ExecStartPre=/usr/sbin/bacula-sd -t -c $CONFIG (code=exited>
   Main PID: 160394 (bacula-sd)
      Tasks: 2 (limit: 533)
     Memory: 1.0M
     CGroup: /system.slice/bacula-sd.service
             └─160394 /usr/sbin/bacula-sd -fP -c /etc/bacula/bacula-sd.conf

Jan 21 17:25:57 sancho systemd[1]: Starting Bacula Storage Daemon service...
Jan 21 17:25:57 sancho systemd[1]: Started Bacula Storage Daemon service.
lines 1-13/13 (END)
```

Una vez configurado tanto el el bacula-sd como el director, vamos a 
configurar la consola:

```
Director {
  Name = sancho-dir
  DIRport = 9101
  address = 10.0.1.11
  Password = "1q2w3e4r5t"
}
```

Terminada la configuración en el servidor de Sancho, vamos a configurar el 
fichero _/etc/bacula/bacula-fd.conf_ en cada uno de ellos. Para ello, debemos
instalarnos el paquete bacula-client en cada una de ellas:

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

Y reiniciamos el servicio tanto de _bacula-fd.service_:

```
ubuntu@sancho:/etc/bacula# sudo systemctl restart bacula-fd.service
ubuntu@sancho:/etc/bacula#
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
  FDAddress = 10.0.1.10
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
  FDAddress = 10.0.1.4
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

Comprobamos el funcionamiento de la consola y que Sancho es capaz de 
reconocer a los demás clientes:

```
ubuntu@sancho:~$ sudo bconsole
Connecting to Director 10.0.1.11:9101
1000 OK: 103 sancho-dir Version: 9.4.2 (04 February 2019)
Enter a period to cancel a command.
*status client
The defined Client resources are:
     1: sancho-fd
     2: quijote-fd
     3: freston-fd
     4: dulcinea-fd
Select Client (File daemon) resource (1-4): 1
Connecting to Client sancho-fd at 10.0.1.11:9102

sancho-fd Version: 9.4.2 (04 February 2019)  x86_64-pc-linux-gnu ubuntu 20.04
Daemon started 21-Jan-21 18:12. Jobs: run=0 running=0.
 Heap: heap=110,592 smbytes=22,235 max_bytes=22,252 bufs=69 max_bufs=69
 Sizes: boffset_t=8 size_t=8 debug=0 trace=0 mode=0,0 bwlimit=0kB/s
 Plugin: bpipe-fd.so 

Running Jobs:
Director connected at: 21-Jan-21 18:13
No Jobs running.
====

Terminated Jobs:
 JobId  Level    Files      Bytes   Status   Finished        Name 
===================================================================
     5  Full      6,032    460.8 M  OK       20-Jan-21 23:06 sancho
====
You have messages.
*status client
The defined Client resources are:
     1: sancho-fd
     2: quijote-fd
     3: freston-fd
     4: dulcinea-fd
Select Client (File daemon) resource (1-4): 2
Connecting to Client quijote-fd at 10.0.2.10:9102

quijote-fd Version: 9.0.6 (20 November 2017) x86_64-redhat-linux-gnu redhat (Core)
Daemon started 20-Jan-21 18:28. Jobs: run=1 running=0.
 Heap: heap=135,168 smbytes=178,983 max_bytes=1,009,348 bufs=80 max_bufs=203
 Sizes: boffset_t=8 size_t=8 debug=0 trace=0 mode=0,0 bwlimit=0kB/s

Running Jobs:
Director connected at: 21-Jan-21 18:13
No Jobs running.
====

Terminated Jobs:
 JobId  Level      Files    Bytes   Status   Finished        Name 
===================================================================
     6  Full       3,503    48.09 M  OK       20-Jan-21 23:05 quijote
====
*status client
The defined Client resources are:
     1: sancho-fd
     2: quijote-fd
     3: freston-fd
     4: dulcinea-fd
Select Client (File daemon) resource (1-4): 3
Connecting to Client freston-fd at 10.0.1.10:9102

freston-fd Version: 9.4.2 (04 February 2019)  x86_64-pc-linux-gnu debian 10.5
Daemon started 21-Jan-21 18:11. Jobs: run=0 running=0.
 Heap: heap=114,688 smbytes=21,996 max_bytes=22,013 bufs=68 max_bufs=68
 Sizes: boffset_t=8 size_t=8 debug=0 trace=0 mode=0,0 bwlimit=0kB/s
 Plugin: bpipe-fd.so 

Running Jobs:
Director connected at: 21-Jan-21 18:13
No Jobs running.
====

Terminated Jobs:
====
*status client
The defined Client resources are:
     1: sancho-fd
     2: quijote-fd
     3: freston-fd
     4: dulcinea-fd
4
Connecting to Client dulcinea-fd at 10.0.1.4:9102

dulcinea-fd Version: 9.4.2 (04 February 2019)  x86_64-pc-linux-gnu debian 10.5
Daemon started 21-Jan-21 18:11. Jobs: run=0 running=0.
 Heap: heap=114,688 smbytes=21,998 max_bytes=22,015 bufs=68 max_bufs=68
 Sizes: boffset_t=8 size_t=8 debug=0 trace=0 mode=0,0 bwlimit=0kB/s
 Plugin: bpipe-fd.so 

Running Jobs:
Director connected at: 21-Jan-21 18:13
No Jobs running.
====

Terminated Jobs:
====
*
```

Ahora vamos a añadir la etiqueta al volumen para identificarlo:

```
*label
Automatically selected Catalog: bacula
Using Catalog "bacula"
Automatically selected Storage: Vol-Copias
Enter new Volume name: backups
Defined Pools:
     1: Default
     2: Diaria
     3: File
     4: Mensual
     5: Scratch
     6: Semanal
     7: Vol-Backup
Select the Pool (1-7): 7
Connecting to Storage daemon Vol-Copias at 10.0.1.11:9103 ...
Sending label command for Volume "backups" Slot 0 ...
3000 OK label. VolBytes=220 VolABytes=0 VolType=1 Volume="backups" Device="Dev1" (/bacula/backups)
Catalog record for Volume "backups", Slot 0  successfully created.
Requesting to mount FileAutochanger1 ...
3906 File device ""Dev1" (/bacula/backups)" is always mounted.
*label
Automatically selected Catalog: bacula
Using Catalog "bacula"
Automatically selected Storage: Vol-Copias
copiadiaria
Defined Pools:
     1: Default
     2: Diaria
     3: File
     4: Mensual
     5: Scratch
     6: Semanal
     7: Vol-Backup
Select the Pool (1-7): 2
Connecting to Storage daemon Vol-Copias at 10.0.1.11:9103 ...
Sending label command for Volume "copiadiaria" Slot 0 ...
3000 OK label. VolBytes=220 VolABytes=0 VolType=1 Volume="copiadiaria" Device="Dev1" (/bacula/backups)
Catalog record for Volume "copiadiaria", Slot 0  successfully created.
Requesting to mount FileAutochanger1 ...
3906 File device ""Dev1" (/bacula/backups)" is always mounted.
You have messages.
*label
Automatically selected Storage: Vol-Copias
Enter new Volume name: copiasemanal
Defined Pools:
     1: Default
     2: Diaria
     3: File
     4: Mensual
     5: Scratch
     6: Semanal
     7: Vol-Backup
Select the Pool (1-7): 6
Connecting to Storage daemon Vol-Copias at 10.0.1.11:9103 ...
Sending label command for Volume "copiasemanal" Slot 0 ...
3000 OK label. VolBytes=222 VolABytes=0 VolType=1 Volume="copiasemanal" Device="Dev1" (/bacula/backups)
Catalog record for Volume "copiasemanal", Slot 0  successfully created.
Requesting to mount FileAutochanger1 ...
3906 File device ""Dev1" (/bacula/backups)" is always mounted.
*label
Automatically selected Storage: Vol-Copias
Enter new Volume name: copiamensual
Defined Pools:
     1: Default
     2: Diaria
     3: File
     4: Mensual
     5: Scratch
     6: Semanal
     7: Vol-Backup
Select the Pool (1-7): 4
Connecting to Storage daemon Vol-Copias at 10.0.1.11:9103 ...
Sending label command for Volume "copiamensual" Slot 0 ...
3000 OK label. VolBytes=222 VolABytes=0 VolType=1 Volume="copiamensual" Device="Dev1" (/bacula/backups)
Catalog record for Volume "copiamensual", Slot 0  successfully created.
Requesting to mount FileAutochanger1 ...
3906 File device ""Dev1" (/bacula/backups)" is always mounted.
*
```

Y ahora vamos a realizar una prueba de funcionamiento:

```
ubuntu@sancho:~$ sudo bconsole
Connecting to Director 10.0.1.11:9101
1000 OK: 103 sancho-dir Version: 9.4.2 (04 February 2019)
Enter a period to cancel a command.
*run
Automatically selected Catalog: bacula
Using Catalog "bacula"
A job name must be specified.
The defined Job resources are:
     1: Backup-diario-Sancho
     2: Backup-diario-Quijote
     3: Backup-diario-Freston
     4: Backup-diario-Dulcinea
     5: Backup-semanal-Sancho
     6: Backup-semanal-Quijote
     7: Backup-semanal-Freston
     8: Backup-semanal-Dulcinea
     9: Backup-mensual-Sancho
    10: Backup-mensual-Quijote
    11: Backup-mensual-Freston
    12: Backup-mensual-Dulcinea
    13: Restore-Sancho
    14: Restore-Quijote
    15: Restore-Freston
    16: Restore-Dulcinea
3
Run Backup job
JobName:  Backup-diario-Freston
Level:    Incremental
Client:   freston-fd
FileSet:  CopiaFreston
Pool:     Diaria (From Job resource)
Storage:  Vol-Copias (From Job resource)
When:     2021-01-21 20:06:53
Priority: 10
OK to run? (yes/mod/no): yes
Job queued. JobId=9
You have messages.
*status client
The defined Client resources are:
     1: sancho-fd
     2: quijote-fd
     3: freston-fd
     4: dulcinea-fd
Select Client (File daemon) resource (1-4): 3
Connecting to Client freston-fd at 10.0.1.10:9102

freston-fd Version: 9.4.2 (04 February 2019)  x86_64-pc-linux-gnu debian 10.5
Daemon started 21-Jan-21 18:11. Jobs: run=0 running=0.
 Heap: heap=114,688 smbytes=382,679 max_bytes=405,521 bufs=157 max_bufs=157
 Sizes: boffset_t=8 size_t=8 debug=0 trace=0 mode=0,0 bwlimit=0kB/s
 Plugin: bpipe-fd.so 

Running Jobs:
JobId 9 Job Backup-diario-Freston.2021-01-21_20.07.05_04 is running.
    Full Backup Job started: 21-Jan-21 20:07
    Files=1,672 Bytes=20,153,714 AveBytes/sec=2,239,301 LastBytes/sec=2,239,301 Errors=0
    Bwlimit=0 ReadBytes=80,400,680
    Files: Examined=1,672 Backed up=1,672
    Processing file: /var/lib/dpkg/info/libhogweed4:amd64.triggers
    SDReadSeqNo=6 fd=6 SDtls=0
Director connected at: 21-Jan-21 20:07
====

Terminated Jobs:
====
*
```

Más comprobaciones:

```
*run
A job name must be specified.
The defined Job resources are:
     1: Backup-diario-Sancho
     2: Backup-diario-Quijote
     3: Backup-diario-Freston
     4: Backup-diario-Dulcinea
     5: Backup-semanal-Sancho
     6: Backup-semanal-Quijote
     7: Backup-semanal-Freston
     8: Backup-semanal-Dulcinea
     9: Backup-mensual-Sancho
    10: Backup-mensual-Quijote
    11: Backup-mensual-Freston
    12: Backup-mensual-Dulcinea
    13: Restore-Sancho
    14: Restore-Quijote
    15: Restore-Freston
    16: Restore-Dulcinea
Select Job resource (1-16): 5
Run Backup job
JobName:  Backup-semanal-Sancho
Level:    Full
Client:   sancho-fd
FileSet:  CopiaSancho
Pool:     Semanal (From Job resource)
Storage:  Vol-Copias (From Job resource)
When:     2021-01-21 20:43:59
Priority: 10
OK to run? (yes/mod/no): yes
Job queued. JobId=10
*run
A job name must be specified.
The defined Job resources are:
     1: Backup-diario-Sancho
     2: Backup-diario-Quijote
     3: Backup-diario-Freston
     4: Backup-diario-Dulcinea
     5: Backup-semanal-Sancho
     6: Backup-semanal-Quijote
     7: Backup-semanal-Freston
     8: Backup-semanal-Dulcinea
     9: Backup-mensual-Sancho
    10: Backup-mensual-Quijote
    11: Backup-mensual-Freston
    12: Backup-mensual-Dulcinea
    13: Restore-Sancho
    14: Restore-Quijote
    15: Restore-Freston
    16: Restore-Dulcinea
Select Job resource (1-16): 10
Run Backup job
JobName:  Backup-mensual-Quijote
Level:    Full
Client:   quijote-fd
FileSet:  CopiaQuijote
Pool:     Mensual (From Job resource)
Storage:  Vol-Copias (From Job resource)
When:     2021-01-21 20:44:21
Priority: 10
OK to run? (yes/mod/no): yes
Job queued. JobId=11
```


