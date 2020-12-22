# Configurar LDAP en alta disponibilidad

Vamos a instalar un servidor LDAP en sancho que va a actuar como servidor 
secundario o de respaldo del servidor LDAP instalado en frestón, para ello 
habrá que seleccionar un modo de funcionamiento y configurar la sincronización 
entre ambos directorios, para que los cambios que se realicen en uno de ellos 
se reflejen en el otro.

* Selecciona el método más adecuado para configurar un servidor LDAP 
secundario, viendo y/o probando las opciones posibles.

El método que usaremos será el _MirrorMode_, ya que nos permitirá la
escritura de directorio con total seguridad mientras el LDAP master 
(Freston) este operativo.
   
* Explica claramente las características, ventajas y limitaciones del método 
seleccionado.

Una característica es que los nodos maestros se replican entre si para que 
estén siempre actualizados y así poder estar listos para hacerse cargo de 
cualquier tipo de carga de información o consulta de la misma.

Algunas de las ventajas son : siempre se tiene un proveedor operativo, las
escrituras se pueden hacer de forma segura y siempre están actualizados los
nodos. Por otro lado, permiten que los nodos proveedores se vuelvan a 
sincronizar después de cualquier tiempo de inactividad.

La desventajas serían: no es una solución Multi-master (método de replicación
de base de datos donde se habilitan los datos para ser distribuidos en un
grupo, actualizado por cualquier miembro del mismo), ya que las escrituras
solo pueden ir a un nodo al mismo tiempo. Por esto mismo, se requiere de un
servidor externo (slapd en modo proxy) o un dispositivo (hardware load 
balancer) para administrar que proveedor está activo actualmente.
  
* Realiza las configuraciones adecuadas en el directorio cn=config.

Debemos instalarnos el paquete slapd y ldap-utils como hicimos en la máquina
freston. Una vez instalado, modificaremos la configuración de ldap de 
ambas máquinas para que estén direccionando hacia sí mismas:

* _/etc/ldap/ldap.conf_ de freston:

```
BASE    dc=manuel-lora,dc=gonzalonazareno,dc=org
URI     ldap://freston.manuel-lora.gonzalonazareno.org
```
   
* _/etc/ldap/ldap.conf_ de sancho:

```
BASE    dc=manuel-lora,dc=gonzalonazareno,dc=org
URI     ldap://sancho.manuel-lora.gonzalonazareno.org
```

Ahora seguiremos configurando los parámetros de configuración del LDAP
principal (Freston). Dichos parámetros, como en los ejercicios anteriores,
los modificaremos usando los ficheros _.ldif_. 

Empezamos creando un usuario que será el encargado de poder realizar el modo
mirrormode. Creamos el fichero mirror.ldif:

```
dn: uid=mirrormode,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: account
objectClass: simpleSecurityObject
description: LDAP replication user
userPassword: 1q2w3e4r5t
```

Y lo cargamos en LDAP:

```
debian@freston:~/openldap$ sudo ldapadd -x -D cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org -W -f mirror.ldif 
Enter LDAP Password: 
adding new entry "uid=mirrormode,dc=manuel-lora,dc=gonzalonazareno,dc=org"

```

También, creamos otro fichero que dará los permisos al usuario que hemos creado:

```
 dn: olcDatabase={1}mdb,cn=config
 2 changetype: modify
 3 add: olcAccess
 4 olcAccess: to attrs=userPassword
 5   by self =xw
 6   by dn.exact="cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org" =xw
 7   by dn.exact="uid=mirrormode,dc=manuel-lora,dc=gonzalonazareno,dc=org" read
 8   by anonymous auth
 9   by * none
10 olcAccess: to *
11   by anonymous auth
12   by self write
13   by dn.exact="uid=mirrormode,dc=manuel-lora,dc=gonzalonazareno,dc=org" read
14   by users read
15   by * none
```

Y lo introducimos para que se modifiquen los atributos:

```
debian@freston:~/openldap$ sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f permirror.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={1}mdb,cn=config"
```

Ahora, creamos otros dos ficheros. El primero de ellos servirá para cargar el 
módulo syncprov, y el otro para añadirlo a LDAP:

* syncprov.ldif

```
dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: syncprov
```

* syncldap.ldif

```
dn: olcOverlay=syncprov,olcDatabase={1}mdb,cn=config
objectClass: olcSyncProvConfig
olcOverlay: syncprov
olcSpCheckpoint: 100 10
```

Y añadimos ambos ficheros a LDAP:

```
debian@freston:~/openldap$ sudo ldapadd -Y EXTERNAL -H ldapi:/// -f syncprov.ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "cn=module{0},cn=config"

debian@freston:~/openldap$ sudo ldapadd -Y EXTERNAL -H ldapi:/// -f syncldap.ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "olcOverlay=syncprov,olcDatabase={1}mdb,cn=config"
```

Seguidamente, vamos a proceder a añadir el número identificativo del servidor:

```
dn: cn=config
changetype: modify
add: olcServerId
olcServerId: 1
```

Y lo volvemos a añadir en LDAP:

```
debian@freston:~/openldap$ sudo ldapadd -Y EXTERNAL -H ldapi:/// -f numserver.ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "cn=config"
```

Y por último, habilitaremos la replicación en Freston indicando Sancho:

```
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcSyncrepl
olcsyncrepl: rid=000
  provider=ldap://sancho.manuel-lora.gonzalonazareno.org
  type=refreshAndPersist
  retry="5 5 300 +"
  searchbase="dc=manuel-lora,dc=gonzalonazareno,dc=org"
  attrs="*,+"
  bindmethod=simple
  binddn="uid=mirrormode,dc=manuel-lora,dc=gonzalonazareno,dc=org"
  credentials=1q2w3e4r5t
-
add: olcDbIndex
olcDbIndex: entryUUID eq
olcDbIndex: entryCSN eq
-
replace: olcMirrorMode
olcMirrorMode: TRUE
```

Y lo añadimos:

```
debian@freston:~/openldap$ sudo ldapadd -Y EXTERNAL -H ldapi:/// -f repl.ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={1}mdb,cn=config"
```

Y hasta aquí la configuración del LDAP maestro Freston. Ahora pasaremos
a la configuración de Sancho. Previamente hemos instalado el paquete 
slapd y ldap-utils.

Una vez instalado, tenemos que ejecutar el comando ```dpkg-reconfigure slapd```
para definir los parámetros que queramos.

Siguiendo con la configuración, realizaremos la misma configuración que hemos
realizado en Freston salvo en los siguientes casos:

* El fichero que añade el número identificativo del server será esta vez el nº2.

```
dn: cn=config
changetype: modify
add: olcServerId
olcServerId: 2
```

* En el fichero de replicación del servidor incorporaremos a Freston esta vez:

```
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcSyncrepl
olcsyncrepl: rid=000
  provider=ldaps://freston.manuel-lora.gonzalonazareno.org
  type=refreshAndPersist
  retry="5 5 300 +"
  searchbase="dc=manuel-lora,dc=gonzalonazareno,dc=org"
  attrs="*,+"
  bindmethod=simple
  binddn="uid=mirrormode,dc=manuel-lora,dc=gonzalonazareno,dc=org"
  credentials=1q2w3e4r5t
-
add: olcDbIndex
olcDbIndex: entryUUID eq
olcDbIndex: entryCSN eq
-
replace: olcMirrorMode
olcMirrorMode: TRUE
```

* Como prueba de funcionamiento, prepara un pequeño fichero ldif, que se 
insertará en el directorio en la corrección y se verificará que se ha 
sincronizado.

Para la comprobación, vamos a crear un fichero usuarioAD.ldif que
añadirá un usuario en LDAP de Sancho y comprobaremos que se haya replicado en
la otra máquina:

```
dn: uid=josedom,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: person
cn:: am9zZWRvbQo=
uid: josedom
uidNumber: 2020
gidNumber: 2520
homeDirectory: /home/josedom
loginShell: /bin/bash
userPassword: MXEydzNlNHI1dAo=
sn:: ZG9tCg==
mail: josedom@gmail.com
givenName: josedom
```

```
ubuntu@sancho:~/openldap$ sudo ldapadd -x -D cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org -W -f usuarioAD.ldif 
Enter LDAP Password: 
adding new entry "uid=josedom,dc=manuel-lora,dc=gonzalonazareno,dc=org"
```

Y comprobamos en freston que efectivamente se ha replicado:

```
debian@freston:~$ sudo ldapsearch -x -b "dc=manuel-lora,dc=gonzalonazareno,dc=org" | grep josedom
# josedom, manuel-lora.gonzalonazareno.org
dn: uid=josedom,dc=manuel-lora,dc=gonzalonazareno,dc=org
uid: josedom
homeDirectory: /home/josedom
mail: josedom@gmail.com
givenName: josedom
```

