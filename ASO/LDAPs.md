# LDAPs

Configura el servidor LDAP de frestón para que utilice el protocolo ldaps:// 
a la vez que el ldap:// utilizando el certificado x509 de la práctica de 
https o solicitando el correspondiente a través de gestiona. Realiza las 
modificaciones adecuadas en el cliente ldap de frestón para que todas las 
consultas se realicen por defecto utilizando ldaps://


En primer lugar, necesitamos el certificado de equipo firmado por la AC del
instituto. Una vez lo tengamos en posesión, lo primero que vamos a hacer. vamos 
a pasar dicho certificado y la key hacia la máquina freston.

```
debian@dulcinea:~$ scp centos.crt debian@freston:/home/debian/
centos.crt                                    100%   10KB   4.5MB/s   00:00    
debian@dulcinea:~$ scp gonzalonazareno.crt debian@freston:/home/debian/
gonzalonazareno.crt                           100% 3634     2.5MB/s   00:00    
debian@dulcinea:~$ scp mikey.* debian@freston:/home/debian/
mikey.key                                     100% 3243     2.3MB/s   00:00    
mikey.pubkey                                  100%  800   859.5KB/s   00:00   
```

Una vez hecho esto, movemos dichos ficheros a sus lugares correspondientes:

```
debian@freston:~$ sudo mv centos.crt /etc/ssl/openldap
debian@freston:~$ sudo mv gonzalonazareno.crt /etc/ssl/openldap
debian@freston:~$ sudo mv mikey.key /etc/ssl/openldap
```

A continuación, vamos a instalar el paquete acl y ejecutamos después los 
siguientes comandos:

```
debian@freston:~$ sudo setfacl -m u:openldap:r-x /etc/ssl/openldap
debian@freston:~$ sudo setfacl -m u:openldap:r-x /etc/ssl/openldap/gonzalonazareno.crt
debian@freston:~$ sudo setfacl -m u:openldap:r-x /etc/ssl/openldap/mikey.key 
debian@freston:~$ sudo setfacl -m u:openldap:r-x /etc/ssl/openldap/centos.crt 
```

Esto se hace para agregar permisos a dichos ficheros.

Por último, hay que modificar el fichero _/usr/lib/ssl/openssl.cnf_ para ajustar
correctamente la ruta del directorio:

```
#dir            = ./demoCA              # Where everything is kept
dir             = /etc/ssl
```

Y ahora pasaremos a la configuración de LDAPs. Para la configuración de LDAPs,
como hemos hecho anteriormente en otros ejercicios, vamos a crear un fichero
que modificará el cn=config llamado ldaps.ldif:

```
dn: cn=config
changetype: modify
add: olcTLSCACertificateFile
olcTLSCACertificateFile: /etc/ssl/openldap/gonzalonazareno.crt
-
replace: olcTLSCertificateFile
olcTLSCertificateFile: /etc/ssl/openldap/centos.crt
-
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/ssl/openldap/mikey.key
```

Y añadimos la configuración a ldap:

```
debian@freston:~/openldap$ sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ldaps.ldif 
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "cn=config"
```

Después, comprobamos que se han añadido corectamente los datos:

```
debian@freston:~/openldap$ sudo slapcat -b "cn=config" | grep -E "olcTLS"
olcTLSCACertificateFile: /etc/ssl/openldap/gonzalonazareno.crt
olcTLSCertificateFile: /etc/ssl/openldap/centos.crt
olcTLSCertificateKeyFile: /etc/ssl/openldap/mikey.key
```

Ahora hay que configurar el fichero _/etc/ldap/ldap.conf_ para indicar la 
ubicación del certificado de la AC:

```
# TLS certificates (needed for GnuTLS)
TLS_CACERT      /etc/ssl/openldap/gonzalonazareno.crt
```

Ahora vamos a modificar también el fichero _/etc/default/slapd_ y le añadimos
_ldaps:///_:

```
SLAPD_SERVICES="ldap:/// ldapi:/// ldaps:///"
```

Y reiniciamos el servicio de ldap. Ahora vamos a realizar la comprobación:

```
debian@freston:~/openldap$ sudo ldapsearch -x -H ldaps://freston.manuel-lora.gonzalonazareno.org:636 -b "cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org"
# extended LDIF
#
# LDAPv3
# base <cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# admin, manuel-lora.gonzalonazareno.org
dn: cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1
```
Pero si por el contrario, queremos realizar la misma consulta pero con ldap,
obtenemos lo siguiente:

```
debian@freston:~/openldap$ sudo ldapsearch -x -H ldap://freston.manuel-lora.gonzalonazareno.org:636 -b "cn=admin,dc=manuel-lora,dc=gonzalonazareno,dc=org"
ldap_result: Can't contact LDAP server (-1)
```
