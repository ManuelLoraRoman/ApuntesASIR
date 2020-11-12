# Instalación y configuración inicial de los servidores


**Tarea 1:** Creación de la red interna:

	1.1. Nombre red interna de <nombre de usuario>
	1.2. 10.0.1.0/24
 
En primer lugar nos iremos a Openstack, y en el apartado de _RED --> Redes_
seleccionaremos la opción de _Crear red_.

Crearemos una red llamada _red de manuel-lora_ con las siguientes opciones:

* Nombre: red de manuel-lora

* Estado de administración: ARRIBA

* Crear subred: TRUE

* Direcciones de red: 10.0.1.0/24

* Versión de IP: IPv4

Y ya tendriamos nuestra red operativa:

![alt text](../Imágenes/redmanuellora.png)
   
**Tarea 2:** Creación de las instancias

Antes de la creación de ninguna máquina, vamos a crear 3 volúmenes de imagen
de Debian Buster 10.6, Ubuntu 20.04 LTS y CentOS 7, con una capacidad de 
4, 6 y 16 GiB respectivamente.

Estas operaciones las podemos realizar en la pestaña de Openstack _COMPUTE --> Volúmenes --> Crear Volumen_

![alt text](../Imágenes/volumenesstack.png)
        
	2.1. Dulcinea:
           2.1.1. Debian Buster sobre volumen con sabor m1.mini
           2.1.2. Accesible directamente a través de la red externa y con una 
		  IP flotante
           2.1.3. Conectada a la red interna, de la que será la puerta de enlace
        
	
Crearemos la máquina con las respectivas configuracion anteriormente comentadas,
y nos quedaría una máquina como esta:

![alt text](../Imágenes/dulcinea1.png)
	
Y una comprobación de conectividad:

```
manuel@debian:~/.ssh$ ssh -i clave_openstack.pem debian@172.22.200.146
The authenticity of host '172.22.200.146 (172.22.200.146)' can't be established.
ECDSA key fingerprint is SHA256:KyvO3NYfqO8qxyViGkVvjnNtS01PAd1WUN8xzo+Umxk.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.22.200.146' (ECDSA) to the list of known hosts.
Linux dulcinea 4.19.0-11-cloud-amd64 #1 SMP Debian 4.19.146-1 (2020-09-17) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
debian@dulcinea:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8950 qdisc pfifo_fast state UP group default qlen 1000
    link/ether fa:16:3e:f3:34:21 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.4/24 brd 10.0.1.255 scope global dynamic eth0
       valid_lft 86256sec preferred_lft 86256sec
    inet6 fe80::f816:3eff:fef3:3421/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8950 qdisc pfifo_fast state UP group default qlen 1000
    link/ether fa:16:3e:87:e0:77 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.9/24 brd 10.0.0.255 scope global dynamic eth1
       valid_lft 86256sec preferred_lft 86256sec
    inet6 fe80::f816:3eff:fe87:e077/64 scope link 
       valid_lft forever preferred_lft forever
debian@dulcinea:~$ 
```

	2.2. Sancho:
            2.2.1. Ubuntu 20.04 sobre volumen con sabor m1.mini
            2.2.2. Conectada a la red interna
            2.2.3. Accesible indirectamente a través de dulcinea

Crearemos la siguiente máquina siguiendo las mismas directrices que los puntos
marcados.

Al final, la máquina Sancho debería quedar de la siguiente manera:

![alt text](../Imágenes/sancho1.png)

Pasaremos el par de claves a la máquina de Dulcinea mediante scp para poder 
realizar la conectividad desde ahí. 

Una vez hecho esto, vamos a comprobar la conectividad desde Dulcinea y desde
nuestra máquina:

```
debian@dulcinea:~$ ssh -i .ssh/clave_openstack.pem ubuntu@10.0.1.11
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-48-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat Nov  7 16:46:54 UTC 2020

  System load:  0.17              Processes:             96
  Usage of /:   21.8% of 5.64GB   Users logged in:       0
  Memory usage: 38%               IPv4 address for ens3: 10.0.1.11
  Swap usage:   0%


1 update can be installed immediately.
0 of these updates are security updates.
To see these additional updates run: apt list --upgradable


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Sat Nov  7 16:46:43 2020 from 10.0.1.4
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@sancho:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8950 qdisc fq_codel state UP group default qlen 1000
    link/ether fa:16:3e:da:59:73 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.11/24 brd 10.0.1.255 scope global dynamic ens3
       valid_lft 85440sec preferred_lft 85440sec
    inet6 fe80::f816:3eff:feda:5973/64 scope link 
       valid_lft forever preferred_lft forever
ubuntu@sancho:~$ 
```
        2.3. Quijote:
            2.3.1. CentOS 7 sobre volumen con sabor m1.mini
            2.3.2. Conectada a la red interna
            2.3.3. Accesible indirectamente a través de dulcinea

Haremos lo mismo que con las otras dos máquinas y tendría que quedarnos así:

![alt text](../Imágenes/quijote1.png)

Y la comprobación de la conectividad:

```
debian@dulcinea:~$ ssh -i .ssh/clave_openstack.pem centos@10.0.1.12
The authenticity of host '10.0.1.12 (10.0.1.12)' can't be established.
ECDSA key fingerprint is SHA256:zfaz5ovbe6LO0PqUB9Xa6mL/vurmZT6K61ym+WWcFXY.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.0.1.12' (ECDSA) to the list of known hosts.
[centos@quijote ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8950 qdisc pfifo_fast state UP group default qlen 1000
    link/ether fa:16:3e:db:75:33 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.12/24 brd 10.0.1.255 scope global dynamic eth0
       valid_lft 86367sec preferred_lft 86367sec
    inet6 fe80::f816:3eff:fedb:7533/64 scope link 
       valid_lft forever preferred_lft forever
[centos@quijote ~]$ 
```
    
**Tarea 3:** Configuración de NAT en Dulcinea (Es necesario deshabilitar la 
seguridad en todos los puertos de dulcinea) [[https://youtu.be/jqfILWzHrS0]]
    
Iniciaremos openstack desde la terminal. Una vez lo tengamos configurado,
vamos a eliminar el grupo de seguridad configurado desde openstack de la
máquina Dulcinea de la siguiente manera:

```
(openstackclient) manuel@debian:~$ openstack server remove security group Dulcinea default
```

De esta manera comprobaremos que no tenemos conectividad con Dulcinea:

```
(openstackclient) manuel@debian:~$ ping 172.22.200.146
PING 172.22.200.146 (172.22.200.146) 56(84) bytes of data.
^C
--- 172.22.200.146 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 54ms

(openstackclient) manuel@debian:~$ ssh -i .ssh/clave_openstack.pem debian@172.22.200.146
^C
```

A continuación, vamos a listar los puertos y elegiremos la dirección MAC 
correspondiente a la máquina Dulcinea, para después realizar:

```
(openstackclient) manuel@debian:~$ openstack port set --disable-port-security 17ad903c-923a-4dec-88e5-285022b42da1
```

Como hemos deshabilitado la seguridad de los puertos, volvemos a tener
conectividad:

```
(openstackclient) manuel@debian:~$ ping 172.22.200.146
PING 172.22.200.146 (172.22.200.146) 56(84) bytes of data.
64 bytes from 172.22.200.146: icmp_seq=1 ttl=61 time=230 ms
64 bytes from 172.22.200.146: icmp_seq=2 ttl=61 time=254 ms
64 bytes from 172.22.200.146: icmp_seq=3 ttl=61 time=111 ms
64 bytes from 172.22.200.146: icmp_seq=4 ttl=61 time=199 ms
^C
--- 172.22.200.146 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 4ms
rtt min/avg/max/mdev = 110.790/198.613/254.447/54.348 ms
(openstackclient) manuel@debian:~$ ssh -i .ssh/clave_openstack.pem debian@172.22.200.146
Linux dulcinea 4.19.0-11-cloud-amd64 #1 SMP Debian 4.19.146-1 (2020-09-17) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Nov 10 17:19:39 2020 from 172.23.0.78
debian@dulcinea:~$
```

Realizada la deshabilitación de puertos, vamos a pasar a la configuración de NAT.
En Dulcinea, para que está pueda funcionar como dispositivo de NAT, hay que 
activar el bit de forward:

```
root@dulcinea:/home/debian# echo 1 > /proc/sys/net/ipv4/ip_forward
```

Esta configuración es volátil, por lo tanto, la definiremos en el fichero
_/etc/sysctl.conf_:

```
# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1
```

Ahora definimos en la cadena POSTROUTING lo siguiente:

```
iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o eth0 -j MASQUERADE
```

**Tarea 4:** Definición de contraseña en todas las instancias (para poder 
modificarla desde consola en caso necesario)

Para configurar las contraseñas de las máquinas es necesario ejecutar el 
comando ```sudo passwd```. Aquí las comprobaciones:

* Dulcinea

```
debian@dulcinea:~$ sudo passwd
New password: 
Retype new password: 
passwd: password updated successfully
debian@dulcinea:~$ 
```
    
* Sancho

```
ubuntu@sancho:~$ sudo passwd
New password: 
Retype new password: 
passwd: password updated successfully
ubuntu@sancho:~$ 
```

* Quijote

```
[centos@quijote ~]$ sudo passwd
Changing password for user root.
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: all authentication tokens updated successfully.
[centos@quijote ~]$
```

**Tarea 5:** Modificación de las instancias sancho y quijote para que usen 
direccionamiento estático y dulcinea como puerta de enlace
    
**Tarea 6:** Modificación de la subred de la red interna, deshabilitando el 
servidor DHCP
    
**Tarea 7:** Utilización de ssh-agent para acceder a las instancias
    
**Tarea 8:** Creación del usuario profesor en todas las instancias. Usuario 
que puede utilizar sudo sin contraseña
    
**Tarea 9:** Copia de las claves públicas de todos los profesores en las 
instancias para que puedan acceder con el usuario profesor

