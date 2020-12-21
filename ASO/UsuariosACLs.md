# Usuarios, grupos y ACLs en LDAP

1. Crea 10 usuarios con los nombres que prefieras en LDAP, esos usuarios deben 
ser objetos de los tipos posixAccount e inetOrgPerson. Estos usuarios tendrán 
un atributo userPassword.

En primer lugar, debemos saber que los atributos obligatorios del objectClass
posixAccount son:

> cn, uid, uidNumber, gidNumber, homeDirectory

El atributo _userPassword_ no es obligatorio.

El objectClass inetOrgPerson no tiene atributos obligatorios.

Aprovecharemos la unidad organizativa creada en la práctica anterior para 
realizar parte de este ejercicio.

Crearemos un fichero llamado usuarios.ldif, que contendrá la información de
los diferentes usuarios:

```
dn: uid=manuel,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: person
cn:: TWFudWVsIExvcmEgUm9tw6FuCg==
uid: manuel
uidNumber: 2001
gidNumber: 2500
homeDirectory: /home/manuel
loginShell: /bin/bash
userPassword:: {SSHA}R1KeFc7CI0TScCwdyQFMIEIutcEknB1F
sn:: TG9yYSBSb23DoW4K
mail: manuelloraroman@gmail.com
givenName: manuel

dn: uid=maria,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: person
cn:: TWFyaWEgZGVsIENhcm1lbiBMb3JhIFJvbcOhbgo=
uid: maria
uidNumber: 2002
gidNumber: 2502
homeDirectory: /home/maria
loginShell: /bin/bash
userPassword:: {SSHA}OuK8ryroLXs+fpudBXcJrMTZ3ASD/H46
sn:: TG9yYSBSb23DoW4K
mail: marialoraroman@gmail.com
givenName: maria

dn: uid=rosaura,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: Um9zYXVyYSBIYWJhIFBlcmVhCg==
uid: rosaura
uidNumber: 2003
gidNumber: 2503
homeDirectory: /home/rosaura
loginShell: /bin/bash
userPassword: {SSHA}sgJUlNb20SdYbUclyXQNFCe0tjjdijdS
sn: SGFiYSBQZXJlYQo=
mail: rosaurahabaperea@gmail.com
givenName: rosaura

dn: uid=laura,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: TGF1cmEgTW9yYWxlcyBDYWJlbGxvCg==
uid: laura
uidNumber: 2004
gidNumber: 2504
homeDirectory: /home/laura
loginShell: /bin/bash
userPassword: {SSHA}bZ1BzoZWQGN25d5ecDzOVfaSi35h7/Dq
sn: TW9yYWxlcyBDYWJlbGxvCg==
mail: lauramoralescabello@gmail.com
givenName: laura

dn: uid=pablo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: UGFibG8gU3VzbyBHb256YWxlego=
uid: pablo
uidNumber: 2005
gidNumber: 2505
homeDirectory: /home/pablo
loginShell: /bin/bash
userPassword: {SSHA}1Dmh5fQgowk0Cvfzje4B71kC1SmeiIqi
sn: U3VzbyBHb256YWxlego=
mail: pablosusogonzalex@gmail.com
givenName: pablo

dn: uid=arturo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: QXJ0dXJvIEJvcnJlcm8gR29uemFsZXoK
uid: arturo
uidNumber: 2006
gidNumber: 2506
homeDirectory: /home/arturo  
loginShell: /bin/bash
userPassword: {SSHA}RoA4bctGSRG537NslZYSifHAmzf0DWTv
sn: Qm9ycmVybyBHb256YWxlego=
mail: arturo@debian.org
givenName: arturo

dn: uid=diego,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: RGllZ28gTG9zYWRhIEZ1ZW50ZXMK
uid: diego
uidNumber: 2007
gidNumber: 2507
homeDirectory: /home/diego
loginShell: /bin/bash
userPassword: {SSHA}pclPYfaM0zvJos+h86gu+bx//Q+UULyj
sn: TG9zYWRhIEZ1ZW50ZXMK
mail: dlosadafuentes@gmail.com
givenName: diego

dn: uid=isabel,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: SXNhYmVsIE1vcmFsZXMgQ2FiZWxsbwo=
uid: isabel
uidNumber: 2008
gidNumber: 2508
homeDirectory: /home/isabel
loginShell: /bin/bash
userPassword: {SSHA}cBES958lKSd7Trpj7Yrah5yHfX4Ikl/e
sn: TW9yYWxlcyBDYWJlbGxvCg==
mail: isabelmoralescabello@gmail.com
givenName: isabel

dn: uid=alberto,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: QWxiZXJ0byBDb3Jkb24gQXJldmFsbwo=
uid: alberto
uidNumber: 2009
gidNumber: 2509
homeDirectory: /home/alberto
loginShell: /bin/bash
userPassword: {SSHA}GMTZonB3W7TcL9D0BEVfO7Z6xUVKbir8
sn: Q29yZG9uIEFyZXZhbG8K
mail: albertocordonarevalo@gmail.com
givenName: alberto

dn: uid=rosalia,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
cn:: Um9zYWxpYSBDb3Jkb24gQXJldmFsbwo=
uid: rosalia
uidNumber: 2010
gidNumber: 2510
homeDirectory: /home/rosalia
loginShell: /bin/bash
userPassword: {SSHA}fmbcJQuDFJY6+fW3KXBs8NDHugw5ULuO
sn: Q29yZG9uIEFyZXZhbG8K
mail: rosaliacordonarevalo@gmail.com
givenName: rosalia
```

Hecho dicho fichero, añadimos los objetos usuarios:

```
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org -W -f usuarios.ldif
Enter LDAP Password: 
adding new entry "uid=manuel,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=maria,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=rosaura,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=laura,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=pablo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=arturo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=diego,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=isabel,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=alberto,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "uid=rosalia,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org"
```

* Crea 3 grupos en LDAP dentro de una unidad organizativa diferente que sean 
objetos del tipo groupOfNames. Estos grupos serán: comercial, almacen y admin.

Ahora pasamos a la creación de los grupos. Usaremos la estructura de la 
práctica anterior, y creamos el fichero grupos.ldif:

```
dn: cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: comercial
member:

dn: cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: almacen  
member:

dn: cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: admin    
member:
```

Y hacemos como antes con los usuarios:

```
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org -W -f grupos.ldif
Enter LDAP Password: 
adding new entry "cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"

adding new entry "cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"
```

* Añade usuarios que pertenezcan a:
       - Solo al grupo comercial
       - Solo al grupo almacen
       - Al grupo comercial y almacen
       - Al grupo admin y comercial
       - Solo al grupo admin

Para añadir los usuarios a los grupos pertinentes, debemos crear otro fichero
llamado grupousuario.ldif que contendrá la siguiente información:

```
dn: cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=manuel,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

dn: cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=pablo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

dn: cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=alberto,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

dn: cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=alberto,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

dn: cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=laura,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

dn: cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=laura,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

dn: cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=arturo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
```

Ahora, añadimos los cambios:

```
root@freston:/home/debian# ldapmodify -x -D cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org -W -f grupousuario.ldif
Enter LDAP Password: 
modifying entry "cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"

modifying entry "cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"

modifying entry "cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"

modifying entry "cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"

modifying entry "cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"

modifying entry "cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"

modifying entry "cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org"
```

Y ahora comprobaremos que se han guardado los cambios:

```
root@freston:/home/debian# ldapsearch -h freston -x -b ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
# extended LDIF
#
# LDAPv3
# base <ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# Group, manuel-lora.gonzalonazareno.org
dn: ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalUnit
ou: Group

# admin, Group, manuel-lora.gonzalonazareno.org
dn: cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: admin
member: uid=laura,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
member: uid=arturo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

# almacen, Group, manuel-lora.gonzalonazareno.org
dn: cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: almacen
member: uid=pablo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
member: uid=alberto,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

# comercial, Group, manuel-lora.gonzalonazareno.org
dn: cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: comercial
member: uid=manuel,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
member: uid=alberto,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
member: uid=laura,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org

# search result
search: 2
result: 0 Success

# numResponses: 5
# numEntries: 4
```

* Modifica OpenLDAP apropiadamente para que se pueda obtener los grupos a los 
que pertenece cada usuario a través del atributo "memberOf".

Para ello, debemos crear unos ficheros de configuración, que posteriormente
añadiremos para que aparezca el atributo "memberOf".

En primer lugar, crearemos el fichero que nos permita cargar el módulo memberof.la
y configurarlo. A este fichero lo llamaremos memberof_config.ldif:

```
dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
objectclass: top
olcModuleLoad: memberof.la
olcModulePath: /usr/lib/ldap

dn: olcOverlay={0}memberof,olcDatabase={1}mdb,cn=config
objectClass: olcConfig
objectClass: olcMemberOf
objectClass: olcOverlayConfig
objectClass: top
olcOverlay: memberof
olcMemberOfDangling: ignore
olcMemberOfRefInt: TRUE
olcMemberOfGroupOC: groupOfNames
olcMemberOfMemberAD: member
olcMemberOfMemberOfAD: memberOf
```

Ahora crearemos los otros dos ficheros para agregar y configurar la integridad
referencial, en otras palabras, hay que hacer relaciones entre usuarios y grupos
sin perder coherencia. El primero lo llamaremos refint1.ldif:

```
dn: cn=module,cn=config
cn: module
objectclass: olcModuleList
objectclass: top
olcmoduleload: refint.la
olcmodulepath: /usr/lib/ldap

dn: olcOverlay={1}refint,olcDatabase={1}mdb,cn=config
objectClass: olcConfig
objectClass: olcOverlayConfig
objectClass: olcRefintConfig
objectClass: top
olcOverlay: {1}refint
olcRefintAttribute: memberof member manager owne
```

Y al segundo lo llamaremos refint2.ldif:

```
dn: olcOverlay=memberof,olcDatabase={1}mdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcMemberOf
olcOverlay: memberof
olcMemberOfRefint: TRUE
```

Y los cargamos:

```
debian@freston:~$ sudo ldapadd -Q -Y EXTERNAL -H ldapi:/// -f memberof_config.ldif 
adding new entry "cn=module,cn=config"

adding new entry "olcOverlay={0}memberof,olcDatabase={1}mdb,cn=config"

debian@freston:~$ sudo ldapadd -Q -Y EXTERNAL -H ldapi:/// -f refint1.ldif 
adding new entry "cn=module,cn=config"

adding new entry "olcOverlay={1}refint,olcDatabase={1}mdb,cn=config"
ldap_add: Other (e.g., implementation specific) error (80)
	additional info: olcRefintAttribute <owne>: attribute type undefined

debian@freston:~$ sudo ldapadd -Q -Y EXTERNAL -H ldapi:/// -f refint2.ldif 
adding new entry "olcOverlay=memberof,olcDatabase={1}mdb,cn=config"
```

Para que se apliquen los cambios hay que eliminar los objetos anteriormente
creados de grupos y los volveremos :

```
debian@freston:~$ sudo ldapdelete -x -D "cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org" 'cn=comercial,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org' -W
Enter LDAP Password: 
debian@freston:~$ sudo ldapdelete -x -D "cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org" 'cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org' -W
Enter LDAP Password: 
debian@freston:~$ sudo ldapdelete -x -D "cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org" 'cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org' -W
Enter LDAP Password: 
```

Y comprobamos:

```
debian@freston:~$ sudo ldapsearch -LL -Y EXTERNAL -H ldapi:/// "(uid=arturo)" -b dc=manuel-lora,dc=gonzalonazareno,dc=org memberOf
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
version: 1

dn: uid=arturo,ou=People,dc=manuel-lora,dc=gonzalonazareno,dc=org
memberOf: cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org
```

* Crea las ACLs necesarias para que los usuarios del grupo almacen puedan ver 
todos los atributos de todos los usuarios pero solo puedan modificar las suyas.

Se configurará la ACL en un fichero que se va a llamar ACL_ldif:

```
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {3}to filter=(&(objectclass=inetOrgPerson)(memberof=cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org)) by group.exact="cn=almacen,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org" write 
```

Y lo añadimos:

```
debian@freston:~$ sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ACL_ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={1}mdb,cn=config"
```



* Crea las ACLs necesarias para que los usuarios del grupo admin puedan ver y 
modificar cualquier atributo de cualquier objeto.

Crearemos otro fichero, llamado ACL2.ldif que contendrá las siguientes lineas:

```
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {4}to * by group.exact="cn=admin,ou=Group,dc=manuel-lora,dc=gonzalonazareno,dc=org" write
```

Y lo añadiremos a LDAP:

```
debian@freston:~$ sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ACL2.ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={1}mdb,cn=config"
```
