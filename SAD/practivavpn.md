# VPN con OpenVPN y certificados x509

## Tarea 1: VPN de acceso remoto con OpenVPN y certificados x509

Para esta tarea puedes usar el fichero heat del primer ejercicio. En esta 
tarea vas a realizar el segundo ejercicio del tema:

Configura una conexión VPN de acceso remoto entre dos equipos:
    
* Uno de los dos equipos (el que actuará como servidor) estará conectado 
a dos redes.
    
* Para la autenticación de los extremos se usarán obligatoriamente certificados 
digitales, que se generarán utilizando openssl y se almacenarán en el 
directorio /etc/openvpn, junto con los parámetros Diffie-Helman y el 
certificado de la propia Autoridad de Certificación.
   
* Se utilizarán direcciones de la red 10.99.99.0/24 para las direcciones 
virtuales de la VPN. La dirección 10.99.99.1 se asignará al servidor VPN.
    
* Los ficheros de configuración del servidor y del cliente se crearán en el 
directorio /etc/openvpn de cada máquina, y se llamarán servidor.conf y 
cliente.conf respectivamente. La configuración establecida debe cumplir los 
siguientes aspectos:
        
- El demonio openvpn se manejará con systemctl.
- Se debe configurar para que la comunicación esté comprimida.
- La asignación de direcciones IP será dinámica.
- Existirá un fichero de log en el equipo.
- Se mandarán a los clientes las rutas necesarias.
   
* Tras el establecimiento de la VPN, la máquina cliente debe ser capaz de 
acceder a una máquina que esté en la otra red a la que está conectado el 
servidor.
   
* Instala el complemento de VPN en networkmanager y configura el cliente de 
forma gráfica desde este complemento.

En primer lugar, instalaremos el paquete de openvpn en el servidor:

```
root@vpn-server:/home/debian# apt-get install openvpn
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  easy-rsa libccid liblzo2-2 libpcsclite1 libpkcs11-helper1 libusb-1.0-0
  opensc opensc-pkcs11 pcscd
Suggested packages:
  pcmciautils openvpn-systemd-resolved
The following NEW packages will be installed:
  easy-rsa libccid liblzo2-2 libpcsclite1 libpkcs11-helper1 libusb-1.0-0
  opensc opensc-pkcs11 openvpn pcscd
0 upgraded, 10 newly installed, 0 to remove and 0 not upgraded.
Need to get 2,306 kB of archives.
After this operation, 6,508 kB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://deb.debian.org/debian buster/main amd64 easy-rsa all 3.0.6-1 [37.9 kB]
Get:2 http://deb.debian.org/debian buster/main amd64 libusb-1.0-0 amd64 2:1.0.22-2 [55.3 kB]
Get:3 http://deb.debian.org/debian buster/main amd64 libccid amd64 1.4.30-1 [334 kB]
Get:4 http://deb.debian.org/debian buster/main amd64 liblzo2-2 amd64 2.10-0.1 [56.1 kB]
Get:5 http://deb.debian.org/debian buster/main amd64 libpcsclite1 amd64 1.8.24-1 [58.5 kB]
Get:6 http://deb.debian.org/debian buster/main amd64 libpkcs11-helper1 amd64 1.25.1-1 [47.6 kB]
Get:7 http://deb.debian.org/debian buster/main amd64 opensc-pkcs11 amd64 0.19.0-1 [826 kB]
Get:8 http://deb.debian.org/debian buster/main amd64 opensc amd64 0.19.0-1 [305 kB]
Get:9 http://deb.debian.org/debian buster/main amd64 openvpn amd64 2.4.7-1 [490 kB]
Get:10 http://deb.debian.org/debian buster/main amd64 pcscd amd64 1.8.24-1 [95.3 kB]
Fetched 2,306 kB in 1s (1,971 kB/s)
Preconfiguring packages ...
Selecting previously unselected package easy-rsa.
(Reading database ... 27036 files and directories currently installed.)
Preparing to unpack .../0-easy-rsa_3.0.6-1_all.deb ...
Unpacking easy-rsa (3.0.6-1) ...
Selecting previously unselected package libusb-1.0-0:amd64.
Preparing to unpack .../1-libusb-1.0-0_2%3a1.0.22-2_amd64.deb ...
Unpacking libusb-1.0-0:amd64 (2:1.0.22-2) ...
Selecting previously unselected package libccid.
Preparing to unpack .../2-libccid_1.4.30-1_amd64.deb ...
Unpacking libccid (1.4.30-1) ...
Selecting previously unselected package liblzo2-2:amd64.
Preparing to unpack .../3-liblzo2-2_2.10-0.1_amd64.deb ...
Unpacking liblzo2-2:amd64 (2.10-0.1) ...
Selecting previously unselected package libpcsclite1:amd64.
Preparing to unpack .../4-libpcsclite1_1.8.24-1_amd64.deb ...
Unpacking libpcsclite1:amd64 (1.8.24-1) ...
Selecting previously unselected package libpkcs11-helper1:amd64.
Preparing to unpack .../5-libpkcs11-helper1_1.25.1-1_amd64.deb ...
Unpacking libpkcs11-helper1:amd64 (1.25.1-1) ...
Selecting previously unselected package opensc-pkcs11:amd64.
Preparing to unpack .../6-opensc-pkcs11_0.19.0-1_amd64.deb ...
Unpacking opensc-pkcs11:amd64 (0.19.0-1) ...
Selecting previously unselected package opensc.
Preparing to unpack .../7-opensc_0.19.0-1_amd64.deb ...
Unpacking opensc (0.19.0-1) ...
Selecting previously unselected package openvpn.
Preparing to unpack .../8-openvpn_2.4.7-1_amd64.deb ...
Unpacking openvpn (2.4.7-1) ...
Selecting previously unselected package pcscd.
Preparing to unpack .../9-pcscd_1.8.24-1_amd64.deb ...
Unpacking pcscd (1.8.24-1) ...
Setting up liblzo2-2:amd64 (2.10-0.1) ...
Setting up libpkcs11-helper1:amd64 (1.25.1-1) ...
Setting up opensc-pkcs11:amd64 (0.19.0-1) ...
Setting up libpcsclite1:amd64 (1.8.24-1) ...
Setting up libusb-1.0-0:amd64 (2:1.0.22-2) ...
Setting up easy-rsa (3.0.6-1) ...
Setting up openvpn (2.4.7-1) ...
[ ok ] Restarting virtual private network daemon.:.
Created symlink /etc/systemd/system/multi-user.target.wants/openvpn.service → /lib/systemd/system/openvpn.service.
Setting up libccid (1.4.30-1) ...
Setting up opensc (0.19.0-1) ...
Setting up pcscd (1.8.24-1) ...
Created symlink /etc/systemd/system/sockets.target.wants/pcscd.socket → /lib/systemd/system/pcscd.socket.
Processing triggers for mime-support (3.62) ...
Processing triggers for libc-bin (2.28-10) ...
Processing triggers for systemd (241-7~deb10u4) ...
```

Ahora vamos a crear una clave para la entidad certificadora. Dicha clave usará
el algoritmo de Diffie-Hellman, la cual permite acordar una clave secreta entre
dos máquinas a través de un canal inseguro y enviando únicamente dos mensajes.
La clave secreta resultante no podrá ser descubierta aunque se obtengan
ambos mensajes. Esto se debe a que el método de cifrado que utiliza, usa
números elevados a potencias específicas, lo que hace que sea matemáticamente
abrumador el descubrir dicha clave.

```
root@vpn-server:~# openssl dhparam -out dhparams.pem 4096
Generating DH parameters, 4096 bit long safe prime, generator 2
This is going to take a long time
...............................................................................$
.
.
.
root@vpn-server:~# ls
dhparams.pem
```

Acto seguido, vamos a activar el bit de forward en el servidor:

```
root@vpn-server:~# echo 1 > /proc/sys/net/ipv4/ip_forward
```

Después de esto, vamos a crear el fichero _/etc/openvpn/servidorvpn.com_:

```
dev tun
    
server 10.99.99.0 255.255.255.0 

push "route 192.168.1.0 255.255.255.0"

tls-server

dh /etc/openvpn/dhparams.pem

ca /etc/openvpn/ca.crt.pem

cert /etc/openvpn/VPN.crt

key /etc/openvpn/VPN.key

comp-lzo

keepalive 10 60

verb 3
```

Con anterioridad hemos creado los certificados y el _.csr_ pertinente para
nuestro cliente, y vamos a firmar la solicitud de certificado del equipo
en la lan de la siguiente manera:

```
root@vpn-server:/home/debian# openssl x509 -req -in lan.csr -CA /etc/openvpn/ca.cert.pem -CAkey /etc/openvpn/ca.key.pem -CAcreateserial -out VPNlan.cert
Signature ok
subject=C = sp, ST = Seville, L = Dos Hermanas, O = manuel, CN = manuel.iesgn.org
Getting CA Private Key
Enter pass phrase for /etc/openvpn/ca.key.pem:
```

También vamos a descomentar la siguiente linea en el fichero _/etc/default/openvpn_:

```
AUTOSTART="all"
```

Y reiniciamos el servicio. Hecho esto, debemos tener ya el servidor VPN ya
funcionando. Ahora vamos a pasar a la configuración del cliente. 
