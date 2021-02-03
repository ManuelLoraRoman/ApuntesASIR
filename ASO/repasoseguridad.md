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



