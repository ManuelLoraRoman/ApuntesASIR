# Tareas LDAP

## Instalación y configuración inicial de OpenLDAP

Realiza la instalación y configuración básica de OpenLDAP en frestón utilizando 
como base el nombre DNS asignado. 

Crea dos unidades organizativas, una para personas y otra para grupos.

En primer lugar, nos dirigimos hacia nuestra máquina Freston. Una vez ahí, nos
instalaremos el paquete _slapd_ y el paquete _ldap-utils_:

```
root@freston:/home/debian# sudo apt-get install  slapd ldap-utils
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  libgdbm-compat4 libgdbm6 libldap-2.4-2 libldap-common libltdl7 libodbc1
  libperl5.28 libsasl2-2 libsasl2-modules libsasl2-modules-db perl
  perl-modules-5.28 psmisc
Suggested packages:
  libsasl2-modules-gssapi-mit | libsasl2-modules-gssapi-heimdal libmyodbc
  odbc-postgresql tdsodbc unixodbc-bin libsasl2-modules-ldap
  libsasl2-modules-otp libsasl2-modules-sql perl-doc libterm-readline-gnu-perl
  | libterm-readline-perl-perl make libb-debug-perl liblocale-codes-perl
The following NEW packages will be installed:
  ldap-utils libgdbm-compat4 libgdbm6 libldap-2.4-2 libldap-common libltdl7
  libodbc1 libperl5.28 libsasl2-2 libsasl2-modules libsasl2-modules-db perl
  perl-modules-5.28 psmisc slapd
0 upgraded, 15 newly installed, 0 to remove and 19 not upgraded.
Need to get 10.0 MB of archives.
After this operation, 66.7 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://deb.debian.org/debian buster/main amd64 perl-modules-5.28 all 5.28.1-6+deb10u1 [2,873 kB]
Get:2 http://deb.debian.org/debian buster/main amd64 libgdbm6 amd64 1.18.1-4 [64.7 kB]
Get:3 http://deb.debian.org/debian buster/main amd64 libgdbm-compat4 amd64 1.18.1-4 [44.1 kB]
Get:4 http://deb.debian.org/debian buster/main amd64 libperl5.28 amd64 5.28.1-6+deb10u1 [3,894 kB]
Get:5 http://deb.debian.org/debian buster/main amd64 perl amd64 5.28.1-6+deb10u1 [204 kB]
Get:6 http://deb.debian.org/debian buster/main amd64 libsasl2-modules-db amd64 2.1.27+dfsg-1+deb10u1 [69.1 kB]
Get:7 http://deb.debian.org/debian buster/main amd64 libsasl2-2 amd64 2.1.27+dfsg-1+deb10u1 [106 kB]
Get:8 http://deb.debian.org/debian buster/main amd64 libldap-common all 2.4.47+dfsg-3+deb10u4 [89.8 kB]
Get:9 http://deb.debian.org/debian buster/main amd64 libldap-2.4-2 amd64 2.4.47+dfsg-3+deb10u4 [224 kB]
Get:10 http://deb.debian.org/debian buster/main amd64 libltdl7 amd64 2.4.6-9 [390 kB]
Get:11 http://deb.debian.org/debian buster/main amd64 libodbc1 amd64 2.3.6-0.1 [223 kB]
Get:12 http://deb.debian.org/debian buster/main amd64 psmisc amd64 23.2-1 [126 kB]
Get:13 http://deb.debian.org/debian buster/main amd64 slapd amd64 2.4.47+dfsg-3+deb10u4 [1,437 kB]
Get:14 http://deb.debian.org/debian buster/main amd64 ldap-utils amd64 2.4.47+dfsg-3+deb10u4 [198 kB]
Get:15 http://deb.debian.org/debian buster/main amd64 libsasl2-modules amd64 2.1.27+dfsg-1+deb10u1 [104 kB]
Fetched 10.0 MB in 3s (3,256 kB/s)     
Preconfiguring packages ...
Selecting previously unselected package perl-modules-5.28.
(Reading database ... 27036 files and directories currently installed.)
Preparing to unpack .../00-perl-modules-5.28_5.28.1-6+deb10u1_all.deb ...
Unpacking perl-modules-5.28 (5.28.1-6+deb10u1) ...
Selecting previously unselected package libgdbm6:amd64.
Preparing to unpack .../01-libgdbm6_1.18.1-4_amd64.deb ...
Unpacking libgdbm6:amd64 (1.18.1-4) ...
Selecting previously unselected package libgdbm-compat4:amd64.
Preparing to unpack .../02-libgdbm-compat4_1.18.1-4_amd64.deb ...
Unpacking libgdbm-compat4:amd64 (1.18.1-4) ...
Selecting previously unselected package libperl5.28:amd64.
Preparing to unpack .../03-libperl5.28_5.28.1-6+deb10u1_amd64.deb ...
Unpacking libperl5.28:amd64 (5.28.1-6+deb10u1) ...
Selecting previously unselected package perl.
Preparing to unpack .../04-perl_5.28.1-6+deb10u1_amd64.deb ...
Unpacking perl (5.28.1-6+deb10u1) ...
Selecting previously unselected package libsasl2-modules-db:amd64.
Preparing to unpack .../05-libsasl2-modules-db_2.1.27+dfsg-1+deb10u1_amd64.deb ...
Unpacking libsasl2-modules-db:amd64 (2.1.27+dfsg-1+deb10u1) ...
Selecting previously unselected package libsasl2-2:amd64.
Preparing to unpack .../06-libsasl2-2_2.1.27+dfsg-1+deb10u1_amd64.deb ...
Unpacking libsasl2-2:amd64 (2.1.27+dfsg-1+deb10u1) ...
Selecting previously unselected package libldap-common.
Preparing to unpack .../07-libldap-common_2.4.47+dfsg-3+deb10u4_all.deb ...
Unpacking libldap-common (2.4.47+dfsg-3+deb10u4) ...
Selecting previously unselected package libldap-2.4-2:amd64.
Preparing to unpack .../08-libldap-2.4-2_2.4.47+dfsg-3+deb10u4_amd64.deb ...
Unpacking libldap-2.4-2:amd64 (2.4.47+dfsg-3+deb10u4) ...
Selecting previously unselected package libltdl7:amd64.
Preparing to unpack .../09-libltdl7_2.4.6-9_amd64.deb ...
Unpacking libltdl7:amd64 (2.4.6-9) ...
Selecting previously unselected package libodbc1:amd64.
Preparing to unpack .../10-libodbc1_2.3.6-0.1_amd64.deb ...
Unpacking libodbc1:amd64 (2.3.6-0.1) ...
Selecting previously unselected package psmisc.
Preparing to unpack .../11-psmisc_23.2-1_amd64.deb ...
Unpacking psmisc (23.2-1) ...
Selecting previously unselected package slapd.
Preparing to unpack .../12-slapd_2.4.47+dfsg-3+deb10u4_amd64.deb ...
Unpacking slapd (2.4.47+dfsg-3+deb10u4) ...
Selecting previously unselected package ldap-utils.
Preparing to unpack .../13-ldap-utils_2.4.47+dfsg-3+deb10u4_amd64.deb ...
Unpacking ldap-utils (2.4.47+dfsg-3+deb10u4) ...
Selecting previously unselected package libsasl2-modules:amd64.
Preparing to unpack .../14-libsasl2-modules_2.1.27+dfsg-1+deb10u1_amd64.deb ...
Unpacking libsasl2-modules:amd64 (2.1.27+dfsg-1+deb10u1) ...
Setting up perl-modules-5.28 (5.28.1-6+deb10u1) ...
Setting up psmisc (23.2-1) ...
Setting up libsasl2-modules:amd64 (2.1.27+dfsg-1+deb10u1) ...
Setting up libldap-common (2.4.47+dfsg-3+deb10u4) ...
Setting up libsasl2-modules-db:amd64 (2.1.27+dfsg-1+deb10u1) ...
Setting up libltdl7:amd64 (2.4.6-9) ...
Setting up libsasl2-2:amd64 (2.1.27+dfsg-1+deb10u1) ...
Setting up libgdbm6:amd64 (1.18.1-4) ...
Setting up libldap-2.4-2:amd64 (2.4.47+dfsg-3+deb10u4) ...
Setting up ldap-utils (2.4.47+dfsg-3+deb10u4) ...
Setting up libgdbm-compat4:amd64 (1.18.1-4) ...
Setting up libodbc1:amd64 (2.3.6-0.1) ...
Setting up libperl5.28:amd64 (5.28.1-6+deb10u1) ...
Setting up perl (5.28.1-6+deb10u1) ...
Setting up slapd (2.4.47+dfsg-3+deb10u4) ...
  Creating new user openldap... done.
  Creating initial configuration... done.
  Creating LDAP directory... done.
Processing triggers for systemd (241-7~deb10u4) ...
Processing triggers for libc-bin (2.28-10) ...
```

Comprobamos y vemos las primeras entradas:

```
root@freston:/home/debian# sudo slapcat
dn: dc=novalocal
objectClass: top
objectClass: dcObject
objectClass: organization
o: novalocal
dc: novalocal
structuralObjectClass: organization
entryUUID: 0634d07a-d0e7-103a-95c8-6da9ba216f26
creatorsName: cn=admin,dc=novalocal
createTimestamp: 20201212165838Z
entryCSN: 20201212165838.436412Z#000000#000#000000
modifiersName: cn=admin,dc=novalocal
modifyTimestamp: 20201212165838Z

dn: cn=admin,dc=novalocal
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9NmgwQ2x4andNaXArYUZqay9RUjBXYmQwU1MwcTY5VFg=
structuralObjectClass: organizationalRole
entryUUID: 0635f3a6-d0e7-103a-95c9-6da9ba216f26
creatorsName: cn=admin,dc=novalocal
createTimestamp: 20201212165838Z
entryCSN: 20201212165838.443981Z#000000#000#000000
modifiersName: cn=admin,dc=novalocal
modifyTimestamp: 20201212165838Z
```


Ahora haremos la configuración inicial. Ejecutamos el siguiente comando;

```
root@freston:/home/debian# dpkg-reconfigure -plow slapd
  Backing up /etc/ldap/slapd.d in /var/backups/slapd-2.4.47+dfsg-3+deb10u4... done.
  Moving old database directory to /var/backups:
  - directory unknown... done.
  Creating initial configuration... done.
  Creating LDAP directory... done.
```

```

 ┌───────────────────────────┤ Configuring slapd ├───────────────────────────┐
 │                                                                           │ 
 │ If you enable this option, no initial configuration or database will be   │ 
 │ created for you.                                                          │ 
 │                                                                           │ 
 │ Omit OpenLDAP server configuration?                                       │ 
 │                                                                           │ 
 │                    <Yes>                       <No>                       │ 
 │                                                                           │ 
 └───────────────────────────────────────────────────────────────────────────┘ 
                                                                               
```

Seleccionamos la opción no y continuamos:

```
┌───────────────────────────┤ Configuring slapd ├───────────────────────────┐
 │ The DNS domain name is used to construct the base DN of the LDAP          │ 
 │ directory. For example, 'foo.example.org' will create the directory with  │ 
 │ 'dc=foo, dc=example, dc=org' as base DN.                                  │ 
 │                                                                           │ 
 │ DNS domain name:                                                          │ 
 │                                                                           │ 
 │ manuel.gonzalonazareno.org_______________________________________________ │ 
 │                                                                           │ 
 │                                  <Ok>                                     │ 
 │                                                                           │ 
 └───────────────────────────────────────────────────────────────────────────┘ 
```

Después nos pedirá el nombre de nuestra organización:

```
┌───────────────────────────┤ Configuring slapd ├───────────────────────────┐
 │ Please enter the name of the organization to use in the base DN of your   │ 
 │ LDAP directory.                                                           │ 
 │                                                                           │ 
 │ Organization name:                                                        │ 
 │                                                                           │ 
 │ IES Gonzalo Nazareno_____________________________________________________ │ 
 │                                                                           │ 
 │                                  <Ok>                                     │ 
 │                                                                           │ 
 └───────────────────────────────────────────────────────────────────────────┘ 
```

Nos pedirá nuestra contraseña de administrador, y a continuación, debemos
elegir nuestro motor de base de datos. Elegiremos MDB ya que es la que viene
por defecto:

```
┌───────────────────────────┤ Configuring slapd ├───────────────────────────┐
 │ HDB and BDB use similar storage formats, but HDB adds support for         │ 
 │ subtree renames. Both support the same configuration options.             │ 
 │                                                                           │ 
 │ The MDB backend is recommended. MDB uses a new storage format and         │ 
 │ requires less configuration than BDB or HDB.                              │ 
 │                                                                           │ 
 │ In any case, you should review the resulting database configuration for   │ 
 │ your needs. See /usr/share/doc/slapd/README.Debian.gz for more details.   │ 
 │                                                                           │ 
 │ Database backend to use:                                                  │ 
 │                                                                           │ 
 │                                   BDB                                     │ 
 │                                   HDB                                     │ 
 │                                   MDB                                     │ 
 │                                                                           │ 
 │                                                                           │ 
 │                                  <Ok>                                     │ 
 │                                                                           │ 
 └───────────────────────────────────────────────────────────────────────────┘ 
```

Después, nos preguntará si deseamos eliminar slapd de la base de datos. 
Seleccionamos no y continuamos:

```
       ┌─────────────────────┤ Configuring slapd ├─────────────────────┐
       │                                                               │ 
       │                                                               │ 
       │                                                               │ 
       │ Do you want the database to be removed when slapd is purged?  │ 
       │                                                               │ 
       │                <Yes>                   <No>                   │ 
       │                                                               │ 
       └───────────────────────────────────────────────────────────────┘ 
```

Nos pregunta si queremos dejar el antiguo directorio. Como opción por defecto,
dejamos la opción sí.

```
 ┌───────────────────────────┤ Configuring slapd ├───────────────────────────┐
 │                                                                           │ 
 │ There are still files in /var/lib/ldap which will probably break the      │ 
 │ configuration process. If you enable this option, the maintainer scripts  │ 
 │ will move the old database files out of the way before creating a new     │ 
 │ database.                                                                 │ 
 │                                                                           │ 
 │ Move old database?                                                        │ 
 │                                                                           │ 
 │                    <Yes>                       <No>                       │ 
 │                                                                           │ 
 └───────────────────────────────────────────────────────────────────────────┘ 

```

Ahora comprobamos que los cambios se han realizado:

```
root@freston:/home/debian# sudo slapcat
dn: dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: dcObject
objectClass: organization
o: IES Gonzalo Nazareno
dc: manuel
structuralObjectClass: organization
entryUUID: 588a6cf2-d0e9-103a-95ce-4f937b895d18
creatorsName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
createTimestamp: 20201212171515Z
entryCSN: 20201212171515.564118Z#000000#000#000000
modifiersName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
modifyTimestamp: 20201212171515Z

dn: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9QVhGSVZ0QnpnSUluWGl3cC8ydTFINmFTQTAvUm1tdkc=
structuralObjectClass: organizationalRole
entryUUID: 588bc67e-d0e9-103a-95cf-4f937b895d18
creatorsName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
createTimestamp: 20201212171515Z
entryCSN: 20201212171515.573064Z#000000#000#000000
modifiersName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
modifyTimestamp: 20201212171515Z
```

Ahora para crear las unidades organizativas personas y grupos, tenemos que 
hacer dos ficheros .ldif. Para personas usaremos el siguiente:

* personas.ldif

```
dn: uid=manuel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: person
cn:: TWFudWVsIExvcmEgUm9tw6FuCg==
uid: manuel
uidNumber: 2001
gidNumber: 2000
homeDirectory: /home/manuel
loginShell: /bin/bash
userPassword: {SSHA}cvi49lEQ9OPcX6iMfW6m3wMlUVkd69EB
sn:: TG9yYSBSb23DoW4K
mail: manuelloraroman@gmail.com
givenName: manuel
```

Y para el fichero de grupos:

* grupos.ldif

```
dn: cn=Usuarios,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixGroup
gidNumber: 2000
cn: Usuarios
```

Y ahora, por último, creamos el fichero unidades_organizativas.ldif que
contiene las siguientes líneas:

```
dn: ou=People,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalUnit
ou: People
```

Teniendo estos tres ficheros, seguimos los siguientes pasos:

1. En primer lugar, añadimos las unidades organizativas con el fichero
unidades_organizativas.ldif:

```
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=manuel,dc=gonzalonazareno,dc=org -W -f unidades_organizativas.ldif 
Enter LDAP Password: 
adding new entry "ou=People,dc=manuel,dc=gonzalonazareno,dc=org"
```

2. Agregamos a continuación los grupos con el fichero grupos.ldif:

```
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=manuel,dc=gonzalonazareno,dc=org -W -f grupos.ldif 
Enter LDAP Password: 
adding new entry "cn=Usuarios,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"
```

3. Añadimos a las personas con el fichero personas.ldif:

```
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=manuel,dc=gonzalonazareno,dc=org -W -f personas.ldif 
Enter LDAP Password: 
adding new entry "uid=manuel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"
```

Ahora comprobamos los cambios realizados:

```
root@freston:/home/debian# sudo slapcat
dn: dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: dcObject
objectClass: organization
o: IES Gonzalo Nazareno
dc: manuel
structuralObjectClass: organization
entryUUID: 588a6cf2-d0e9-103a-95ce-4f937b895d18
creatorsName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
createTimestamp: 20201212171515Z
entryCSN: 20201212171515.564118Z#000000#000#000000
modifiersName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
modifyTimestamp: 20201212171515Z

dn: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9QVhGSVZ0QnpnSUluWGl3cC8ydTFINmFTQTAvUm1tdkc=
structuralObjectClass: organizationalRole
entryUUID: 588bc67e-d0e9-103a-95cf-4f937b895d18
creatorsName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
createTimestamp: 20201212171515Z
entryCSN: 20201212171515.573064Z#000000#000#000000
modifiersName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
modifyTimestamp: 20201212171515Z

dn: ou=People,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalUnit
ou: People
structuralObjectClass: organizationalUnit
entryUUID: cd072c48-d0ec-103a-8638-038e96acb944
creatorsName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
createTimestamp: 20201212173959Z
entryCSN: 20201212173959.487625Z#000000#000#000000
modifiersName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
modifyTimestamp: 20201212173959Z

dn: cn=Usuarios,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixGroup
gidNumber: 2000
cn: Usuarios
structuralObjectClass: posixGroup
entryUUID: fd55cf9e-d0ec-103a-8639-038e96acb944
creatorsName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
createTimestamp: 20201212174120Z
entryCSN: 20201212174120.533653Z#000000#000#000000
modifiersName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
modifyTimestamp: 20201212174120Z

dn: uid=manuel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: person
cn:: TWFudWVsIExvcmEgUm9tw6FuCg==
uid: manuel
uidNumber: 2001
gidNumber: 2000
homeDirectory: /home/manuel
loginShell: /bin/bash
userPassword:: e1NTSEF9Y3ZpNDlsRVE5T1BjWDZpTWZXNm0zd01sVVZrZDY5RUI=
sn:: TG9yYSBSb23DoW4K
mail: manuelloraroman@gmail.com
givenName: manuel
structuralObjectClass: inetOrgPerson
entryUUID: 360560a2-d0ed-103a-863a-038e96acb944
creatorsName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
createTimestamp: 20201212174255Z
entryCSN: 20201212174255.636657Z#000000#000#000000
modifiersName: cn=admin,dc=manuel,dc=gonzalonazareno,dc=org
modifyTimestamp: 20201212174255Z
```
