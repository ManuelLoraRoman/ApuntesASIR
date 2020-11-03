# Configuración de cliente OpenVPN con certificados X.509

Para poder acceder a la red local desde el exterior, existe una red privada 
configurada con OpenVPN que utiliza certificados x509 para autenticar los 
usuarios y el servidor.

* Genera una clave privada RSA 4096

* Genera una solicitud de firma de certificado (fichero CSR) y súbelo a
gestiona.

Ejecutaremos el siguiente comando en la terminal de nuestra máquina para la
creación de nuestra clave privada (como root):

```
root@debian:/media/manuel/Datos/Cosas Seguridad/VPN# openssl genrsa 4096 > /etc/ssl/private/debian-manuel.key
Generating RSA private key, 4096 bit long modulus (2 primes)
..............................................................................................................................................................................................................................................++++
...............................++++
e is 65537 (0x010001)
```

Y después para la generación del SCR:

```
root@debian:/media/manuel/Datos/Cosas Seguridad/VPN# openssl req -new -key /etc/ssl/private/debian-manuel.key -out /root/debian-manuel.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ES
State or Province Name (full name) [Some-State]:Sevilla
Locality Name (eg, city) []:Dos Hermanas
Organization Name (eg, company) [Internet Widgits Pty Ltd]:IES Gonzalo Nazareno
Organizational Unit Name (eg, section) []:Informatica
Common Name (e.g. server FQDN or YOUR name) []:debian-manuel.lora
Email Address []:manuelloraroman@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:1q2w3e4r5t
An optional company name []:
```

Y ya tendríamos generada nuestra clave y una solicituda de firma de certificado.
    
* Descarga el certificado firmado cuando esté disponible

Nos descargaremos el certificado ya firmado _debian-manuel.crt_ y lo guardaremos
en la ubicación del directorio _/etc/openvpn_.

```
manuel@debian:/etc/openvpn$ ls
client  debian-manuel.crt  server  update-resolv-conf
```
    
* Instala y configura apropiadamente el cliente openvpn y muestra los 
registros (logs) del sistema que demuestren que se ha establecido una conexión.
    
Instalaremos el paquete _openvpn_ y crearemos un fichero _.conf_ (en nuestro
caso se llama sputnik.conf) con la siguiente información:

```
dev tun
remote sputnik.gonzalonazareno.org
ifconfig 172.23.0.0 255.255.255.0
pull
proto tcp-client
tls-client
remote-cert-tls server
ca /etc/ssl/certs/gonzalonazareno.pem            
cert /etc/openvpn/debian-manuel.crt
key /etc/ssl/private/debian-manuel.key
comp-lzo
keepalive 10 60
log /var/log/openvpn-sputnik.log
verb 1
```

Y reiniciamos el servicio de OpenVPN y comprobamos que se ha creado la regla de
encaminamiento para acceder a los equipos de la 172.22.0.0/16.

```
manuel@debian:/etc/openvpn$ ip r
default via 172.22.0.1 dev enp3s0 proto dhcp metric 100 
169.254.0.0/16 dev enp3s0 scope link metric 1000 
172.22.0.0/16 via 172.23.0.77 dev tun0 
172.22.0.0/16 dev enp3s0 proto kernel scope link src 172.22.6.15 metric 100 
172.23.0.1 via 172.23.0.77 dev tun0 
172.23.0.77 dev tun0 proto kernel scope link src 172.23.0.78 
```

Y comprobamos también los mensajes del fichero /var/log/openvpn-sputnik.log:

```
Tue Nov  3 12:02:08 2020 WARNING: file '/etc/ssl/private/debian-manuel.key' is group or others accessible
Tue Nov  3 12:02:08 2020 OpenVPN 2.4.7 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Feb 20 2019
Tue Nov  3 12:02:08 2020 library versions: OpenSSL 1.1.1d  10 Sep 2019, LZO 2.10
Tue Nov  3 12:02:08 2020 WARNING: using --pull/--client and --ifconfig together is probably not what you want
Tue Nov  3 12:02:08 2020 TCP/UDP: Preserving recently used remote address: [AF_INET]92.222.86.77:1194
Tue Nov  3 12:02:08 2020 Attempting to establish TCP connection with [AF_INET]92.222.86.77:1194 [nonblock]
Tue Nov  3 12:02:09 2020 TCP connection established with [AF_INET]92.222.86.77:1194
Tue Nov  3 12:02:09 2020 TCP_CLIENT link local: (not bound)
Tue Nov  3 12:02:09 2020 TCP_CLIENT link remote: [AF_INET]92.222.86.77:1194
Tue Nov  3 12:02:09 2020 [sputnik.gonzalonazareno.org] Peer Connection Initiated with [AF_INET]92.222.86.77:1194
Tue Nov  3 12:02:11 2020 TUN/TAP device tun0 opened
Tue Nov  3 12:02:11 2020 /sbin/ip link set dev tun0 up mtu 1500
Tue Nov  3 12:02:11 2020 /sbin/ip addr add dev tun0 local 172.23.0.78 peer 172.23.0.77
Tue Nov  3 12:02:11 2020 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Tue Nov  3 12:02:11 2020 Initialization Sequence Completed
```

* Cuando hayas establecido la conexión VPN tendrás acceso a la red 
172.22.0.0/16 a través de un túnel SSL. Compruébalo haciendo ping a 172.22.0.1.

Ya una vez configurado, haremos ping a la dirección 172.22.0.1:

```
manuel@debian:~$ ping 172.22.0.1
PING 172.22.0.1 (172.22.0.1) 56(84) bytes of data.
64 bytes from 172.22.0.1: icmp_seq=1 ttl=63 time=82.5 ms
64 bytes from 172.22.0.1: icmp_seq=2 ttl=63 time=82.8 ms
64 bytes from 172.22.0.1: icmp_seq=3 ttl=63 time=78.9 ms
64 bytes from 172.22.0.1: icmp_seq=4 ttl=63 time=80.6 ms
64 bytes from 172.22.0.1: icmp_seq=5 ttl=63 time=78.4 ms
64 bytes from 172.22.0.1: icmp_seq=6 ttl=63 time=117 ms
64 bytes from 172.22.0.1: icmp_seq=7 ttl=63 time=270 ms
64 bytes from 172.22.0.1: icmp_seq=8 ttl=63 time=108 ms
^C
--- 172.22.0.1 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 19ms
rtt min/avg/max/mdev = 78.363/112.240/269.811/61.107 ms
```


