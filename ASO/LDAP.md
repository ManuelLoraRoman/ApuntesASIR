<div align="center">

# Teoria de LDAP 

</div>

## PAM (Pluggable Authentication Module

En primer lugar, veremos que es PAM. PAM es un módulo de autentificación de Linux.
Este, separa en 4 las tareas de autentificación: gestión de cuentas, gestión de
autenticación, gestión de contraseñas y gestión de sesión.

Para saber los datos del usuario, usamos el comando ```env```.
Así podemos saber que consola utiliza, el PID de ssh-agent, donde se encuentra
el escritorio del usuario, etc.

En el _/etc/shadow_ aparece las contraseñas de los usuarios cifradas con un hash.
La SAL va desde el primer dólar hasta el tercero. Y el algoritmo usado viene
dado entre los dos primeros dólares. En el caso de Debian, lo podremos ver con
el comando ```grep -v '^$\|^#' /etc/pam.d/common-password``` y sería sha512.


Al igual que en el fichero _/etc/shadow_ se encuentra la información referente
a las contraseñas de los usuarios cifrada, en el fichero _/etc/gshadow_ se 
encuentra la información de contraseñas cifradas de los grupos.


## NSS (Name Service Switch)

Se utiliza para proporcionar al usuario los nombres referentes a la información
numérica realmente guardada en el sistema. Es decir, es una resolución de
nombres por UID y GID.

Esa resolución se hace mediante los ficheros _/etc/password_ y _/etc/groups_.

## Introducción a LDAP

La información en LDAP está representada como una herarquía de objetos, a la
que cada una de ella se le llama entrada. Esta estructura se denomina Árbol
de directorios de información. La cima del árbol se llama root y es el padre
de todos los demás objetos.

Los ObjectClass, pueden ponerse atributos de dos maneras: MUST o MAY. 
Estos pueden ser de 3 tipos, estructurales, auxiliares o abstractos. En una
misma entrada puede haber varios tipos de ObjectClass, pero solo una de tipo 
estructural. Hay herencia entre los padres y los hijos con respecto a los
atributos.

Un atributo pertenece a uno o más ObjectClass. Cada atributo es de un tipo de
dato y un atributo puede ser Mono o Multi valuados. Los atributos pueden tener
alias.

Una característica más, es que hay un atributo que distingue el Objeto en la
herarquia y se conoce como RDN (Relative Distinguished Name).

Ejemplo:

Los ficheros están en un formato llamado ldif

Los atributos se definen con un nombre, dos puntos y un valor.
El orden de los atributos no importa, pero se suele poner el rdn 
(llamado aquí dn) en primer lugar. 
El atributo _dn_ lo tienen todas las entradas. 

Después tenemos el objectClass, dc, description y o. ObjectClass y description
lo tenemos claro. Los objectClass no se crean, vienen ya definidos por el 
sistema, y nuestro objetivo es identificar y valorar donde se deben guardar en
los atributos.

Los demás niveles de jerarquía, tienen que poner en el _dn_ la ruta completa.
