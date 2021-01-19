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
  Password = "iRv9TT0EVQar3RYLwGM4QgKM0aPJUYIh0"         # Console password
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




* El proceso debe realizarse de forma completamente automática
   
* Selecciona qué información es necesaria guardar (listado de paquetes, 
ficheros de configuración, documentos, datos, etc.)

   
* Realiza semanalmente una copia completa
   
* Realiza diariamente una copia incremental, diferencial o delta diferencial 
(decidir cual es más adecuada)
   
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

El sistema de copias debe estar operativo para la fecha de entrega, aunque se 
podrán hacer correcciones menores que se detecten a medida que vayan 
ejecutándose las copias. La corrección se realizará la última semana de curso 
y consistirá tanto en la restauración puntual de un fichero en cualquier 
fecha como la restauración completa de una de las máquinas.
