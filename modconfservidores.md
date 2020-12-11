ç# Modificación del escenario de Openstack

Vamos a modificar el escenario que tenemos actualmente en OpenStack para que 
se adecúe a la realización de todas las prácticas en todos los módulos de 2º, 
en particular para que tenga una estructura más real a la de varios equipos 
detrás de un cortafuegos, separando los servidores en dos redes: red interna y 
DMZ. Para ello vamos a reutilizar todo lo hecho hasta ahora y añadiremos una 
máquina más: Frestón.


1. Creación de la red DMZ:

* Nombre: DMZ de nombre de usuario
* 10.0.2.0/24

2. Creación de las instancias:

* Debian Buster sobre volumen de 10GB con sabor m1.mini
* Conectada a la red interna
* Accesible indirectamente a través de dulcinea
* IP estática

3. Modificación de la ubicación de quijote

* Pasa de la red interna a la DMZ y su direccionamiento tiene que modificarse apropiadamente

En primer lugar, creamos la red DMZ de manuel-lora. Dicha red tendrá 
deshabilitada la opción de DHCP. Una vez hecho esto, le conectaremos a la
máquina de Dulcinea la interfaz de red de dicha red.

Ahora, nos conectaremos al cliente de openstack, y deshabilitaremos la seguridad
del puerto. Hay que tener en cuenta que el grupo de seguridad de la máquina
puede reiniciarse, y habría que deshabilitarlo de igual manera.

Nos conectamos a Dulcinea, y añadimos las siguientes lineas al fichero
_/etc/network/interfaces_:

```
auto eth2
iface eth2 inet static
 address 10.0.2.11
 netmask 255.255.255.0
 broadcast 10.0.2.255
 gateway 10.0.2.1
```

Reiniciamos el servicio y comprobamos que tenemos una dirección IP asociada a 
dicha interfaz de red:

```
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether fa:16:3e:d6:ab:7a brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.11/24 brd 10.0.2.255 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fed6:ab7a/64 scope link 
       valid_lft forever preferred_lft forever
```

Ahora configuramos de nuevo las reglas de iptable, y añadimos una nueva:

```
root@manuel-lora:/home/debian# iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth1 -j MASQUERADE
```

Antes de meter a Freston en la red de manuel-lora, la incorporamos en nuestra red a la
que se le puede asignar una IP Flotante, para poder añadirle una contraseña al
usuario debian.

Una vez configurado esto, la quitamos de la red, y la metemos en la red 
de manuel-lora. Como no hemos configurado el DHCP en la red y no
hemos puesto ninguna IP estática, no podremos conectarnos por ssh,
tendremos que conectarnos mediante la consola de horizon.

A continuación, editamos el fichero _/etc/network/interfaces_ de Freston y
le configuramos la IP estática:

```
auto eth0
iface eth0 inet static
 address 10.0.1.10
 netmask 255.255.255.0
 broadcast 10.0.1.255
 gateway 10.0.1.4
```

Reiniciamos el servicio networking y comprobamos la conectividad a las máquinas:

```
debian@freston:~$ ping quijote
PING quijote (10.0.2.10) 56(84) bytes of data.
64 bytes from quijote (10.0.2.10): icmp_seq=1 ttl=63 time=1.58 ms
64 bytes from quijote (10.0.2.10): icmp_seq=2 ttl=63 time=1.95 ms
64 bytes from quijote (10.0.2.10): icmp_seq=3 ttl=63 time=2.07 ms
^C
--- quijote ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 6ms
rtt min/avg/max/mdev = 1.579/1.869/2.074/0.210 ms
debian@freston:~$ ping dulcinea
PING dulcinea (10.0.1.4) 56(84) bytes of data.
64 bytes from dulcinea (10.0.1.4): icmp_seq=1 ttl=64 time=0.735 ms
64 bytes from dulcinea (10.0.1.4): icmp_seq=2 ttl=64 time=1.14 ms
64 bytes from dulcinea (10.0.1.4): icmp_seq=3 ttl=64 time=1.09 ms
^C
--- dulcinea ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 27ms
rtt min/avg/max/mdev = 0.735/0.987/1.136/0.179 ms
debian@freston:~$ ping sancho
PING sancho (10.0.1.11) 56(84) bytes of data.
64 bytes from sancho (10.0.1.11): icmp_seq=1 ttl=64 time=1.25 ms
64 bytes from sancho (10.0.1.11): icmp_seq=2 ttl=64 time=0.768 ms
64 bytes from sancho (10.0.1.11): icmp_seq=3 ttl=64 time=0.950 ms
^C
--- sancho ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 0.768/0.989/1.249/0.198 ms
```

Y desde Dulcinea, Sancho:

```
debian@manuel-lora:~$ ping freston
PING freston (10.0.1.10) 56(84) bytes of data.
64 bytes from freston (10.0.1.10): icmp_seq=1 ttl=64 time=0.917 ms
64 bytes from freston (10.0.1.10): icmp_seq=2 ttl=64 time=1.15 ms
64 bytes from freston (10.0.1.10): icmp_seq=3 ttl=64 time=1.31 ms
^C
--- freston ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 0.917/1.125/1.314/0.164 ms

ubuntu@sancho:~$ ping freston
PING freston (10.0.1.10) 56(84) bytes of data.
64 bytes from freston (10.0.1.10): icmp_seq=1 ttl=64 time=2.49 ms
64 bytes from freston (10.0.1.10): icmp_seq=2 ttl=64 time=0.741 ms
64 bytes from freston (10.0.1.10): icmp_seq=3 ttl=64 time=0.617 ms
64 bytes from freston (10.0.1.10): icmp_seq=4 ttl=64 time=0.549 ms
^C
--- freston ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 0.549/1.099/2.489/0.805 ms
```

Y ya estaría configurado la máquina Freston. (Adicionalmente hemos
configurado los /etc/hosts de todas las máquinas con los cambios
realizados).


También comprobamos que tenemos conexión a Internet desde Freston:

```
debian@freston:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=111 time=42.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=111 time=43.1 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 3ms
rtt min/avg/max/mdev = 42.612/42.840/43.069/0.308 ms
debian@freston:~$ ping www.google.es
PING www.google.es (172.217.17.3) 56(84) bytes of data.
64 bytes from mad07s09-in-f3.1e100.net (172.217.17.3): icmp_seq=1 ttl=112 time=44.9 ms
64 bytes from mad07s09-in-f3.1e100.net (172.217.17.3): icmp_seq=2 ttl=112 time=45.6 ms
64 bytes from mad07s09-in-f3.1e100.net (172.217.17.3): icmp_seq=3 ttl=112 time=45.7 ms
^C
--- www.google.es ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 44.851/45.364/45.669/0.440 ms
```

Comprobación del hostname:

```
debian@freston:~$ hostname
freston
```

Ahora, pasándonos al otro punto, debemos mover nuestra máquina 
Quijote hacia la red DMZ. Para ello, en primer lugar, le 
conectaremos una nueva interfaz de la red DMZ y después le 
quitaremos la interfaz que tenía.

Debido a que no está configurado su IP estática en la nueva red
debemos, mediante la consola de Horizon, realizar los cambios 
pertinentes.

Una vez dentro de Quijote, debemos modificar el fichero
_/etc/sysconfig/network-scripts/ifcfg-eth0_:

```
# Created by cloud-init on instance boot automatically, do not edit.
#
DEVICE="eth0"
BOOTPROTO="static"
IPADDR="10.0.2.10"
NETMASK="255.255.255.0"
NETWORK="10.0.2.0"
GATEWAY="10.0.2.11"
ONBOOT="yes"
TYPE="Ethernet"
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
~                                                                               
"/etc/sysconfig/network-scripts/ifcfg-eth0" 10L, 214C
``` 

Y reiniciamos el servicio network para que se apliquen los cambios.
Una vez hecho esto, aplicamos los cambios en los ficheros 
_/etc/hosts_ de las demás máquinas y comprobamos la conectividad:

```
debian@manuel-lora:~$ ssh -i .ssh/clave_openstack.pem centos@quijote
Warning: Permanently added the ECDSA host key for IP address '10.0.2.10' to the list of known hosts.
Last login: Fri Dec 11 19:16:05 2020
[centos@quijote ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=111 time=43.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=111 time=43.0 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=111 time=42.2 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 3ms
rtt min/avg/max/mdev = 42.178/42.933/43.607/0.610 ms
[centos@quijote ~]$ ping www.google.es
PING www.google.es (172.217.17.3) 56(84) bytes of data.
64 bytes from mad07s09-in-f3.1e100.net (172.217.17.3): icmp_seq=1 ttl=112 time=108 ms
64 bytes from mad07s09-in-f3.1e100.net (172.217.17.3): icmp_seq=2 ttl=112 time=45.0 ms
64 bytes from mad07s09-in-f3.1e100.net (172.217.17.3): icmp_seq=3 ttl=112 time=44.9 ms
^C
--- www.google.es ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 578ms
rtt min/avg/max/mdev = 44.947/65.961/107.920/29.670 ms
[centos@quijote ~]$ ping freston
PING freston (10.0.1.10) 56(84) bytes of data.
64 bytes from freston (10.0.1.10): icmp_seq=1 ttl=63 time=1.52 ms
64 bytes from freston (10.0.1.10): icmp_seq=2 ttl=63 time=1.59 ms
^C
--- freston ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 3ms
rtt min/avg/max/mdev = 1.519/1.552/1.586/0.051 ms
[centos@quijote ~]$ ping sancho
PING sancho (10.0.1.11) 56(84) bytes of data.
64 bytes from sancho (10.0.1.11): icmp_seq=1 ttl=63 time=2.59 ms
64 bytes from sancho (10.0.1.11): icmp_seq=2 ttl=63 time=1.47 ms
64 bytes from sancho (10.0.1.11): icmp_seq=3 ttl=63 time=1.53 ms
^C
--- sancho ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 6ms
rtt min/avg/max/mdev = 1.471/1.863/2.593/0.518 ms
[centos@quijote ~]$ ping dulcinea
PING dulcinea (10.0.2.11) 56(84) bytes of data.
64 bytes from dulcinea (10.0.2.11): icmp_seq=1 ttl=64 time=0.595 ms
64 bytes from dulcinea (10.0.2.11): icmp_seq=2 ttl=64 time=0.485 ms
64 bytes from dulcinea (10.0.2.11): icmp_seq=3 ttl=64 time=0.907 ms
^C
--- dulcinea ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 52ms
rtt min/avg/max/mdev = 0.485/0.662/0.907/0.179 ms
```

