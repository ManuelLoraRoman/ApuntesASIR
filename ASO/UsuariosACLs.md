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
dn: uid=manuel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=maria,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=rosaura,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=laura,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=pablo,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=arturo,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=diego,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=isabel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=alberto,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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

dn: uid=rosalia,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
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
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=manuel,dc=gonzalonazareno,dc=org -W -f usuarios.ldif
Enter LDAP Password: 
adding new entry "uid=manuel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=maria,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=rosaura,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=laura,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=pablo,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=arturo,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=diego,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=isabel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=alberto,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "uid=rosalia,ou=People,dc=manuel,dc=gonzalonazareno,dc=org"
```

* Crea 3 grupos en LDAP dentro de una unidad organizativa diferente que sean 
objetos del tipo groupOfNames. Estos grupos serán: comercial, almacen y admin.

Ahora pasamos a la creación de los grupos. Usaremos la estructura de la 
práctica anterior, y creamos el fichero grupos.ldif:

```
dn: cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: comercial
member:

dn: cn=almacen,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: almacen  
member:

dn: cn=admin,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: admin    
member:
```

Y hacemos como antes con los usuarios:

```
root@freston:/home/debian# ldapadd -x -D cn=admin,dc=manuel,dc=gonzalonazareno,dc=org -W -f grupos.ldif
Enter LDAP Password: 
adding new entry "cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "cn=almacen,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"

adding new entry "cn=admin,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"
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
dn: cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=manuel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

dn: cn=almacen,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=pablo,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

dn: cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=alberto,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

dn: cn=almacen,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=alberto,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

dn: cn=admin,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
changetype:modify
replace: member
member: uid=laura,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

dn: cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=laura,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

dn: cn=admin,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
changetype:modify
add: member
member: uid=arturo,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
```

Ahora, añadimos los cambios:

```
root@freston:/home/debian# ldapmodify -x -D cn=admin,dc=manuel,dc=gonzalonazareno,dc=org -W -f grupousuario.ldif
Enter LDAP Password: 
modifying entry "cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"

modifying entry "cn=almacen,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"

modifying entry "cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"

modifying entry "cn=almacen,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"

modifying entry "cn=admin,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"

modifying entry "cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"

modifying entry "cn=admin,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org"
```

Y ahora comprobaremos que se han guardado los cambios:

```
root@freston:/home/debian# ldapsearch -h freston -x -b ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
# extended LDIF
#
# LDAPv3
# base <ou=Group,dc=manuel,dc=gonzalonazareno,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# Group, manuel.gonzalonazareno.org
dn: ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: organizationalUnit
ou: Group

# admin, Group, manuel.gonzalonazareno.org
dn: cn=admin,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: admin
member: uid=laura,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
member: uid=arturo,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

# almacen, Group, manuel.gonzalonazareno.org
dn: cn=almacen,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: almacen
member: uid=pablo,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
member: uid=alberto,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

# Usuarios, Group, manuel.gonzalonazareno.org
dn: cn=Usuarios,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixGroup
gidNumber: 2000
cn: Usuarios

# comercial, Group, manuel.gonzalonazareno.org
dn: cn=comercial,ou=Group,dc=manuel,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: groupOfNames
cn: comercial
member: uid=manuel,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
member: uid=alberto,ou=People,dc=manuel,dc=gonzalonazareno,dc=org
member: uid=laura,ou=People,dc=manuel,dc=gonzalonazareno,dc=org

# search result
search: 2
result: 0 Success

# numResponses: 6
# numEntries: 5
```

* Modifica OpenLDAP apropiadamente para que se pueda obtener los grupos a los 
que pertenece cada usuario a través del atributo "memberOf".

Para ello, debemos crear unos ficheros de configuración, que posteriormente
añadiremos para que aparezca el atributo "memberOf".

En primer lugar, crearemos el fichero que nos permita cargar el módulo memberof.la
y configurarlo. A este fichero lo llamaremos memberof_config.ldif

* Crea las ACLs necesarias para que los usuarios del grupo almacen puedan ver 
todos los atributos de todos los usuarios pero solo puedan modificar las suyas.


* Crea las ACLs necesarias para que los usuarios del grupo admin puedan ver y 
modificar cualquier atributo de cualquier objeto.


