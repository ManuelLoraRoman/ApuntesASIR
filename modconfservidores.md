# Modificación del escenario de Openstack

Vamos a modificar el escenario que tenemos actualmente en OpenStack para que 
se adecúe a la realización de todas las prácticas en todos los módulos de 2º, 
en particular para que tenga una estructura más real a la de varios equipos 
detrás de un cortafuegos, separando los servidores en dos redes: red interna y 
DMZ. Para ello vamos a reutilizar todo lo hecho hasta ahora y añadiremos una 
máquina más: Frestón.


1.Creación de la red DMZ:
      * Nombre: DMZ de <nombre de usuario>
      * 10.0.2.0/24
2.Creación de las instancias:
      * freston:
           * Debian Buster sobre volumen de 10GB con sabor m1.mini
           * Conectada a la red interna
           * Accesible indirectamente a través de dulcinea
           * IP estática
3.Modificación de la ubicación de quijote
      * Pasa de la red interna a la DMZ y su direccionamiento tiene 
	que modificarse apropiadamente

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
root@manuel-lora:/home/debian# iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth2 -j MASQUERADE
```

Antes de meter a Freston en la nueva red, la incorporamos en nuestra red a la
que se le puede asignar una IP Flotante, para poder añadirle una contraseña al
usuario debian.

Una vez configurado esto, la quitamos de la red, y la metemos en la red 
anteriormente creada.
 
