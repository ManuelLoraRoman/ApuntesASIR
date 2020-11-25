# Actualización de Quijote a CentOS 8

Actualiza la instancia quijote a CentOS 8 garantizando que todos los servicios 
previos continúen funcionando y detalla en la tarea los aspectos más relevantes.

En el caso de que la instancia no sea recuperable en algún punto, se tiene que 
volver a crear una instancia de CentOS 7 y realizar la actualización de nuevo. 
Lo recomendable en este caso sería crear una instantánea de volumen antes de 
comenzar y en el caso de tener un error irrecuperable, crear un nuevo volumen 
a partir de la instantánea, eliminar la instancia quijote y crear una nueva 
con el nuevo volumen. Una vez arrancada la nueva instancia se puede 
eliminar el antiguo volumen y las instantáneas asociadas.


## Preparar CentOS 7 para el upgrade a CentOS 8.

En primer lugar, nos aseguraremos que tenemos habilitado el repositorio 
_epel-release_. En caso de no tenerlo, lo instalaremos de la siguiente manera:

```
[root@centos-prueba centos]# yum install epel-release -y
Complementos cargados:fastestmirror
Determining fastest mirrors
 * base: mirror.airenetworks.es
 * extras: mirror.airenetworks.es
 * updates: mirror.airenetworks.es
base                                                     | 3.6 kB     00:00     
extras                                                   | 2.9 kB     00:00     
updates                                                  | 2.9 kB     00:00     
(1/4): extras/7/x86_64/primary_db                          | 222 kB   00:00     
(2/4): base/7/x86_64/group_gz                              | 153 kB   00:00     
(3/4): updates/7/x86_64/primary_db                         | 3.7 MB   00:00     
(4/4): base/7/x86_64/primary_db                            | 6.1 MB   00:01     
Resolviendo dependencias
--> Ejecutando prueba de transacción
---> Paquete epel-release.noarch 0:7-11 debe ser instalado
--> Resolución de dependencias finalizada

Dependencias resueltas

================================================================================
 Package                Arquitectura     Versión         Repositorio      Tamaño
================================================================================
Instalando:
 epel-release           noarch           7-11            extras            15 k

Resumen de la transacción
================================================================================
Instalar  1 Paquete

Tamaño total de la descarga: 15 k
Tamaño instalado: 24 k
Downloading packages:
advertencia:/var/cache/yum/x86_64/7/extras/packages/epel-release-7-11.noarch.rpm: EncabezadoV3 RSA/SHA256 Signature, ID de clave f4a80eb5: NOKEY
No se ha instalado la llave pública de epel-release-7-11.noarch.rpm 
epel-release-7-11.noarch.rpm                               |  15 kB   00:00     
Obteniendo clave desde file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importando llave GPG 0xF4A80EB5:
 Usuarioid  : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Huella       : 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Paquete    : centos-release-7-8.2003.0.el7.centos.x86_64 (installed)
 Desde      : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Instalando    : epel-release-7-11.noarch                                  1/1 
  Comprobando   : epel-release-7-11.noarch                                  1/1 

Instalado:
  epel-release.noarch 0:7-11                                                    

¡Listo!
[root@centos-prueba centos]# 
```

Una vez descargado el repositorio, nos descargaremos las herramientas para el
gestor de paquetes _yum_:

```
[root@centos-prueba centos]# yum install yum-utils -y
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
epel/x86_64/metalink                                     |  28 kB     00:00     
 * base: mirror.airenetworks.es
 * epel: epel.mirrors.arminco.com
 * extras: mirror.airenetworks.es
 * updates: mirror.airenetworks.es
epel                                                     | 4.7 kB     00:00     
(1/3): epel/x86_64/group_gz                                |  95 kB   00:00     
(2/3): epel/x86_64/updateinfo                              | 1.0 MB   00:01     
(3/3): epel/x86_64/primary_db                              | 6.9 MB   00:02     
Resolviendo dependencias
--> Ejecutando prueba de transacción
---> Paquete yum-utils.noarch 0:1.1.31-53.el7 debe ser actualizado
---> Paquete yum-utils.noarch 0:1.1.31-54.el7_8 debe ser una actualización
--> Resolución de dependencias finalizada

Dependencias resueltas

================================================================================
 Package           Arquitectura   Versión                    Repositorio  Tamaño
================================================================================
Actualizando:
 yum-utils         noarch         1.1.31-54.el7_8            base         122 k

Resumen de la transacción
================================================================================
Actualizar  1 Paquete

Tamaño total de la descarga: 122 k
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
yum-utils-1.1.31-54.el7_8.noarch.rpm                       | 122 kB   00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Actualizando  : yum-utils-1.1.31-54.el7_8.noarch                          1/2 
  Limpieza      : yum-utils-1.1.31-53.el7.noarch                            2/2 
  Comprobando   : yum-utils-1.1.31-54.el7_8.noarch                          1/2 
  Comprobando   : yum-utils-1.1.31-53.el7.noarch                            2/2 

Actualizado:
  yum-utils.noarch 0:1.1.31-54.el7_8                                            

¡Listo!
[root@centos-prueba centos]# 
```

Y ahora para los paquetes _rpm_:

```
[root@centos-prueba centos]# yum install rpmconf -y
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.airenetworks.es
 * epel: epel.mirrors.arminco.com
 * extras: mirror.airenetworks.es
 * updates: mirror.airenetworks.es
Resolviendo dependencias
--> Ejecutando prueba de transacción
---> Paquete rpmconf.noarch 0:1.0.22-1.el7 debe ser instalado
--> Procesando dependencias: /usr/bin/python3 para el paquete: rpmconf-1.0.22-1.el7.noarch
--> Procesando dependencias: python36-rpm para el paquete: rpmconf-1.0.22-1.el7.noarch
--> Procesando dependencias: python36-rpmconf para el paquete: rpmconf-1.0.22-1.el7.noarch
--> Procesando dependencias: rpmconf-base para el paquete: rpmconf-1.0.22-1.el7.noarch
--> Ejecutando prueba de transacción
---> Paquete python3.x86_64 0:3.6.8-18.el7 debe ser instalado
--> Procesando dependencias: python3-libs(x86-64) = 3.6.8-18.el7 para el paquete: python3-3.6.8-18.el7.x86_64
--> Procesando dependencias: python3-setuptools para el paquete: python3-3.6.8-18.el7.x86_64
--> Procesando dependencias: python3-pip para el paquete: python3-3.6.8-18.el7.x86_64
--> Procesando dependencias: libpython3.6m.so.1.0()(64bit) para el paquete: python3-3.6.8-18.el7.x86_64
---> Paquete python36-rpm.x86_64 0:4.11.3-8.el7 debe ser instalado
---> Paquete python36-rpmconf.noarch 0:1.0.22-1.el7 debe ser instalado
---> Paquete rpmconf-base.noarch 0:1.0.22-1.el7 debe ser instalado
--> Ejecutando prueba de transacción
---> Paquete python3-libs.x86_64 0:3.6.8-18.el7 debe ser instalado
---> Paquete python3-pip.noarch 0:9.0.3-8.el7 debe ser instalado
---> Paquete python3-setuptools.noarch 0:39.2.0-10.el7 debe ser instalado
--> Resolución de dependencias finalizada

Dependencias resueltas

================================================================================
 Package                  Arquitectura Versión              Repositorio   Tamaño
================================================================================
Instalando:
 rpmconf                  noarch       1.0.22-1.el7         epel           23 k
Instalando para las dependencias:
 python3                  x86_64       3.6.8-18.el7         updates        70 k
 python3-libs             x86_64       3.6.8-18.el7         updates       6.9 M
 python3-pip              noarch       9.0.3-8.el7          base          1.6 M
 python3-setuptools       noarch       39.2.0-10.el7        base          629 k
 python36-rpm             x86_64       4.11.3-8.el7         epel          768 k
 python36-rpmconf         noarch       1.0.22-1.el7         epel           30 k
 rpmconf-base             noarch       1.0.22-1.el7         epel          6.1 k

Resumen de la transacción
================================================================================
Instalar  1 Paquete (+7 Paquetes dependientes)

Tamaño total de la descarga: 10 M
Tamaño instalado: 48 M
Downloading packages:
(1/8): python3-3.6.8-18.el7.x86_64.rpm                     |  70 kB   00:00     
(2/8): python3-setuptools-39.2.0-10.el7.noarch.rpm         | 629 kB   00:00     
(3/8): python3-pip-9.0.3-8.el7.noarch.rpm                  | 1.6 MB   00:00     
warning: /var/cache/yum/x86_64/7/epel/packages/python36-rpm-4.11.3-8.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
No se ha instalado la llave pública de python36-rpm-4.11.3-8.el7.x86_64.rpm 
(4/8): python36-rpm-4.11.3-8.el7.x86_64.rpm                | 768 kB   00:01     
(5/8): python36-rpmconf-1.0.22-1.el7.noarch.rpm            |  30 kB   00:00     
(6/8): python3-libs-3.6.8-18.el7.x86_64.rpm                | 6.9 MB   00:01     
(7/8): rpmconf-1.0.22-1.el7.noarch.rpm                     |  23 kB   00:00     
(8/8): rpmconf-base-1.0.22-1.el7.noarch.rpm                | 6.1 kB   00:00     
--------------------------------------------------------------------------------
Total                                              4.9 MB/s |  10 MB  00:02     
Obteniendo clave desde file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Importando llave GPG 0x352C64E5:
 Usuarioid  : "Fedora EPEL (7) <epel@fedoraproject.org>"
 Huella       : 91e9 7d7c 4a5e 96f1 7f3e 888f 6a2f aea2 352c 64e5
 Paquete    : epel-release-7-11.noarch (@extras)
 Desde      : /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Instalando    : python3-setuptools-39.2.0-10.el7.noarch                   1/8 
  Instalando    : python3-pip-9.0.3-8.el7.noarch                            2/8 
  Instalando    : python3-3.6.8-18.el7.x86_64                               3/8 
  Instalando    : python3-libs-3.6.8-18.el7.x86_64                          4/8 
  Instalando    : python36-rpm-4.11.3-8.el7.x86_64                          5/8 
  Instalando    : python36-rpmconf-1.0.22-1.el7.noarch                      6/8 
  Instalando    : rpmconf-base-1.0.22-1.el7.noarch                          7/8 
  Instalando    : rpmconf-1.0.22-1.el7.noarch                               8/8 
  Comprobando   : python36-rpm-4.11.3-8.el7.x86_64                          1/8 
  Comprobando   : rpmconf-1.0.22-1.el7.noarch                               2/8 
  Comprobando   : python36-rpmconf-1.0.22-1.el7.noarch                      3/8 
  Comprobando   : python3-libs-3.6.8-18.el7.x86_64                          4/8 
  Comprobando   : python3-setuptools-39.2.0-10.el7.noarch                   5/8 
  Comprobando   : rpmconf-base-1.0.22-1.el7.noarch                          6/8 
  Comprobando   : python3-3.6.8-18.el7.x86_64                               7/8 
  Comprobando   : python3-pip-9.0.3-8.el7.noarch                            8/8 

Instalado:
  rpmconf.noarch 0:1.0.22-1.el7                                                 

Dependencia(s) instalada(s):
  python3.x86_64 0:3.6.8-18.el7       python3-libs.x86_64 0:3.6.8-18.el7        
  python3-pip.noarch 0:9.0.3-8.el7    python3-setuptools.noarch 0:39.2.0-10.el7 
  python36-rpm.x86_64 0:4.11.3-8.el7  python36-rpmconf.noarch 0:1.0.22-1.el7    
  rpmconf-base.noarch 0:1.0.22-1.el7 

¡Listo!
[root@centos-prueba centos]# rpmconf -a
[root@centos-prueba centos]# 
```

La herramienta _rpmconf_ se encarga de buscar archivos y nos pregunta que hacer
con ellos, si mantener la versión actual, una versión anterior o consultar.

Por último, haremos limpieza de los paquetes que no son necesarios:

```
[root@centos-prueba centos]# package-cleanup --leaves
Complementos cargados:fastestmirror
libndp-1.2-9.el7.x86_64
libsysfs-2.1.0-16.el7.x86_64
[root@centos-prueba centos]# package-cleanup --orphans
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.airenetworks.es
 * epel: mirror.slu.cz
 * extras: mirror.airenetworks.es
 * updates: mirror.airenetworks.es
bind-export-libs-9.11.4-16.P2.el7_8.2.x86_64
binutils-2.27-43.base.el7.x86_64
ca-certificates-2019.2.32-76.el7_7.noarch
centos-release-7-8.2003.0.el7.centos.x86_64
chkconfig-1.7.4-1.el7.x86_64
cloud-init-18.5-6.el7.centos.x86_64
cpio-2.11-27.el7.x86_64
curl-7.29.0-57.el7.x86_64
dbus-1.10.24-13.el7_6.x86_64
dbus-libs-1.10.24-13.el7_6.x86_64
device-mapper-1.02.164-7.el7_8.1.x86_64
device-mapper-libs-1.02.164-7.el7_8.1.x86_64
dhclient-4.2.5-79.el7.centos.x86_64
dhcp-common-4.2.5-79.el7.centos.x86_64
dhcp-libs-4.2.5-79.el7.centos.x86_64
dmidecode-3.2-3.el7.x86_64
dracut-033-568.el7.x86_64
dracut-config-generic-033-568.el7.x86_64
dracut-config-rescue-033-568.el7.x86_64
dracut-network-033-568.el7.x86_64
e2fsprogs-1.42.9-17.el7.x86_64
e2fsprogs-libs-1.42.9-17.el7.x86_64
elfutils-default-yama-scope-0.176-4.el7.noarch
elfutils-libelf-0.176-4.el7.x86_64
elfutils-libs-0.176-4.el7.x86_64
expat-2.1.0-11.el7.x86_64
file-5.11-36.el7.x86_64
file-libs-5.11-36.el7.x86_64
glib2-2.56.1-5.el7.x86_64
glibc-2.17-307.el7.1.x86_64
glibc-common-2.17-307.el7.1.x86_64
grub2-2.02-0.81.el7.centos.x86_64
grub2-common-2.02-0.81.el7.centos.noarch
grub2-pc-2.02-0.81.el7.centos.x86_64
grub2-pc-modules-2.02-0.81.el7.centos.noarch
grub2-tools-2.02-0.81.el7.centos.x86_64
grub2-tools-extra-2.02-0.81.el7.centos.x86_64
grub2-tools-minimal-2.02-0.81.el7.centos.x86_64
gssproxy-0.7.0-28.el7.x86_64
hwdata-0.252-9.5.el7.x86_64
initscripts-9.49.49-1.el7.x86_64
iproute-4.11.0-25.el7_7.2.x86_64
iptables-1.4.21-34.el7.x86_64
kernel-3.10.0-1127.el7.x86_64
kernel-tools-3.10.0-1127.el7.x86_64
kernel-tools-libs-3.10.0-1127.el7.x86_64
kexec-tools-2.0.15-43.el7.x86_64
kpartx-0.4.9-131.el7.x86_64
krb5-libs-1.15.1-46.el7.x86_64
libblkid-2.23.2-63.el7.x86_64
libcom_err-1.42.9-17.el7.x86_64
libcurl-7.29.0-57.el7.x86_64
libgcc-4.8.5-39.el7.x86_64
libgomp-4.8.5-39.el7.x86_64
libmount-2.23.2-63.el7.x86_64
libpng-1.5.13-7.el7_2.x86_64
libsmartcols-2.23.2-63.el7.x86_64
libss-1.42.9-17.el7.x86_64
libssh2-1.8.0-3.el7.x86_64
libstdc++-4.8.5-39.el7.x86_64
libteam-1.29-1.el7.x86_64
libuuid-2.23.2-63.el7.x86_64
libxml2-2.9.1-6.el7.4.x86_64
libxml2-python-2.9.1-6.el7.4.x86_64
lshw-B.02.18-14.el7.x86_64
lz4-1.7.5-3.el7.x86_64
mariadb-libs-5.5.65-1.el7.x86_64
microcode_ctl-2.1-61.el7.x86_64
nfs-utils-1.3.0-0.66.el7.x86_64
openldap-2.4.44-21.el7_6.x86_64
procps-ng-3.3.10-27.el7.x86_64
python-2.7.5-88.el7.x86_64
python-libs-2.7.5-88.el7.x86_64
python-perf-3.10.0-1127.el7.x86_64
python-requests-2.6.0-9.el7_8.noarch
rpm-4.11.3-43.el7.x86_64
rpm-build-libs-4.11.3-43.el7.x86_64
rpm-libs-4.11.3-43.el7.x86_64
rpm-python-4.11.3-43.el7.x86_64
rsyslog-8.24.0-52.el7.x86_64
sed-4.2.2-6.el7.x86_64
selinux-policy-3.13.1-266.el7.noarch
selinux-policy-targeted-3.13.1-266.el7.noarch
sudo-1.8.23-9.el7.x86_64
systemd-219-73.el7_8.5.x86_64
systemd-libs-219-73.el7_8.5.x86_64
systemd-sysv-219-73.el7_8.5.x86_64
teamd-1.29-1.el7.x86_64
tuned-2.11.0-8.el7.noarch
tzdata-2019c-1.el7.noarch
util-linux-2.23.2-63.el7.x86_64
vim-minimal-7.4.629-6.el7.x86_64
xfsprogs-4.5.0-20.el7.x86_64
yum-3.4.3-167.el7.centos.noarch
yum-plugin-fastestmirror-1.1.31-53.el7.noarch
[root@centos-prueba centos]# 
```

## Instalación del gestor de paquetes dnf

Actualizaremos el gestor de paquetes, y nos descargaremos uno llamado _dnf_, ya
que no viene por defecto en el sistema.

```
[root@centos-prueba centos]# yum install dnf
Complementos cargados:fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.airenetworks.es
 * epel: mirror.cherryservers.com
 * extras: mirror.airenetworks.es
 * updates: mirror.airenetworks.es
Resolviendo dependencias
.
.
.
Resumen de la transacción
================================================================================
Instalar  1 Paquete (+13 Paquetes dependientes)

Tamaño total de la descarga: 2.8 M
Tamaño instalado: 11 M
Is this ok [y/d/N]: y
Downloading packages:
(1/14): dnf-data-4.0.9.2-1.el7_6.noarch.rpm                |  51 kB   00:00     
(2/14): deltarpm-3.6-3.el7.x86_64.rpm                      |  82 kB   00:00   
.
.
.
Dependencia(s) instalada(s):
  deltarpm.x86_64 0:3.6-3.el7                                                   
  dnf-data.noarch 0:4.0.9.2-1.el7_6                                             
  libcomps.x86_64 0:0.1.8-14.el7                                                
  libdnf.x86_64 0:0.22.5-2.el7_9                                                
  libmodulemd.x86_64 0:1.6.3-1.el7                                              
  librepo.x86_64 0:1.8.1-8.el7_9                                                
  libreport-filesystem.x86_64 0:2.1.11-53.el7.centos                            
  libsolv.x86_64 0:0.6.34-4.el7                                                 
  python-enum34.noarch 0:1.0.4-1.el7                                            
  python2-dnf.noarch 0:4.0.9.2-1.el7_6                                          
  python2-hawkey.x86_64 0:0.22.5-2.el7_9                                        
  python2-libcomps.x86_64 0:0.1.8-14.el7                                        
  python2-libdnf.x86_64 0:0.22.5-2.el7_9                                        

¡Listo!
[root@centos-prueba centos]# 
```

Y, aunque ambos gestores pueden funcionar y coexistir el uno con el otro,
desinstalaremos _yum_:

```
[root@centos-prueba centos]# dnf -y remove yum yum-metadata-parser
Dependencias resueltas.
================================================================================
 Paquete                     Arquitectura
                                       Versión                 Repositorio
                                                                          Tamaño
================================================================================
Eliminando:
 yum                         noarch    3.4.3-167.el7.centos    @System    5.6 M
 yum-metadata-parser         x86_64    1.1.4-10.el7            @System     57 k
Eliminando dependencias:
 yum-plugin-fastestmirror    noarch    1.1.31-53.el7           @System     53 k
 yum-utils                   noarch    1.1.31-54.el7_8         @System    337 k

Resumen de la transacción
================================================================================
Eliminar  4 Paquetes

Espacio liberado: 6.0 M
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Prueba de operación exitosa.
Ejecutando operación
  Preparando          :                                                     1/1 
  Eliminando          : yum-utils-1.1.31-54.el7_8.noarch                    1/4 
  Eliminando          : yum-plugin-fastestmirror-1.1.31-53.el7.noarch       2/4 
  Eliminando          : yum-3.4.3-167.el7.centos.noarch                     3/4 
  Eliminando          : yum-metadata-parser-1.1.4-10.el7.x86_64             4/4 
  Verificando         : yum-3.4.3-167.el7.centos.noarch                     1/4 
  Verificando         : yum-metadata-parser-1.1.4-10.el7.x86_64             2/4 
  Verificando         : yum-plugin-fastestmirror-1.1.31-53.el7.noarch       3/4 
  Verificando         : yum-utils-1.1.31-54.el7_8.noarch                    4/4 

Eliminado:
  yum-3.4.3-167.el7.centos.noarch                                               
  yum-metadata-parser-1.1.4-10.el7.x86_64                                       
  yum-plugin-fastestmirror-1.1.31-53.el7.noarch                                 
  yum-utils-1.1.31-54.el7_8.noarch                                              

¡Listo!
[root@centos-prueba centos]# rm -Rf /etc/yum
[root@centos-prueba centos]# 
```

## Upgrade de CentOS 7 a CentOS 8

En primer lugar, ejecutaremos:

```
[root@centos-prueba centos]# dnf upgrade -y
Extra Packages for Enterprise Linux 7 - x86_64  9.7 MB/s |  16 MB     00:01    
CentOS-7 - Base                                 8.8 MB/s |  10 MB     00:01    
CentOS-7 - Updates                              6.9 MB/s | 4.0 MB     00:00    
CentOS-7 - Extras                               8.3 MB/s | 283 kB     00:00    
Última comprobación de caducidad de metadatos hecha hace 0:00:01, el lun 23 nov 2020 17:10:25 UTC.
Dependencias resueltas.
================================================================================
 Paquete                     Arquitectura
                                    Versión                       Repositorio
                                                                          Tamaño
================================================================================
Upgrading:
 epel-release                noarch 7-13                          epel     15 k
 binutils                    x86_64 2.27-44.base.el7              base    5.9 M
 ca-certificates             noarch 2020.2.41-70.0.el7_8          base    382 k
 centos-release              x86_64 7-9.2009.0.el7.centos         base     27 k
.
.
.
Instalado:
  bc-1.06.95-13.el7.x86_64                                                      
  linux-firmware-20200421-79.git78c0348.el7.noarch                              
  kernel-3.10.0-1160.6.1.el7.x86_64                                             

¡Listo!
[root@centos-prueba centos]# 
```

Una vez haya terminado de actualizar, habilitaremos los repositorios de 
CentOS 8 de la siguiente manera:

```
[root@centos-prueba centos]# dnf install http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-repos-8.2-2.2004.0.1.el8.x86_64.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-release-8.2-2.2004.0.1.el8.x86_64.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-gpg-keys-8.2-2.2004.0.1.el8.noarch.rpm
Última comprobación de caducidad de metadatos hecha hace 0:01:10, el lun 23 nov 2020 17:21:56 UTC.
centos-repos-8.2-2.2004.0.1.el8.x86_64.rpm       71 kB/s |  13 kB     00:00    
centos-release-8.2-2.2004.0.1.el8.x86_64.rpm     69 kB/s |  21 kB     00:00    
centos-gpg-keys-8.2-2.2004.0.1.el8.noarch.rpm    29 kB/s |  12 kB     00:00    
Dependencias resueltas.
================================================================================
 Paquete             Arquitectura
                                Versión                  Repositorio      Tamaño
================================================================================
Installing:
 centos-repos        x86_64     8.2-2.2004.0.1.el8       @commandline      13 k
 centos-gpg-keys     noarch     8.2-2.2004.0.1.el8       @commandline      12 k
Upgrading:
 centos-release      x86_64     8.2-2.2004.0.1.el8       @commandline      21 k

Resumen de la transacción
================================================================================
Instalar    2 Paquetes
Actualizar  1 Paquete

Tamaño total: 46 k
¿Está de acuerdo [s/N]?: s
Descargando paquetes:
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Prueba de operación exitosa.
Ejecutando operación
  Preparando          :                                                     1/1 
  Installing          : centos-gpg-keys-8.2-2.2004.0.1.el8.noarch           1/4 
  Upgrading           : centos-release-8.2-2.2004.0.1.el8.x86_64            2/4 
  Installing          : centos-repos-8.2-2.2004.0.1.el8.x86_64              3/4 
  Limpieza            : centos-release-7-9.2009.0.el7.centos.x86_64         4/4 
  Verificando         : centos-repos-8.2-2.2004.0.1.el8.x86_64              1/4 
  Verificando         : centos-gpg-keys-8.2-2.2004.0.1.el8.noarch           2/4 
  Verificando         : centos-release-8.2-2.2004.0.1.el8.x86_64            3/4 
  Verificando         : centos-release-7-9.2009.0.el7.centos.x86_64         4/4 

Actualizado:
  centos-release-8.2-2.2004.0.1.el8.x86_64                                      

Instalado:
  centos-repos-8.2-2.2004.0.1.el8.x86_64                                        
  centos-gpg-keys-8.2-2.2004.0.1.el8.noarch                                     

¡Listo!
[root@centos-prueba centos]# 
```

Y también actualizamos el repositorio _epel_:

```
[root@centos-prueba centos]# dnf upgrade -y epel-release
Extra Packages for Enterprise Linux 7 - x86_64   10 MB/s |  16 MB     00:01    
CentOS-8 - Base                                 2.3 MB/s | 2.2 MB     00:00    
CentOS-8 - AppStream                            6.1 MB/s | 5.8 MB     00:00    
CentOS-8 - Extras                               909 kB/s | 8.6 kB     00:00    
Dependencias resueltas.
================================================================================
 Paquete               Arquitectura    Versión            Repositorio     Tamaño
================================================================================
Upgrading:
 epel-release          noarch          8-8.el8            extras           23 k

Resumen de la transacción
================================================================================
Actualizar  1 Paquete

Tamaño total de la descarga: 23 k
Descargando paquetes:
epel-release-8-8.el8.noarch.rpm                 2.5 MB/s |  23 kB     00:00    
--------------------------------------------------------------------------------
Total                                           112 kB/s |  23 kB     00:00     
advertencia:/var/cache/dnf/extras-2770d521ba03e231/packages/epel-release-8-8.el8.noarch.rpm: EncabezadoV3 RSA/SHA256 Signature, ID de clave 8483c65d: NOKEY
CentOS-8 - Extras                               0.0  B/s |   0  B     00:00    
Importando llave GPG 0x8483C65D:
 ID usuario: "CentOS (CentOS Official Signing Key) <security@centos.org>"
 Huella    : 99DB 70FA E1D7 CE22 7FB6 4882 05B5 55B3 8483 C65D
 Desde     : /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
La llave ha sido importada exitosamente
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Prueba de operación exitosa.
Ejecutando operación
  Preparando          :                                                     1/1 
  Upgrading           : epel-release-8-8.el8.noarch                         1/2 
  Limpieza            : epel-release-7-13.noarch                            2/2 
  Verificando         : epel-release-8-8.el8.noarch                         1/2 
  Verificando         : epel-release-7-13.noarch                            2/2 

Actualizado:
  epel-release-8-8.el8.noarch                                                   

¡Listo!
[root@centos-prueba centos]# 
```

Como ya hemos actualizado los repositorios, eliminaremos todos los archivos 
temporales:

```
[root@centos-prueba centos]# dnf clean all
77 archivos eliminados
```

Actualizados los repositorios, construimos de nuevo la caché:

```
[root@centos-prueba centos]# dnf makecache
Extra Packages for Enterprise Linux 8 - x86_64  9.1 MB/s | 8.3 MB     00:00    
CentOS-8 - Base                                 0.0  B/s |   0  B     00:00    
Extra Packages for Enterprise Linux Modular 8 - 613 kB/s |  98 kB     00:00    
CentOS-8 - AppStream                            0.0  B/s |   0  B     00:00    
CentOS-8 - Extras                               0.0  B/s |   0  B     00:00    
Caché de metadatos creada.
[root@centos-prueba centos]# 
```

Eliminamos los paquetes conflictivos en caso de que lo hubiese:

```
[root@centos-prueba centos]# rpm -e --nodeps sysvinit-tools
[root@centos-prueba centos]# 
```

Y hecho esto, actualizamos:

```
[root@centos-prueba centos]# dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
.
.
.
licto con el archivo del paquete python36-rpmconf-1.0.22-1.el7.noarch
  el archivo /usr/lib/python3.6/site-packages/rpmconf/__pycache__/rpmconf.cpython-36.opt-1.pyc de la instalación de python3-rpmconf-1.0.21-1.el8.noarch entra en conflicto con el archivo del paquete python36-rpmconf-1.0.22-1.el7.noarch
  el archivo /usr/lib/python3.6/site-packages/rpmconf/__pycache__/rpmconf.cpython-36.pyc de la instalación de python3-rpmconf-1.0.21-1.el8.noarch entra en conflicto con el archivo del paquete python36-rpmconf-1.0.22-1.el7.noarch
  el archivo /usr/share/man/man3/rpmconf.3.gz de la instalación de python3-rpmconf-1.0.21-1.el8.noarch entra en conflicto con el archivo del paquete python36-rpmconf-1.0.22-1.el7.noarch

Resumen de errores
-------------
```

En principio, nos hemos encontrado con conflictos en la actualización con los
paquetes python. Para solucionarlo, debemos ejecutar lo siguiente:

```
[root@centos-prueba centos]# rpm -e --justdb python36-rpmconf-1.0.22-1.el7.noarch rpmconf-1.0.22-1.el7.noarch
[root@centos-prueba centos]# rpm -e --justdb --nodeps python3-setuptools-39.2.0-10.el7.noarch
[root@centos-prueba centos]# rpm -e --justdb --nodeps python3-pip-9.0.3-8.el7.noarch
[root@centos-prueba centos]# rpm -e --justdb --nodeps iptables-1.4.21-35.el7.x86_64
[root@centos-prueba centos]# rpm -e --justdb --nodeps vim-minimal
[root@centos-prueba centos]# 
```

Y ahora sí:

```
[root@centos-prueba centos]# dnf upgrade --best --allowerasing rpm
CentOS-8 - Base                                 0.0  B/s |   0  B     00:00    
CentOS-8 - AppStream                            0.0  B/s |   0  B     00:00    
Dependencias resueltas.
================================================================================
 Paquete                    Arquitectura
                                   Versión                      Repositorio
                                                                          Tamaño
================================================================================
Upgrading:
 bc                         x86_64 1.07.1-5.el8                 BaseOS    129 k
 bind-export-libs           x86_64 32:9.11.13-6.el8_2.1         BaseOS    1.1 M
 binutils                   x86_64 2.30-73.el8                  BaseOS    5.7 M
 cryptsetup-libs            x86_64 2.2.2-1.el8                  BaseOS    428 k
 dhcp-common                noarch 12:4.3.6-40.el8              BaseOS    207 k
.
.
.
Actualizado:
  bc-1.07.1-5.el8.x86_64                                                        
  bind-export-libs-32:9.11.13-6.el8_2.1.x86_64                                  
  binutils-2.30-73.el8.x86_64                                                   
  cryptsetup-libs-2.2.2-1.el8.x86_64                                            
  dhcp-common-12:4.3.6-40.el8.noarch                                            
  dhcp-libs-12:4.3.6-40.el8.x86_64                                              
  dnf-4.2.17-7.el8_2.noarch                                                     
  dnf-data-4.2.17-7.el8_2.noarch                                                
  gdbm-1:1.18-1.el8.x86_64                                                      
  gettext-0.19.8.1-17.el8.x86_64                                                
  gettext-libs-0.19.8.1-17.el8.x86_64                                           
  glibc-2.28-101.el8.x86_64                                                     
  glibc-common-2.28-101.el8.x86_64                                              
  gnupg2-2.2.9-1.el8.x86_64                                                     
  gpgme-1.10.0-6.el8.0.1.x86_64                                                 
  grep-3.1-6.el8.x86_64                                                         
  grub2-common-1:2.02-87.el8_2.noarch                                           
  grub2-pc-1:2.02-87.el8_2.x86_64                                               
  grub2-pc-modules-1:2.02-87.el8_2.noarch                                       
  grub2-tools-1:2.02-87.el8_2.x86_64                                            
  grub2-tools-extra-1:2.02-87.el8_2.x86_64                                      
  grub2-tools-minimal-1:2.02-87.el8_2.x86_64                                    
  grubby-8.40-38.el8.x86_64                                                     
  initscripts-10.00.6-1.el8_2.2.x86_64                                          
  json-c-0.13.1-0.2.el8.x86_64                                                  
  libblkid-2.32.1-22.el8.x86_64                                                 
  libcomps-0.1.11-4.el8.x86_64                                                  
  libdnf-0.39.1-6.el8_2.x86_64                                                  
  libevent-2.1.8-5.el8.x86_64                                                   
  libgcrypt-1.8.3-4.el8.x86_64                                                  
  libgpg-error-1.31-1.el8.x86_64                                                
  libmount-2.32.1-22.el8.x86_64                                                 
  libnfsidmap-1:2.3.3-31.el8.x86_64                                             
  librepo-1.11.0-3.el8_2.x86_64                                                 
  libsmartcols-2.32.1-22.el8.x86_64                                             
  libsolv-0.7.7-1.el8.x86_64                                                    
  libstdc++-8.3.1-5.el8.0.2.x86_64                                              
  libtirpc-1.1.4-4.el8.x86_64                                                   
  libunistring-0.9.9-3.el8.x86_64                                               
  libuuid-2.32.1-22.el8.x86_64                                                  
  libverto-0.3.0-5.el8.x86_64                                                   
  libverto-libevent-0.3.0-5.el8.x86_64                                          
  man-db-2.7.6.1-17.el8.x86_64                                                  
  ncurses-6.1-7.20180224.el8.x86_64                                             
  ncurses-base-6.1-7.20180224.el8.noarch                                        
  ncurses-libs-6.1-7.20180224.el8.x86_64                                        
  nfs-utils-1:2.3.3-31.el8.x86_64                                               
  openssh-8.0p1-4.el8_1.x86_64                                                  
  openssh-clients-8.0p1-4.el8_1.x86_64                                          
  openssh-server-8.0p1-4.el8_1.x86_64                                           
  openssl-1:1.1.1c-15.el8.x86_64                                                
  openssl-libs-1:1.1.1c-15.el8.x86_64                                           
  parted-3.2-38.el8.x86_64                                                      
  python3-libs-3.6.8-23.el8.x86_64                                              
  readline-7.0-10.el8.x86_64                                                    
  rpcbind-1.2.5-7.el8.x86_64                                                    
  rpm-4.14.2-37.el8.x86_64                                                      
  rpm-build-libs-4.14.2-37.el8.x86_64                                           
  rpm-libs-4.14.2-37.el8.x86_64                                                 
  sqlite-3.26.0-6.el8.x86_64                                                    
  sudo-1.8.29-5.el8.x86_64                                                      
  systemd-239-31.el8_2.2.x86_64                                                 
  systemd-libs-239-31.el8_2.2.x86_64                                            
  tuned-2.13.0-6.el8.noarch                                                     
  util-linux-2.32.1-22.el8.x86_64                                               
  which-2.21-12.el8.x86_64                                                      
  xfsprogs-5.0.0-2.el8.x86_64                                                   
  xz-5.2.4-3.el8.x86_64                                                         
  xz-libs-5.2.4-3.el8.x86_64                                                    
  lua-5.3.4-11.el8.x86_64                                                       


Instalado:
  gnupg2-smime-2.2.9-1.el8.x86_64                                               
  network-scripts-team-1.29-1.el8_2.2.x86_64                                    
  openssl-pkcs11-0.4.10-2.el8.x86_64                                            
  platform-python-pip-9.0.3-16.el8.noarch                                       
  rpm-plugin-systemd-inhibit-4.14.2-37.el8.x86_64                               
  trousers-0.3.14-4.el8.x86_64                                                  
  geolite2-city-20180605-1.el8.noarch                                           
  geolite2-country-20180605-1.el8.noarch                                        
  libmaxminddb-1.2.0-7.el8.x86_64                                               
  libxkbcommon-0.9.1-1.el8.x86_64                                               
  oddjob-mkhomedir-0.34.4-7.el8.x86_64                                          
  python2-pip-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch                       
  python2-setuptools-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch               
  python3-unbound-1.7.3-11.el8_2.x86_64                                         
  authselect-1.1-2.el8.x86_64                                                   
  authselect-libs-1.1-2.el8.x86_64                                              
  centos-obsolete-packages-8-4.noarch                                           
  crypto-policies-20191128-2.git23e1bf1.el8.noarch                              
  dhcp-client-12:4.3.6-40.el8.x86_64                                            
  gdbm-libs-1:1.18-1.el8.x86_64                                                 
  glibc-all-langpacks-2.28-101.el8.x86_64                                       
  gnutls-3.6.8-11.el8_2.x86_64                                                  
  grub2-tools-efi-1:2.02-87.el8_2.x86_64                                        
  hdparm-9.54-2.el8.x86_64                                                      
  ima-evm-utils-1.1-5.el8.x86_64                                                
  ipcalc-0.2.4-4.el8.x86_64                                                     
  iptables-libs-1.8.4-10.el8_2.1.x86_64                                         
  libarchive-3.3.2-8.el8_1.x86_64                                               
  libfdisk-2.32.1-22.el8.x86_64                                                 
  libidn2-2.2.0-1.el8.x86_64                                                    
  libksba-1.3.5-7.el8.x86_64                                                    
  libnsl-2.28-101.el8.x86_64                                                    
  libnsl2-1.2.0-2.20180605git4a062cf.el8.x86_64                                 
  libpcap-14:1.9.0-3.el8.x86_64                                                 
  libusbx-1.0.22-1.el8.x86_64                                                   
  libxcrypt-4.1.1-4.el8.x86_64                                                  
  libzstd-1.4.2-2.el8.x86_64                                                    
  lua-libs-5.3.4-11.el8.x86_64                                                  
  ncurses-compat-libs-6.1-7.20180224.el8.x86_64                                 
  netconsole-service-10.00.6-1.el8_2.2.noarch                                   
  nettle-3.4.1-1.el8.x86_64                                                     
  network-scripts-10.00.6-1.el8_2.2.x86_64                                      
  npth-1.5-4.el8.x86_64                                                         
  pcre2-10.32-1.el8.x86_64                                                      
  platform-python-3.6.8-23.el8.x86_64                                           
  platform-python-setuptools-39.2.0-5.el8.noarch                                
  psmisc-23.1-4.el8.x86_64                                                      
  python3-configobj-5.0.6-11.el8.noarch                                         
  python3-dbus-1.2.4-15.el8.x86_64                                              
  python3-decorator-4.2.1-2.el8.noarch                                          
  python3-dnf-4.2.17-7.el8_2.noarch                                             
  python3-gobject-base-3.28.3-1.el8.x86_64                                      
  python3-gpg-1.10.0-6.el8.0.1.x86_64                                           
  python3-hawkey-0.39.1-6.el8_2.x86_64                                          
  python3-libcomps-0.1.11-4.el8.x86_64                                          
  python3-libdnf-0.39.1-6.el8_2.x86_64                                          
  python3-linux-procfs-0.6-7.el8.noarch                                         
  python3-perf-4.18.0-193.28.1.el8_2.x86_64                                     
  python3-pip-wheel-9.0.3-16.el8.noarch                                         
  python3-pyudev-0.21.0-7.el8.noarch                                            
  python3-rpm-4.14.2-37.el8.x86_64                                              
  python3-schedutils-0.6-6.el8.x86_64                                           
  python3-setuptools-wheel-39.2.0-5.el8.noarch                                  
  python3-six-1.11.0-8.el8.noarch                                               
  python3-syspurpose-1.26.20-1.el8_2.x86_64                                     
  readonly-root-10.00.6-1.el8_2.2.noarch                                        
  sqlite-libs-3.26.0-6.el8.x86_64                                               
  systemd-container-239-31.el8_2.2.x86_64                                       
  systemd-pam-239-31.el8_2.2.x86_64                                             
  systemd-udev-239-31.el8_2.2.x86_64                                            
  trousers-lib-0.3.14-4.el8.x86_64                                              
  vim-minimal-2:8.0.1763-13.el8.x86_64                                          
  authselect-compat-1.1-2.el8.x86_64                                            
  compat-openssl10-1:1.0.2o-3.el8.x86_64                                        
  oddjob-0.34.4-7.el8.x86_64                                                    
  python2-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                           
  python2-libs-2.7.17-1.module_el8.2.0+381+9a5b3c3b.x86_64                      
  python2-pip-wheel-9.0.3-16.module_el8.2.0+381+9a5b3c3b.noarch                 
  python2-setuptools-wheel-39.0.1-11.module_el8.2.0+381+9a5b3c3b.noarch         
  unbound-libs-1.7.3-11.el8_2.x86_64                                            
  xkeyboard-config-2.28-1.el8.noarch                                            

Eliminado:
  cloud-init-19.4-7.el7.centos.2.x86_64    deltarpm-3.6-3.el7.x86_64           
  libsemanage-python-2.5-14.el7.x86_64     libxml2-python-2.9.1-6.el7.5.x86_64 
  policycoreutils-python-2.5-34.el7.x86_64 pyserial-2.6-6.el7.noarch           
  python-2.7.5-90.el7.x86_64               python-chardet-2.2.1-3.el7.noarch   
  python-jsonpatch-1.2-4.el7.noarch        python-jsonpointer-1.9-2.el7.noarch 
  python-kitchen-1.1.1-5.el7.noarch        python-libs-2.7.5-90.el7.x86_64     
  python-linux-procfs-0.4.11-4.el7.noarch  python-requests-2.6.0-10.el7.noarch 
  python-schedutils-0.4-6.el7.x86_64       python-setuptools-0.9.8-7.el7.noarch
  python-urlgrabber-3.10-10.el7.noarch     python2-dnf-4.0.9.2-1.el7_6.noarch  
  python2-libcomps-0.1.8-14.el7.x86_64     python3-3.6.8-18.el7.x86_64         
  python36-rpm-4.11.3-8.el7.x86_64         pyxattr-0.5.1-5.el7.x86_64          
  rpm-python-4.11.3-45.el7.x86_64          systemd-sysv-219-78.el7_9.2.x86_64  

¡Listo!
```

Ya actualizado, nos instalaremos la última versión del kernel de CentOS 8:

```
[root@centos-prueba ~]# dnf install -y kernel-core
Last metadata expiration check: 0:12:18 ago on Wed 25 Nov 2020 08:18:24 AM UTC.
Dependencies resolved.
=========================================================================================================
 Package                 Architecture       Version                             Repository          Size
=========================================================================================================
Installing:
 kernel-core             x86_64             4.18.0-193.28.1.el8_2               BaseOS              28 M

Transaction Summary
=========================================================================================================
Install  1 Package

Total download size: 28 M
Installed size: 60 M
Downloading Packages:
kernel-core-4.18.0-193.28.1.el8_2.x86_64.rpm                             4.6 MB/s |  28 MB     00:06    
---------------------------------------------------------------------------------------------------------
Total                                                                    4.3 MB/s |  28 MB     00:06     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                 1/1 
  Installing       : kernel-core-4.18.0-193.28.1.el8_2.x86_64                                        1/1 
  Running scriptlet: kernel-core-4.18.0-193.28.1.el8_2.x86_64                                        1/1 
  Verifying        : kernel-core-4.18.0-193.28.1.el8_2.x86_64                                        1/1 

Installed:
  kernel-core-4.18.0-193.28.1.el8_2.x86_64                                                               

Complete!
```

E instalaremos los paquetes mínimos del sistema:

```
[root@centos-prueba centos]# dnf -y groupupdate "Core" "Minimal Install" --allowerasing --skip-broken
Last metadata expiration check: 0:14:03 ago on Wed 25 Nov 2020 08:18:24 AM UTC.
Dependencies resolved.
=========================================================================================================
 Package                         Arch      Version                                    Repository    Size
=========================================================================================================
Installing group/module packages:
 NetworkManager                  x86_64    1:1.22.8-5.el8_2                           BaseOS       2.3 M
 NetworkManager-team             x86_64    1:1.22.8-5.el8_2                           BaseOS       136 k
 NetworkManager-tui              x86_64    1:1.22.8-5.el8_2                           BaseOS       306 k
 biosdevname                     x86_64    0.7.3-2.el8                                BaseOS        44 k
 dnf-plugin-spacewalk            noarch    2.8.5-11.module_el8.1.0+211+ad6c0bc7       AppStream     24 k
 dnf-plugins-core                noarch    4.0.12-4.el8_2                             BaseOS        64 k
 firewalld                       noarch    0.8.0-4.el8                                BaseOS       482 k
 iprutils                        x86_64    2.4.18.1-1.el8                             BaseOS       256 k
 iwl100-firmware                 noarch    39.31.5.1-97.el8.1                         BaseOS       167 k
 iwl1000-firmware                noarch    1:39.31.5.1-97.el8.1                       BaseOS       230 k
 iwl105-firmware                 noarch    18.168.6.1-97.el8.1                        BaseOS       251 k
 iwl135-firmware                 noarch    18.168.6.1-97.el8.1                        BaseOS       260 k
 iwl2000-firmware                noarch    18.168.6.1-97.el8.1                        BaseOS       254 k
 iwl2030-firmware                noarch    18.168.6.1-97.el8.1                        BaseOS       262 k
 iwl3160-firmware                noarch    1:25.30.13.0-97.el8.1                      BaseOS       1.7 M
 iwl3945-firmware                noarch    15.32.2.9-97.el8.1                         BaseOS       105 k
 iwl4965-firmware                noarch    228.61.2.24-97.el8.1                       BaseOS       118 k
 iwl5000-firmware                noarch    8.83.5.1_1-97.el8.1                        BaseOS       311 k
 iwl5150-firmware                noarch    8.24.2.2-97.el8.1                          BaseOS       163 k
 iwl6000-firmware                noarch    9.221.4.1-97.el8.1                         BaseOS       184 k
 iwl6000g2a-firmware             noarch    18.168.6.1-97.el8.1                        BaseOS       326 k
 iwl6050-firmware                noarch    41.28.5.1-97.el8.1                         BaseOS       259 k
 iwl7260-firmware                noarch    1:25.30.13.0-97.el8.1                      BaseOS        10 M
 lsscsi                          x86_64    0.30-1.el8                                 BaseOS        69 k
 plymouth                        x86_64    0.9.3-16.el8                               AppStream    114 k
 prefixdevname                   x86_64    0.1.0-6.el8                                BaseOS       466 k
 rng-tools                       x86_64    6.8-3.el8                                  BaseOS        59 k
 sssd-common                     x86_64    2.2.3-20.el8                               BaseOS       1.5 M
 sssd-kcm                        x86_64    2.2.3-20.el8                               BaseOS       218 k
 yum                             noarch    4.2.17-7.el8_2                             BaseOS       191 k
Installing dependencies:
 NetworkManager-libnm            x86_64    1:1.22.8-5.el8_2                           BaseOS       1.7 M
 c-ares                          x86_64    1.13.0-5.el8                               BaseOS        93 k
 firewalld-filesystem            noarch    0.8.0-4.el8                                BaseOS        75 k
 ipset                           x86_64    7.1-1.el8                                  BaseOS        45 k
 ipset-libs                      x86_64    7.1-1.el8                                  BaseOS        71 k
 iptables-ebtables               x86_64    1.8.4-10.el8_2.1                           BaseOS        70 k
 libdhash                        x86_64    0.5.0-39.el8                               BaseOS        34 k
 libgudev                        x86_64    232-4.el8                                  BaseOS        33 k
 libldb                          x86_64    2.0.7-3.el8                                BaseOS       180 k
 libsss_certmap                  x86_64    2.2.3-20.el8                               BaseOS       136 k
 libsss_idmap                    x86_64    2.2.3-20.el8                               BaseOS       107 k
 libsss_nss_idmap                x86_64    2.2.3-20.el8                               BaseOS       114 k
 libtalloc                       x86_64    2.2.0-7.el8                                BaseOS        49 k
 libtdb                          x86_64    1.4.2-2.el8                                BaseOS        59 k
 libtevent                       x86_64    0.10.0-2.el8                               BaseOS        49 k
 nftables                        x86_64    1:0.9.3-12.el8_2.1                         BaseOS       311 k
 plymouth-core-libs              x86_64    0.9.3-16.el8                               AppStream    115 k
 plymouth-scripts                x86_64    0.9.3-16.el8                               AppStream     42 k
 python3-dateutil                noarch    1:2.6.1-6.el8                              BaseOS       251 k
 python3-dnf-plugin-spacewalk    noarch    2.8.5-11.module_el8.1.0+211+ad6c0bc7       AppStream     30 k
 python3-dnf-plugins-core        noarch    4.0.12-4.el8_2                             BaseOS       204 k
 python3-firewall                noarch    0.8.0-4.el8                                BaseOS       389 k
 python3-hwdata                  noarch    2.3.6-3.el8                                AppStream     39 k
 python3-librepo                 x86_64    1.11.0-3.el8_2                             BaseOS        52 k
 python3-netifaces               x86_64    0.10.6-4.el8                               AppStream     25 k
 python3-newt                    x86_64    0.52.20-11.el8                             AppStream     64 k
 python3-nftables                x86_64    1:0.9.3-12.el8_2.1                         BaseOS        25 k
 python3-pyOpenSSL               noarch    18.0.0-1.el8                               AppStream    103 k
 python3-rhn-client-tools        x86_64    2.8.16-13.module_el8.1.0+211+ad6c0bc7      AppStream    108 k
 python3-rhnlib                  noarch    2.8.6-8.module_el8.1.0+211+ad6c0bc7        AppStream     77 k
 python3-slip                    noarch    0.6.4-11.el8                               BaseOS        39 k
 python3-slip-dbus               noarch    0.6.4-11.el8                               BaseOS        39 k
 rhn-client-tools                x86_64    2.8.16-13.module_el8.1.0+211+ad6c0bc7      AppStream    385 k
 sssd-client                     x86_64    2.2.3-20.el8                               BaseOS       171 k
Installing weak dependencies:
 libsss_autofs                   x86_64    2.2.3-20.el8                               BaseOS       105 k
 libsss_sudo                     x86_64    2.2.3-20.el8                               BaseOS       103 k
 sssd-nfs-idmap                  x86_64    2.2.3-20.el8                               BaseOS       101 k
Enabling module streams:
 satellite-5-client                        1.0                                                          
Installing Environment Groups:
 Minimal Install                                                                                        
Installing Groups:
 Core                                                                                                   

Transaction Summary
=========================================================================================================
Install  67 Packages

Total download size: 26 M
Installed size: 143 M
Downloading Packages:
(1/67): plymouth-core-libs-0.9.3-16.el8.x86_64.rpm                       636 kB/s | 115 kB     00:00    
(2/67): plymouth-0.9.3-16.el8.x86_64.rpm                                 624 kB/s | 114 kB     00:00    
(3/67): plymouth-scripts-0.9.3-16.el8.x86_64.rpm                         5.6 MB/s |  42 kB     00:00    
(4/67): dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch  49 kB/s |  24 kB     00:00    
(5/67): python3-hwdata-2.3.6-3.el8.noarch.rpm                            126 kB/s |  39 kB     00:00    
(6/67): python3-dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc  94 kB/s |  30 kB     00:00    
(7/67): python3-netifaces-0.10.6-4.el8.x86_64.rpm                        230 kB/s |  25 kB     00:00    
(8/67): python3-newt-0.52.20-11.el8.x86_64.rpm                           406 kB/s |  64 kB     00:00    
(9/67): python3-pyOpenSSL-18.0.0-1.el8.noarch.rpm                        560 kB/s | 103 kB     00:00    
(10/67): python3-rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7. 750 kB/s | 108 kB     00:00    
(11/67): python3-rhnlib-2.8.6-8.module_el8.1.0+211+ad6c0bc7.noarch.rpm   478 kB/s |  77 kB     00:00    
(12/67): rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7.x86_64.r 1.9 MB/s | 385 kB     00:00    
(13/67): NetworkManager-team-1.22.8-5.el8_2.x86_64.rpm                   884 kB/s | 136 kB     00:00    
(14/67): NetworkManager-1.22.8-5.el8_2.x86_64.rpm                        4.7 MB/s | 2.3 MB     00:00    
(15/67): biosdevname-0.7.3-2.el8.x86_64.rpm                              1.0 MB/s |  44 kB     00:00    
(16/67): NetworkManager-tui-1.22.8-5.el8_2.x86_64.rpm                    1.1 MB/s | 306 kB     00:00    
(17/67): NetworkManager-libnm-1.22.8-5.el8_2.x86_64.rpm                  3.3 MB/s | 1.7 MB     00:00    
(18/67): dnf-plugins-core-4.0.12-4.el8_2.noarch.rpm                      2.5 MB/s |  64 kB     00:00    
(19/67): firewalld-filesystem-0.8.0-4.el8.noarch.rpm                     622 kB/s |  75 kB     00:00    
(20/67): firewalld-0.8.0-4.el8.noarch.rpm                                2.7 MB/s | 482 kB     00:00    
(21/67): iprutils-2.4.18.1-1.el8.x86_64.rpm                              4.5 MB/s | 256 kB     00:00    
(22/67): c-ares-1.13.0-5.el8.x86_64.rpm                                  293 kB/s |  93 kB     00:00    
(23/67): ipset-7.1-1.el8.x86_64.rpm                                      403 kB/s |  45 kB     00:00    
(24/67): ipset-libs-7.1-1.el8.x86_64.rpm                                 642 kB/s |  71 kB     00:00    
(25/67): iwl100-firmware-39.31.5.1-97.el8.1.noarch.rpm                   4.6 MB/s | 167 kB     00:00    
(26/67): iwl1000-firmware-39.31.5.1-97.el8.1.noarch.rpm                  5.4 MB/s | 230 kB     00:00    
(27/67): iwl105-firmware-18.168.6.1-97.el8.1.noarch.rpm                  8.5 MB/s | 251 kB     00:00    
(28/67): iptables-ebtables-1.8.4-10.el8_2.1.x86_64.rpm                   627 kB/s |  70 kB     00:00    
(29/67): iwl135-firmware-18.168.6.1-97.el8.1.noarch.rpm                  1.5 MB/s | 260 kB     00:00    
(30/67): iwl2030-firmware-18.168.6.1-97.el8.1.noarch.rpm                 1.8 MB/s | 262 kB     00:00    
(31/67): iwl2000-firmware-18.168.6.1-97.el8.1.noarch.rpm                 1.2 MB/s | 254 kB     00:00    
(32/67): iwl4965-firmware-228.61.2.24-97.el8.1.noarch.rpm                6.7 MB/s | 118 kB     00:00    
(33/67): iwl3945-firmware-15.32.2.9-97.el8.1.noarch.rpm                  867 kB/s | 105 kB     00:00    
(34/67): iwl5000-firmware-8.83.5.1_1-97.el8.1.noarch.rpm                 1.4 MB/s | 311 kB     00:00    
(35/67): iwl3160-firmware-25.30.13.0-97.el8.1.noarch.rpm                 5.3 MB/s | 1.7 MB     00:00    
(36/67): iwl5150-firmware-8.24.2.2-97.el8.1.noarch.rpm                   869 kB/s | 163 kB     00:00    
(37/67): iwl6000g2a-firmware-18.168.6.1-97.el8.1.noarch.rpm              8.9 MB/s | 326 kB     00:00    
(38/67): iwl6000-firmware-9.221.4.1-97.el8.1.noarch.rpm                  1.4 MB/s | 184 kB     00:00    
(39/67): iwl6050-firmware-41.28.5.1-97.el8.1.noarch.rpm                  1.6 MB/s | 259 kB     00:00    
(40/67): libdhash-0.5.0-39.el8.x86_64.rpm                                301 kB/s |  34 kB     00:00    
(41/67): libgudev-232-4.el8.x86_64.rpm                                   235 kB/s |  33 kB     00:00    
(42/67): libldb-2.0.7-3.el8.x86_64.rpm                                   913 kB/s | 180 kB     00:00    
(43/67): libsss_autofs-2.2.3-20.el8.x86_64.rpm                           564 kB/s | 105 kB     00:00    
(44/67): libsss_certmap-2.2.3-20.el8.x86_64.rpm                          502 kB/s | 136 kB     00:00    
(45/67): libsss_idmap-2.2.3-20.el8.x86_64.rpm                            422 kB/s | 107 kB     00:00    
(46/67): libsss_nss_idmap-2.2.3-20.el8.x86_64.rpm                        295 kB/s | 114 kB     00:00    
(47/67): libsss_sudo-2.2.3-20.el8.x86_64.rpm                             310 kB/s | 103 kB     00:00    
(48/67): iwl7260-firmware-25.30.13.0-97.el8.1.noarch.rpm                 8.6 MB/s |  10 MB     00:01    
(49/67): libtalloc-2.2.0-7.el8.x86_64.rpm                                303 kB/s |  49 kB     00:00    
(50/67): libtdb-1.4.2-2.el8.x86_64.rpm                                   353 kB/s |  59 kB     00:00    
(51/67): libtevent-0.10.0-2.el8.x86_64.rpm                               415 kB/s |  49 kB     00:00    
(52/67): lsscsi-0.30-1.el8.x86_64.rpm                                    576 kB/s |  69 kB     00:00    
(53/67): prefixdevname-0.1.0-6.el8.x86_64.rpm                            5.8 MB/s | 466 kB     00:00    
(54/67): nftables-0.9.3-12.el8_2.1.x86_64.rpm                            1.8 MB/s | 311 kB     00:00    
(55/67): python3-dateutil-2.6.1-6.el8.noarch.rpm                         1.5 MB/s | 251 kB     00:00    
(56/67): python3-dnf-plugins-core-4.0.12-4.el8_2.noarch.rpm              690 kB/s | 204 kB     00:00    
(57/67): python3-firewall-0.8.0-4.el8.noarch.rpm                         1.2 MB/s | 389 kB     00:00    
(58/67): python3-librepo-1.11.0-3.el8_2.x86_64.rpm                       196 kB/s |  52 kB     00:00    
(59/67): python3-nftables-0.9.3-12.el8_2.1.x86_64.rpm                    238 kB/s |  25 kB     00:00    
(60/67): rng-tools-6.8-3.el8.x86_64.rpm                                  6.0 MB/s |  59 kB     00:00    
(61/67): python3-slip-0.6.4-11.el8.noarch.rpm                            357 kB/s |  39 kB     00:00    
(62/67): python3-slip-dbus-0.6.4-11.el8.noarch.rpm                       359 kB/s |  39 kB     00:00    
(63/67): sssd-client-2.2.3-20.el8.x86_64.rpm                             1.3 MB/s | 171 kB     00:00    
(64/67): sssd-kcm-2.2.3-20.el8.x86_64.rpm                                1.1 MB/s | 218 kB     00:00    
(65/67): sssd-nfs-idmap-2.2.3-20.el8.x86_64.rpm                          678 kB/s | 101 kB     00:00    
(66/67): sssd-common-2.2.3-20.el8.x86_64.rpm                             5.1 MB/s | 1.5 MB     00:00    
(67/67): yum-4.2.17-7.el8_2.noarch.rpm                                   1.4 MB/s | 191 kB     00:00    
---------------------------------------------------------------------------------------------------------
Total                                                                    5.3 MB/s |  26 MB     00:04     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                 1/1 
  Installing       : libtalloc-2.2.0-7.el8.x86_64                                                   1/67 
  Installing       : libtevent-0.10.0-2.el8.x86_64                                                  2/67 
  Installing       : libtdb-1.4.2-2.el8.x86_64                                                      3/67 
  Running scriptlet: libtdb-1.4.2-2.el8.x86_64                                                      3/67 
  Installing       : libldb-2.0.7-3.el8.x86_64                                                      4/67 
  Installing       : libsss_certmap-2.2.3-20.el8.x86_64                                             5/67 
  Running scriptlet: libsss_certmap-2.2.3-20.el8.x86_64                                             5/67 
  Installing       : libsss_idmap-2.2.3-20.el8.x86_64                                               6/67 
  Running scriptlet: libsss_idmap-2.2.3-20.el8.x86_64                                               6/67 
  Installing       : libdhash-0.5.0-39.el8.x86_64                                                   7/67 
  Installing       : NetworkManager-libnm-1:1.22.8-5.el8_2.x86_64                                   8/67 
  Running scriptlet: NetworkManager-libnm-1:1.22.8-5.el8_2.x86_64                                   8/67 
  Running scriptlet: NetworkManager-1:1.22.8-5.el8_2.x86_64                                         9/67 
  Installing       : NetworkManager-1:1.22.8-5.el8_2.x86_64                                         9/67 
  Running scriptlet: NetworkManager-1:1.22.8-5.el8_2.x86_64                                         9/67 
  Installing       : sssd-nfs-idmap-2.2.3-20.el8.x86_64                                            10/67 
  Installing       : python3-slip-0.6.4-11.el8.noarch                                              11/67 
  Installing       : python3-slip-dbus-0.6.4-11.el8.noarch                                         12/67 
  Installing       : python3-librepo-1.11.0-3.el8_2.x86_64                                         13/67 
  Installing       : python3-dateutil-1:2.6.1-6.el8.noarch                                         14/67 
  Installing       : python3-dnf-plugins-core-4.0.12-4.el8_2.noarch                                15/67 
  Installing       : dnf-plugins-core-4.0.12-4.el8_2.noarch                                        16/67 
  Installing       : nftables-1:0.9.3-12.el8_2.1.x86_64                                            17/67 
  Running scriptlet: nftables-1:0.9.3-12.el8_2.1.x86_64                                            17/67 
  Installing       : python3-nftables-1:0.9.3-12.el8_2.1.x86_64                                    18/67 
  Installing       : python3-firewall-0.8.0-4.el8.noarch                                           19/67 
  Installing       : libsss_sudo-2.2.3-20.el8.x86_64                                               20/67 
  Running scriptlet: libsss_sudo-2.2.3-20.el8.x86_64                                               20/67 
  Installing       : libsss_nss_idmap-2.2.3-20.el8.x86_64                                          21/67 
  Running scriptlet: libsss_nss_idmap-2.2.3-20.el8.x86_64                                          21/67 
  Installing       : sssd-client-2.2.3-20.el8.x86_64                                               22/67 
  Running scriptlet: sssd-client-2.2.3-20.el8.x86_64                                               22/67 
  Installing       : libsss_autofs-2.2.3-20.el8.x86_64                                             23/67 
  Installing       : libgudev-232-4.el8.x86_64                                                     24/67 
  Installing       : iptables-ebtables-1.8.4-10.el8_2.1.x86_64                                     25/67 
  Running scriptlet: iptables-ebtables-1.8.4-10.el8_2.1.x86_64                                     25/67 
  Installing       : ipset-libs-7.1-1.el8.x86_64                                                   26/67 
  Running scriptlet: ipset-libs-7.1-1.el8.x86_64                                                   26/67 
  Installing       : ipset-7.1-1.el8.x86_64                                                        27/67 
  Installing       : firewalld-filesystem-0.8.0-4.el8.noarch                                       28/67 
  Installing       : c-ares-1.13.0-5.el8.x86_64                                                    29/67 
  Running scriptlet: c-ares-1.13.0-5.el8.x86_64                                                    29/67 
  Running scriptlet: sssd-common-2.2.3-20.el8.x86_64                                               30/67 
  Installing       : sssd-common-2.2.3-20.el8.x86_64                                               30/67 
  Running scriptlet: sssd-common-2.2.3-20.el8.x86_64                                               30/67 
  Installing       : python3-pyOpenSSL-18.0.0-1.el8.noarch                                         31/67 
  Installing       : python3-rhnlib-2.8.6-8.module_el8.1.0+211+ad6c0bc7.noarch                     32/67 
  Installing       : python3-newt-0.52.20-11.el8.x86_64                                            33/67 
  Installing       : python3-netifaces-0.10.6-4.el8.x86_64                                         34/67 
  Installing       : python3-hwdata-2.3.6-3.el8.noarch                                             35/67 
  Installing       : rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7.x86_64                 36/67 
  Running scriptlet: rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7.x86_64                 36/67 
  Installing       : python3-rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7.x86_64         37/67 
  Installing       : python3-dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch      38/67 
  Running scriptlet: dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch              39/67 
  Installing       : dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch              39/67 
  Running scriptlet: dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch              39/67 
  Installing       : plymouth-core-libs-0.9.3-16.el8.x86_64                                        40/67 
  Running scriptlet: plymouth-core-libs-0.9.3-16.el8.x86_64                                        40/67 
  Installing       : plymouth-scripts-0.9.3-16.el8.x86_64                                          41/67 
  Installing       : plymouth-0.9.3-16.el8.x86_64                                                  42/67 
  Installing       : sssd-kcm-2.2.3-20.el8.x86_64                                                  43/67 
  Running scriptlet: sssd-kcm-2.2.3-20.el8.x86_64                                                  43/67 
  Installing       : firewalld-0.8.0-4.el8.noarch                                                  44/67 
  Running scriptlet: firewalld-0.8.0-4.el8.noarch                                                  44/67 
  Installing       : NetworkManager-team-1:1.22.8-5.el8_2.x86_64                                   45/67 
  Installing       : NetworkManager-tui-1:1.22.8-5.el8_2.x86_64                                    46/67 
  Installing       : yum-4.2.17-7.el8_2.noarch                                                     47/67 
Error unpacking rpm package yum-4.2.17-7.el8_2.noarch
  Running scriptlet: rng-tools-6.8-3.el8.x86_64                                                    48/67 
error: unpacking of archive failed on file /etc/yum/protected.d: cpio: File from package already exists as a directory in system
error: yum-4.2.17-7.el8_2.noarch: install failed

  Installing       : rng-tools-6.8-3.el8.x86_64                                                    48/67 
  Running scriptlet: rng-tools-6.8-3.el8.x86_64                                                    48/67 
  Installing       : prefixdevname-0.1.0-6.el8.x86_64                                              49/67 
  Installing       : lsscsi-0.30-1.el8.x86_64                                                      50/67 
  Installing       : iwl7260-firmware-1:25.30.13.0-97.el8.1.noarch                                 51/67 
  Installing       : iwl6050-firmware-41.28.5.1-97.el8.1.noarch                                    52/67 
  Installing       : iwl6000g2a-firmware-18.168.6.1-97.el8.1.noarch                                53/67 
  Installing       : iwl6000-firmware-9.221.4.1-97.el8.1.noarch                                    54/67 
  Installing       : iwl5150-firmware-8.24.2.2-97.el8.1.noarch                                     55/67 
  Installing       : iwl5000-firmware-8.83.5.1_1-97.el8.1.noarch                                   56/67 
  Installing       : iwl4965-firmware-228.61.2.24-97.el8.1.noarch                                  57/67 
  Installing       : iwl3945-firmware-15.32.2.9-97.el8.1.noarch                                    58/67 
  Installing       : iwl3160-firmware-1:25.30.13.0-97.el8.1.noarch                                 59/67 
  Installing       : iwl2030-firmware-18.168.6.1-97.el8.1.noarch                                   60/67 
  Installing       : iwl2000-firmware-18.168.6.1-97.el8.1.noarch                                   61/67 
  Installing       : iwl135-firmware-18.168.6.1-97.el8.1.noarch                                    62/67 
  Installing       : iwl105-firmware-18.168.6.1-97.el8.1.noarch                                    63/67 
  Installing       : iwl1000-firmware-1:39.31.5.1-97.el8.1.noarch                                  64/67 
  Installing       : iwl100-firmware-39.31.5.1-97.el8.1.noarch                                     65/67 
  Installing       : iprutils-2.4.18.1-1.el8.x86_64                                                66/67 
  Running scriptlet: iprutils-2.4.18.1-1.el8.x86_64                                                66/67 
  Installing       : biosdevname-0.7.3-2.el8.x86_64                                                67/67 
  Running scriptlet: sssd-common-2.2.3-20.el8.x86_64                                               67/67 
  Running scriptlet: biosdevname-0.7.3-2.el8.x86_64                                                67/67 
  Verifying        : dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch               1/67 
  Verifying        : plymouth-0.9.3-16.el8.x86_64                                                   2/67 
  Verifying        : plymouth-core-libs-0.9.3-16.el8.x86_64                                         3/67 
  Verifying        : plymouth-scripts-0.9.3-16.el8.x86_64                                           4/67 
  Verifying        : python3-dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch       5/67 
  Verifying        : python3-hwdata-2.3.6-3.el8.noarch                                              6/67 
  Verifying        : python3-netifaces-0.10.6-4.el8.x86_64                                          7/67 
  Verifying        : python3-newt-0.52.20-11.el8.x86_64                                             8/67 
  Verifying        : python3-pyOpenSSL-18.0.0-1.el8.noarch                                          9/67 
  Verifying        : python3-rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7.x86_64         10/67 
  Verifying        : python3-rhnlib-2.8.6-8.module_el8.1.0+211+ad6c0bc7.noarch                     11/67 
  Verifying        : rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7.x86_64                 12/67 
  Verifying        : NetworkManager-1:1.22.8-5.el8_2.x86_64                                        13/67 
  Verifying        : NetworkManager-libnm-1:1.22.8-5.el8_2.x86_64                                  14/67 
  Verifying        : NetworkManager-team-1:1.22.8-5.el8_2.x86_64                                   15/67 
  Verifying        : NetworkManager-tui-1:1.22.8-5.el8_2.x86_64                                    16/67 
  Verifying        : biosdevname-0.7.3-2.el8.x86_64                                                17/67 
  Verifying        : c-ares-1.13.0-5.el8.x86_64                                                    18/67 
  Verifying        : dnf-plugins-core-4.0.12-4.el8_2.noarch                                        19/67 
  Verifying        : firewalld-0.8.0-4.el8.noarch                                                  20/67 
  Verifying        : firewalld-filesystem-0.8.0-4.el8.noarch                                       21/67 
  Verifying        : iprutils-2.4.18.1-1.el8.x86_64                                                22/67 
  Verifying        : ipset-7.1-1.el8.x86_64                                                        23/67 
  Verifying        : ipset-libs-7.1-1.el8.x86_64                                                   24/67 
  Verifying        : iptables-ebtables-1.8.4-10.el8_2.1.x86_64                                     25/67 
  Verifying        : iwl100-firmware-39.31.5.1-97.el8.1.noarch                                     26/67 
  Verifying        : iwl1000-firmware-1:39.31.5.1-97.el8.1.noarch                                  27/67 
  Verifying        : iwl105-firmware-18.168.6.1-97.el8.1.noarch                                    28/67 
  Verifying        : iwl135-firmware-18.168.6.1-97.el8.1.noarch                                    29/67 
  Verifying        : iwl2000-firmware-18.168.6.1-97.el8.1.noarch                                   30/67 
  Verifying        : iwl2030-firmware-18.168.6.1-97.el8.1.noarch                                   31/67 
  Verifying        : iwl3160-firmware-1:25.30.13.0-97.el8.1.noarch                                 32/67 
  Verifying        : iwl3945-firmware-15.32.2.9-97.el8.1.noarch                                    33/67 
  Verifying        : iwl4965-firmware-228.61.2.24-97.el8.1.noarch                                  34/67 
  Verifying        : iwl5000-firmware-8.83.5.1_1-97.el8.1.noarch                                   35/67 
  Verifying        : iwl5150-firmware-8.24.2.2-97.el8.1.noarch                                     36/67 
  Verifying        : iwl6000-firmware-9.221.4.1-97.el8.1.noarch                                    37/67 
  Verifying        : iwl6000g2a-firmware-18.168.6.1-97.el8.1.noarch                                38/67 
  Verifying        : iwl6050-firmware-41.28.5.1-97.el8.1.noarch                                    39/67 
  Verifying        : iwl7260-firmware-1:25.30.13.0-97.el8.1.noarch                                 40/67 
  Verifying        : libdhash-0.5.0-39.el8.x86_64                                                  41/67 
  Verifying        : libgudev-232-4.el8.x86_64                                                     42/67 
  Verifying        : libldb-2.0.7-3.el8.x86_64                                                     43/67 
  Verifying        : libsss_autofs-2.2.3-20.el8.x86_64                                             44/67 
  Verifying        : libsss_certmap-2.2.3-20.el8.x86_64                                            45/67 
  Verifying        : libsss_idmap-2.2.3-20.el8.x86_64                                              46/67 
  Verifying        : libsss_nss_idmap-2.2.3-20.el8.x86_64                                          47/67 
  Verifying        : libsss_sudo-2.2.3-20.el8.x86_64                                               48/67 
  Verifying        : libtalloc-2.2.0-7.el8.x86_64                                                  49/67 
  Verifying        : libtdb-1.4.2-2.el8.x86_64                                                     50/67 
  Verifying        : libtevent-0.10.0-2.el8.x86_64                                                 51/67 
  Verifying        : lsscsi-0.30-1.el8.x86_64                                                      52/67 
  Verifying        : nftables-1:0.9.3-12.el8_2.1.x86_64                                            53/67 
  Verifying        : prefixdevname-0.1.0-6.el8.x86_64                                              54/67 
  Verifying        : python3-dateutil-1:2.6.1-6.el8.noarch                                         55/67 
  Verifying        : python3-dnf-plugins-core-4.0.12-4.el8_2.noarch                                56/67 
  Verifying        : python3-firewall-0.8.0-4.el8.noarch                                           57/67 
  Verifying        : python3-librepo-1.11.0-3.el8_2.x86_64                                         58/67 
  Verifying        : python3-nftables-1:0.9.3-12.el8_2.1.x86_64                                    59/67 
  Verifying        : python3-slip-0.6.4-11.el8.noarch                                              60/67 
  Verifying        : python3-slip-dbus-0.6.4-11.el8.noarch                                         61/67 
  Verifying        : rng-tools-6.8-3.el8.x86_64                                                    62/67 
  Verifying        : sssd-client-2.2.3-20.el8.x86_64                                               63/67 
  Verifying        : sssd-common-2.2.3-20.el8.x86_64                                               64/67 
  Verifying        : sssd-kcm-2.2.3-20.el8.x86_64                                                  65/67 
  Verifying        : sssd-nfs-idmap-2.2.3-20.el8.x86_64                                            66/67 
  Verifying        : yum-4.2.17-7.el8_2.noarch                                                     67/67 

Installed:
  NetworkManager-1:1.22.8-5.el8_2.x86_64                                                                 
  NetworkManager-libnm-1:1.22.8-5.el8_2.x86_64                                                           
  NetworkManager-team-1:1.22.8-5.el8_2.x86_64                                                            
  NetworkManager-tui-1:1.22.8-5.el8_2.x86_64                                                             
  biosdevname-0.7.3-2.el8.x86_64                                                                         
  c-ares-1.13.0-5.el8.x86_64                                                                             
  dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch                                       
  dnf-plugins-core-4.0.12-4.el8_2.noarch                                                                 
  firewalld-0.8.0-4.el8.noarch                                                                           
  firewalld-filesystem-0.8.0-4.el8.noarch                                                                
  iprutils-2.4.18.1-1.el8.x86_64                                                                         
  ipset-7.1-1.el8.x86_64                                                                                 
  ipset-libs-7.1-1.el8.x86_64                                                                            
  iptables-ebtables-1.8.4-10.el8_2.1.x86_64                                                              
  iwl100-firmware-39.31.5.1-97.el8.1.noarch                                                              
  iwl1000-firmware-1:39.31.5.1-97.el8.1.noarch                                                           
  iwl105-firmware-18.168.6.1-97.el8.1.noarch                                                             
  iwl135-firmware-18.168.6.1-97.el8.1.noarch                                                             
  iwl2000-firmware-18.168.6.1-97.el8.1.noarch                                                            
  iwl2030-firmware-18.168.6.1-97.el8.1.noarch                                                            
  iwl3160-firmware-1:25.30.13.0-97.el8.1.noarch                                                          
  iwl3945-firmware-15.32.2.9-97.el8.1.noarch                                                             
  iwl4965-firmware-228.61.2.24-97.el8.1.noarch                                                           
  iwl5000-firmware-8.83.5.1_1-97.el8.1.noarch                                                            
  iwl5150-firmware-8.24.2.2-97.el8.1.noarch                                                              
  iwl6000-firmware-9.221.4.1-97.el8.1.noarch                                                             
  iwl6000g2a-firmware-18.168.6.1-97.el8.1.noarch                                                         
  iwl6050-firmware-41.28.5.1-97.el8.1.noarch                                                             
  iwl7260-firmware-1:25.30.13.0-97.el8.1.noarch                                                          
  libdhash-0.5.0-39.el8.x86_64                                                                           
  libgudev-232-4.el8.x86_64                                                                              
  libldb-2.0.7-3.el8.x86_64                                                                              
  libsss_autofs-2.2.3-20.el8.x86_64                                                                      
  libsss_certmap-2.2.3-20.el8.x86_64                                                                     
  libsss_idmap-2.2.3-20.el8.x86_64                                                                       
  libsss_nss_idmap-2.2.3-20.el8.x86_64                                                                   
  libsss_sudo-2.2.3-20.el8.x86_64                                                                        
  libtalloc-2.2.0-7.el8.x86_64                                                                           
  libtdb-1.4.2-2.el8.x86_64                                                                              
  libtevent-0.10.0-2.el8.x86_64                                                                          
  lsscsi-0.30-1.el8.x86_64                                                                               
  nftables-1:0.9.3-12.el8_2.1.x86_64                                                                     
  plymouth-0.9.3-16.el8.x86_64                                                                           
  plymouth-core-libs-0.9.3-16.el8.x86_64                                                                 
  plymouth-scripts-0.9.3-16.el8.x86_64                                                                   
  prefixdevname-0.1.0-6.el8.x86_64                                                                       
  python3-dateutil-1:2.6.1-6.el8.noarch                                                                  
  python3-dnf-plugin-spacewalk-2.8.5-11.module_el8.1.0+211+ad6c0bc7.noarch                               
  python3-dnf-plugins-core-4.0.12-4.el8_2.noarch                                                         
  python3-firewall-0.8.0-4.el8.noarch                                                                    
  python3-hwdata-2.3.6-3.el8.noarch                                                                      
  python3-librepo-1.11.0-3.el8_2.x86_64                                                                  
  python3-netifaces-0.10.6-4.el8.x86_64                                                                  
  python3-newt-0.52.20-11.el8.x86_64                                                                     
  python3-nftables-1:0.9.3-12.el8_2.1.x86_64                                                             
  python3-pyOpenSSL-18.0.0-1.el8.noarch                                                                  
  python3-rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7.x86_64                                  
  python3-rhnlib-2.8.6-8.module_el8.1.0+211+ad6c0bc7.noarch                                              
  python3-slip-0.6.4-11.el8.noarch                                                                       
  python3-slip-dbus-0.6.4-11.el8.noarch                                                                  
  rhn-client-tools-2.8.16-13.module_el8.1.0+211+ad6c0bc7.x86_64                                          
  rng-tools-6.8-3.el8.x86_64                                                                             
  sssd-client-2.2.3-20.el8.x86_64                                                                        
  sssd-common-2.2.3-20.el8.x86_64                                                                        
  sssd-kcm-2.2.3-20.el8.x86_64                                                                           
  sssd-nfs-idmap-2.2.3-20.el8.x86_64                                                                     

Failed:
  yum-4.2.17-7.el8_2.noarch                                                                              

Error: Transaction failed
[root@centos-prueba ~]#
```

Y al reiniciar el sistema, comprobamos la versión del sistema:

```
[root@centos-prueba centos]# cat /etc/redhat-release
CentOS Linux release 8.2.2004 (Core)
```

Y comprobamos también el kernel actualizado:

```
[centos@centos-prueba ~]$ uname -r
4.18.0-193.28.1.el8_2.x86_64
```

Y ya tendríamos el upgrade a CentOS 8.
