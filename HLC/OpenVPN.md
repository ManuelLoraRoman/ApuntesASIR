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

* Cuando hayas establecido la conexión VPN tendrás acceso a la red 
172.22.0.0/16 a través de un túnel SSL. Compruébalo haciendo ping a 172.22.0.1.




