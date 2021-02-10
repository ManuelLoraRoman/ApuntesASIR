# Seguridad en Sistemas de ficheros

El esquema de ugoa es una implementación de un sistema de DAC que los
usuarios pueden modificar los permisos (chmod). Este tiene permisos especiales
como SUID, SGID o sticky bit.

El permiso de SUID o SGID, permite ejecutar un fichero con los permisos de
otro usuario/grupo. Sticky bit permite borrar un fichero/directorio si
eres su propietario.

Tanto SUID como SGID se indica con (s) mientras que el sticky bit con (t).

Los atributos de ficheros se establecen o modifican con ```chattr```.
Y para los atributos extendidos, son pares de clave-valor asociados a un
fichero, ordenadas en 4 clases:

* security
* system
* trusted
* user

Es necesario que el sistema de ficheros incluya soporte para xattrs. Paquete
attr. La clase "user" puede almacenar información asociada a un fichero
de la siguiente manera:

```
setfattr -n user.checksum -v "26327637hsh372h366356y" fichero
```

Kernel Capabilities es una capa de seguridad adicional que permite
dividir los permisos de root en diferentes compartimentos (capabilities)
para asignar dichas capabilities a los usuarios.

Algunos ejemplo de capabilities son:

* CAP_CHOWN

* CAP_KILL

* CAP_SYS_ADMIN

* ...

Para utilizarlo, se instala el paquete _libcap2-bin_.


## SELinux

Son módulos del kérnel que implementan principalmente MAC. Además proporcionan 
RBAC (Role-Based Access Control), TE (Type Enforcement) y MLS (Multi-Level
Security).

El kérnel consulta a SELinux si un proceso está autorizado.

Desarrollado por NSA, actualmente desarrollado por Red Hat.

```
sudo getenforce
Enforcing
```

Tiene 3 modos: restringido, permisivo y deshabilitado. Y también dos tipos
de política:

* MLS --> utilizado en entornos complejos.

* Targeted --> solo procesos seleccionados se ejecutan en un dominio confinado,
mientras que el resto lo hace en uno no confinado.

> - Modo por defecto en RHEL
> - Los procesos que escuchan peticiones a través de la red suelen estar confinados.

```
sestatus
```

### Contextos

Se utilizan reglas para autorizar o prohibir cada operación. Lo que puede
hacer un proceso depende de los contexto de seguridad. Cada fichero o proceso
tiene asociado un contexto de SELinux. El contexto se define por la identidad
del usuario que lo inicia. Tiene estos tipos de contextos:

* Identidad --> usuario de SELinux, sufijo _u.

* Rol --> asociar diferentes roles a cada identidad, sufijo _r.

* Tipo (dominio) --> asociado al tipo de proceso, sufijo _t.

* Nivel de seguridad --> utilizando en entornos complejos.

Algunos aspectos a considerar cuando se interactúa con SELinux son:

* Utilizar los diferentes procesos dentro de lo permitido para cada dominio.

* Utilizar algún proceso confinado fuera de los límites permitidos

```
semanage permissive -a httpd_t
```

* Definir o modificar la política para un proceso. Uso más avanzado.

Algunos de los problemas típicos que nos encontramos pueden ser:

* Ejecutamos un servicio en un puerto no permitido:

```
semanage port -l | grep ^http_port
http_port_t		tcp	80,81,443,488,8008,8009,8443,9000
```

* Servicio lee o escribe ficheros de un tipo no definido en la política:

```
chcon

restorecon

semanage
```

## APPARMOR

Alternativa a SELinux. Incluida en el Kérnel Linux y por ejemplo, Debian,
Ubuntu, OPENSUSE vienen con AppArmor habilitado.

```
aa-status
```


