# Utilización de cloud-init

Elige una instancia del escenario de OpenStack y vuelve a crearla utilizando 
el mismo volumen para el sistema raíz, pero realizando toda la configuración 
posible con cloud-init, de manera que la instancia permanezca bien configurada 
aunque se reinicie.

Sube a la tarea el fichero cloud-config utilizado.

Vamos a utilizar la instancia del cloud Sancho para la siguiente tarea.

En principio, vamos a configurar parte de cloud-init mediante netplan. Esto
se debe a que en el fichero de configuración de cloud-init, existe un parámetro
llamado renderers dentro de network:

```
system_info:
   # This will affect which distro class gets used
   distro: ubuntu
   # Default user name + that default users groups (if added/used)
   default_user:
     name: ubuntu
     lock_passwd: True
     gecos: Ubuntu
     groups: [adm, audio, cdrom, dialout, dip, floppy, lxd, netdev, plugdev, su>
     sudo: ["ALL=(ALL) NOPASSWD:ALL"]
     shell: /bin/bash
   network:
     renderers: ['netplan', 'eni', 'sysconfig']
```

Cloud-init utiliza alguno de esos tres formatos para realizar la configuración.
Netplan es utilizada para la configuración de red, ENI se utiliza para las
interfaces de red y es soportada por el paquete _ifupdown_. Por otro lado,
tenemos Sysconfig, que es el formato utilizado en RHEL, CentOS y otros tantos.
La configuración que tenemos que realizar en su mayoría es de red, por lo tanto,
las modificaciones las realizaremos mediante dicho formato.

Para modificar dicha instancia una vez creada, tenemos que realizar algunos
pasos. En primer lugar, si hemos modificado con anterioridad los servidores
DNS que tenemos en el fichero _/etc/netplan/50-cloud-init.yaml, debemos 
cambiarlos con la información que tenemos actualmente en el escenario. Es decir,
tenemos que introducir nada más las direcciones de papion (servidor del
instituto) y de freston (nuestro servidor dns).

```
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
      dhcp4: no
      addresses:
        - 10.0.1.11/24
      gateway4: 10.0.1.4
      nameservers:
          addresses: [192.168.202.2, 10.0.1.10]
```

A continuación, debemos dirigirnos al directorio de configuración de cloud,
y ahí editar el fichero _/etc/cloud/cloud.cfg_ y cambiar el parámetro
que nos permite mantener el hostname de nuestra máquina automáticamente:

```
# This will cause the set+update hostname module to not operate (if true)
preserve_hostname: true 
fqdn: sancho.manuel-lora.gonzalonazareno.org
hostname: sancho
```

También añadiremos las líneas correspondientes a el FQDN y nuestro hostname.

Una vez hecho esto, ya estaría lista la máquina, para que cuando se reinicie el
servicio de cloud-init, se carguen la información adecuada.

En nuestro caso, aún nos queda otro paso. En cierta tarea, nos vimos 
obligados a suspender temporalmente el servicio de cloud-init, y para ello,
creamos un fichero llamado _/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg_
el cual contenía la siguiente información:

```
network: {config: disable}
```

Esto nos permitia operar sin necesidad de preocuparnos por el servicio. Ahora, 
eliminamos dicho fichero ya que no nos es necesario.

Ahora vamos a comprobar que efectivamente, funciona la configuración
realizada:

```
ubuntu@sancho:/etc/cloud$ sudo systemctl restart cloud-init.service 
ubuntu@sancho:/etc/cloud$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8950 qdisc fq_codel state UP group default qlen 1000
    link/ether fa:16:3e:da:59:73 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.11/24 brd 10.0.1.255 scope global ens3
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:feda:5973/64 scope link 
       valid_lft forever preferred_lft forever
ubuntu@sancho:/etc/cloud$ cat /etc/hostname
sancho
ubuntu@sancho:/etc/cloud$ cat /etc/hosts
127.0.0.1 sancho.manuel-lora.gonzalonazareno.org sancho

10.0.2.10 quijote
10.0.1.4 dulcinea
10.0.1.10 freston

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
```
