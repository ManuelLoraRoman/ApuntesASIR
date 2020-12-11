# Práctica: Servidor DNS

## Escenario


1. En nuestra red local tenemos un servidor Web que sirve dos páginas web: 
_www.iesgn.org_, _departamentos.iesgn.org_.

Creamos dos virtualhost llamados de esa forma en la máquina donde está
alojado el servidor DNS.

Aquí están ambas configuraciones:

```
<VirtualHost *:80>
        ServerName www.iesgn.org  

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/iesgn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

<VirtualHost *:80>
        ServerName departamentos.iesgn.org

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/departamentos

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

```

2. Vamos a instalar en nuestra red local un servidor DNS (lo puedes instalar 
en el mismo equipo que tiene el servidor web).
  
3. Voy a suponer en este documento que el nombre del servidor DNS va a ser 
_pandora.iesgn.org_. El nombre del servidor de tu prácticas será 
_tunombre.iesgn.org_.


## Servidor DNSmasq

Instala el servidor dns dnsmasq en _pandora.iesgn.org_ y configúralo para que 
los clientes puedan conocer los nombres necesarios.


**Tarea 1:** Modifica los clientes para que utilicen el nuevo servidor dns.
Realiza una consulta a _www.iesgn.org_, y a _www.josedomingo.org_. Realiza una
prueba de funcionamiento para comprobar que el servidor dnsmasq funciona como
cache dns. Muestra el fichero hosts del cliente para demostrar que no estás
utilizando resolución estática. Realiza una consulta directa al servidor
dnsmasq. ¿Se puede realizar resolución inversa?. Documenta la tarea en redmine.

Nos descargaremos el paquete _dnsmasq_ para instalar dicho servidor.
Una vez está instalado, iniciamos el servicio con 
```sudo systemctl start dnsmasq```.

Ahora, nos dirigimos al fichero de configuración de dnsmasq, y tenemos que 
descomentar las siguientes lineas:

```
strict-order
interface=eth0
#address=/www.iesgn.org/127.0.0.1
#address=/departamentos.iesgn.org/127.0.0.1
listen-address=127.0.0.1
```

Descomentamos la linea de _strict-order_ para que se realicen las peticiones
DNS a los servidores que aparecen en el fichero _/etc/resolv.conf_ en el orden
en el que aparecen y la de _interface = eth0_ para aceptar dichas peticiones por
la interfaz especificada.

Descomentamos también las líneas de _address_ para indicar la ip de los nombres
de los servicios que ofrece y _listen-address_ para indicar la ip desde la que
queremos que acepte peticiones.

Las lineas de _address_ se pueden poner también en el fichero _/etc/hosts_ y es
así como lo que haremos:

```
172.22.201.0       www.iesgn.org
172.22.201.0       departamentos.iesgn.org
```

Ahora modificamos el fichero _/etc/resolv.conf_ y añadimos la siguiente línea:

```
nameserver 127.0.0.1
```

En nuestra máquina física, modificamos de la misma manera el fichero 
_/etc/resolv.conf_ pero en el caso del nameserver, pondremos la ip flotante 
de Openstack, en nuestro caso 172.22.201.0.

Y comprobamos:

```
manuel@debian:~$ dig www.iesgn.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> www.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47174
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.iesgn.org.			IN	A

;; ANSWER SECTION:
www.iesgn.org.		0	IN	A	10.0.0.10

;; Query time: 79 msec
;; SERVER: 172.22.201.0#53(172.22.201.0)
;; WHEN: vie nov 27 10:05:18 CET 2020
;; MSG SIZE  rcvd: 58

manuel@debian:~$ dig www.josedomingo.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> www.josedomingo.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 49197
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 5, ADDITIONAL: 6

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 72628b04d57fbd644861c2515fc0beb31e892d8f73d0da5f (good)
;; QUESTION SECTION:
;www.josedomingo.org.		IN	A

;; ANSWER SECTION:
www.josedomingo.org.	900	IN	CNAME	playerone.josedomingo.org.
playerone.josedomingo.org. 265	IN	A	137.74.161.90

;; AUTHORITY SECTION:
josedomingo.org.	13622	IN	NS	ns3.cdmon.net.
josedomingo.org.	13622	IN	NS	ns2.cdmon.net.
josedomingo.org.	13622	IN	NS	ns1.cdmon.net.
josedomingo.org.	13622	IN	NS	ns4.cdmondns-01.org.
josedomingo.org.	13622	IN	NS	ns5.cdmondns-01.com.

;; ADDITIONAL SECTION:
ns1.cdmon.net.		100022	IN	A	35.189.106.232
ns2.cdmon.net.		100022	IN	A	35.195.57.29
ns3.cdmon.net.		100022	IN	A	35.157.47.125
ns4.cdmondns-01.org.	13622	IN	A	52.58.66.183
ns5.cdmondns-01.com.	100022	IN	A	52.59.146.62

;; Query time: 148 msec
;; SERVER: 172.22.201.0#53(172.22.201.0)
;; WHEN: vie nov 27 09:54:11 CET 2020
;; MSG SIZE  rcvd: 322

```

Y de paso comprobamos la caché DNS:

```
manuel@debian:~$ dig www.josedomingo.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> www.josedomingo.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37148
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.josedomingo.org.		IN	A

;; ANSWER SECTION:
www.josedomingo.org.	236	IN	CNAME	playerone.josedomingo.org.
playerone.josedomingo.org. 897	IN	A	137.74.161.90

;; Query time: 92 msec
;; SERVER: 172.22.201.0#53(172.22.201.0)
;; WHEN: jue dic 03 08:49:12 CET 2020
;; MSG SIZE  rcvd: 103
```

Y para probar la resolución inversa:

```
manuel@debian:~$ dig -x 10.0.0.10

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> -x 10.0.0.10
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 555
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;10.0.0.10.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
10.0.0.10.in-addr.arpa.	0	IN	PTR	www.iesgn.org.

;; Query time: 79 msec
;; SERVER: 172.22.201.0#53(172.22.201.0)
;; WHEN: vie nov 27 10:05:45 CET 2020
;; MSG SIZE  rcvd: 78

```
## Servidor bind9

Desinstala el servidor dnsmasq del ejercicio anterior e instala un servidor 
dns bind9. Las características del servidor DNS que queremos instalar son las 
siguientes:

Desinstalamos el paquete _dnsmasq_ y nos instalaremos el paquete _bind9_.


* El servidor DNS se llama pandora.iesgn.org y por supuesto, va a ser el 
servidor con autoridad para la zona iesgn.org.
   
* Vamos a suponer que tenemos un servidor para recibir los correos que se 
llame _correo.iesgn.org_ y que está en la dirección x.x.x.200 (esto es 
ficticio).
   
* Vamos a suponer que tenemos un servidor ftp que se llame _ftp.iesgn.org_ y 
que está en x.x.x.201 (esto es ficticio)
   
* Además queremos nombrar a los clientes.
   
* También hay que nombrar a los virtual hosts de apache: _www.iesgn.org_ y 
departementos.iesgn.org
   
* Se tienen que configurar la zona de resolución inversa.


**Tarea 2:** Realiza la instalación y configuración del servidor bind9 con las 
características anteriomente señaladas. Entrega las zonas que has definido. 
Muestra al profesor su funcionamiento.

Realizamos la instalación del paquete _bind9_ y pasamos directamente a la 
configuración del servidor dns. Para ello, editamos el fichero de configuración
_/etc/bind/named.conf.local_:


```
zone "iesgn.org" {
type master;
file "db.iesgn.org";
};

zone "100.168.192.in-addr.arpa" {
type master;
file "db.192.168.100";
};
```

Una vez hecho esto, vamos a crear los dos ficheros que hemos indicado
anteriormente en el parámetro _file_ en la ruta /var/cache/bind.

El fichero _db.iesgn.org_ tendrá la siguiente configuración:

```
$TTL 86400      ; 1 day
@                       IN SOA pandora.iesgn.org. manuellora.iesgn.org. {
                                19423 ; serial
                                21600 ; refresh (6 hours)
                                3600 ; retry (1 hour)
                                604800 ; expire (1 week)
                                21600 ; minimum (6 hours)
                                )

@                       IN NS pandora.iesgn.org.
@                       IN MX 10 correo.iesgn.org.

$ORIGIN gonzalonazareno.org.
pandora         IN A 192.168.100.2
cliente         IN A 192.168.100.3
correo          IN A 192.168.100.200
ftp             IN A 192.168.100.201
www             IN CNAME pandora
departamentos   IN CNAME pandora
```

Y el fichero db.192.168.100 tendrá esta otra:

```
$TTL 86400              ; 1 day
@                               IN SOA pandora.iesgn.org. manuellora.iesgn.org. (
                                        12998 ; serial
                                        21600 ; refresh (6 hours)
                                        3600 ; retry (1 hour)
                                        604800 ; expire (1 week)
                                        21600 ; minimum (6 hours)
                                        )

@                               IN NS pandora.iesgn.org.

$ORIGIN 100.168.192.in-addr.arpa.
2       IN PTR pandora.iesgn.org.
2       IN PTR www.iesgn.org.
2       IN PTR departamentos.iesgn.org.
3       IN PTR cliente.iesgn.org.
200     IN PTR correo.iesgn.org.
201     IN PTR ftp.iesgn.org.
```

Creados ambos archivos, reiniciaremos el servicio de bind:

```
vagrant@pandora:/etc/bind$ sudo rndc reload
server reload successful
```

Y ahora, para comprobar si tenemos errores:

```
vagrant@pandora:/etc/bind$ sudo named-checkconf
vagrant@pandora:/etc/bind$ 
```

Ahora añadiremos en el cliente la siguiente linea en el fichero 
_/etc/resolv.conf_:

```
nameserver 192.168.100.2
```

Y ahora las comprobaciones:

* pandora.iesgn.org

```
cliente@debian:~$ dig pandora.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> pandora.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31799
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 747411bfee3e78c604a4f8335dd6ef00588627e6293cad4a (good)
;; QUESTION SECTION:
;pandora.iesgn.org.		IN	A

;; ANSWER SECTION:
pandora.iesgn.org.	86400	IN	A	192.168.100.2

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	pandora.iesgn.org.

;; Query time: 0 msec
;; SERVER: 192.168.100.2
;; WHEN: Wed Dec 9 20:09:36 GMT 2020
;; MSG SIZE  rcvd: 180
```

* www.iesgn.org

```
cliente@debian:~$ dig www.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> www.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 2941
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 2, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 5fdd43f94f505dce84f566365dd6ef11d3f6204fba65b043 (good)
;; QUESTION SECTION:
;www.iesgn.org.			IN	A

;; ANSWER SECTION:
www.iesgn.org.		86400	IN	CNAME	pandora.iesgn.org.
pandora.iesgn.org.	86400	IN	A	192.168.100.2

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	pandora.iesgn.org.

;; ADDITIONAL SECTION:
pandora.iesgn.org.	86400	IN	A	192.168.100.2

;; Query time: 0 msec
;; SERVER: 192.168.100.2
;; WHEN: Wed Dec 9 20:09:53 GMT 2020
;; MSG SIZE  rcvd: 218
```

* ftp.iesgn.org

```
cliente@debian:~$ dig ftp.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ftp.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31489
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: b57d092788cbf66ab66c48f75dd6ef209d09264d42d8830e (good)
;; QUESTION SECTION:
;ftp.iesgn.org.			IN	A

;; ANSWER SECTION:
ftp.iesgn.org.		86400	IN	A	192.168.100.201

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	pandora.iesgn.org.

;; ADDITIONAL SECTION:
pandora.iesgn.org.	86400	IN	A	192.168.100.2

;; Query time: 0 msec
;; SERVER: 192.168.100.2
;; WHEN: Wed Dec 9 20:10:08 GMT 2020
;; MSG SIZE  rcvd: 200
```

* ns iesgn.org

```
cliente@debian:~$ dig ns iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ns iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 20084
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: fc5fcd7efd2f72ad889357a25dd6ef60d0632a04e0c526f8 (good)
;; QUESTION SECTION:
;iesgn.org.			IN	NS

;; ANSWER SECTION:
iesgn.org.		86400	IN	NS	pandora.iesgn.org.

;; ADDITIONAL SECTION:
pandora.iesgn.org.	86400	IN	A	192.168.100.2

;; Query time: 0 msec
;; SERVER: 192.168.100.2
;; WHEN: Wed Dec 9 20:11:12 GMT 2020
;; MSG SIZE  rcvd: 180
```

* mx iesgn.org

```
cliente@debian:~$ dig mx iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> mx iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 58950
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 6

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 929c22370ef971c97110e1ca5dd6ef6d58c4448f2ea7eb23 (good)
;; QUESTION SECTION:
;iesgn.org.			IN	MX

;; ANSWER SECTION:
iesgn.org.		86400	IN	MX	10 correo.iesgn.org.

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	pandora.iesgn.org.

;; ADDITIONAL SECTION:
correo.iesgn.org.	86400	IN	A	192.168.100.200
pandora.iesgn.org.	86400	IN	A	192.168.100.2

;; Query time: 0 msec
;; SERVER: 192.168.100.2
;; WHEN: Wed Dec 9 20:11:25 GMT 2020
;; MSG SIZE  rcvd: 247
```

* Resolución inversa

```
cliente@debian:~$ dig -x 192.168.100.201

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> -x 192.168.100.201
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21638
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 56527d8aff6a60e8100d6afd5dd6ef98b70b63607709fec9 (good)
;; QUESTION SECTION:
;201.100.168.192.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
201.100.168.192.in-addr.arpa. 86400	IN	PTR	ftp.iesgn.org.

;; AUTHORITY SECTION:
100.168.192.in-addr.arpa.	86400	IN	NS	pandora.iesgn.org.

;; ADDITIONAL SECTION:
pandora.iesgn.org.	86400	IN	A	192.168.100.2

;; Query time: 1 msec
;; SERVER: 192.168.100.2
;; WHEN: Wed Dec 9 20:12:08 GMT 2020
;; MSG SIZE  rcvd: 221
```

* Página de josedomingo.org

```
cliente@debian:~$ dig www.josedomingo.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> www.josedomingo.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59101
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 5, ADDITIONAL: 6

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: c357db5fd9851eea25ed8e4a5dd6ef7d9cef233729e26b65 (good)
;; QUESTION SECTION:
;www.josedomingo.org.		IN	A

;; ANSWER SECTION:
www.josedomingo.org.	900	IN	CNAME	playerone.josedomingo.org.
playerone.josedomingo.org. 900	IN	A	137.74.161.90

;; AUTHORITY SECTION:
josedomingo.org.	86398	IN	NS	ns5.cdmondns-01.com.
josedomingo.org.	86398	IN	NS	ns3.cdmon.net.
josedomingo.org.	86398	IN	NS	ns2.cdmon.net.
josedomingo.org.	86398	IN	NS	ns4.cdmondns-01.org.
josedomingo.org.	86398	IN	NS	ns1.cdmon.net.

;; ADDITIONAL SECTION:
ns1.cdmon.net.		172798	IN	A	35.189.106.232
ns2.cdmon.net.		172798	IN	A	35.195.57.29
ns3.cdmon.net.		172798	IN	A	35.157.47.125
ns4.cdmondns-01.org.	86398	IN	A	52.58.66.183
ns5.cdmondns-01.com.	172799	IN	A	52.59.146.62

;; Query time: 3226 msec
;; SERVER: 192.168.100.2
;; WHEN: Wed Dec 9 22:11:41 GMT 2020
;; MSG SIZE  rcvd: 322
```


## Servidor DNS esclavo

El servidor DNS actual funciona como DNS maestro. Vamos a instalar un nuevo 
servidor DNS que va a estar configurado como DNS esclavo del anterior, donde 
se van a ir copiando periódicamente las zonas del DNS maestro. Suponemos que
el nombre del servidor DNS esclavo se va llamar _afrodita.iesgn.org_.

    
**Tarea 4:** Realiza la instalación del servidor DNS esclavo. Documenta los 
siguientes apartados:
       
* Entrega la configuración de las zonas del maestro y del esclavo.
   
En el servidor maestro, editamos el fichero _/etc/bind/named-conf.options_ y
añadimos la siguiente línea:

```
allow-transfer { none; };
```

Y a continuación, añadimos al fichero _/var/cache/bind/db.iesgn.org estas otras
lineas:

```
@               IN      NS      pandora-slave.iesgn.org.
pandora-slave IN      A       192.168.100.4
```
    
Y otras en el fichero de la resolución inversa las siguientes:

```
@       IN      NS      pandora-slave.iesgn.org.
4       IN      PTR     pandora-slave.iesgn.org.
```

Y habrá que modificar el fichero _/etc/bind/named.conf.local_ las siguientes 
lineas:

```
  allow-transfer { 192.168.100.4; };
  notify yes;
```

En el servidor esclavo, instalamos el paquete bind y vamos a editar el fichero 
_/etc/bind/named.conf.options_ con la siguiente linea:

```
allow-transfer { none; };
```

A continuación, añadiremos al fichero _/etc/bind/named.conf.local_ lo siguiente:

```
zone "iesgn.org"
{
  file "db.iesgn.org";
  type slave;
  masters { 192.168.100.2; };
};

zone "100.168.192.in-addr.arpa"
{
  file "db.100.168.192";
  type slave;
  masters { 192.168.100.2; };
}
```


* Comprueba si las zonas definidas en el maestro tienen algún error con el 
comando adecuado.
       
```
esclavo@debian:/etc/bind$ sudo named-checkzone iesgn.org /var/cache/bind/db.iesgn.org
zone iesgn.org/IN: loaded serial 6
OK
esclavo@debian:/etc/bind$ sudo named-checkzone iesgn.org /var/cache/bind/db.100.168.192
zone 100.168.192.in-addr.arpa"/IN: loaded serial 6
OK
```


* Comprueba si la configuración de named.conf tiene algún error con el comando 
adecuado.

```
esclavo@debian:/etc/bind$ sudo named-checkconf
esclavo@debian:/etc/bind$
```
       
* Reinicia los servidores y comprueba en los logs si hay algún error. No olvides
incrementar el número de serie en el registro SOA si has modificado la 
zona en el maestro.
       
* Muestra la salida del log donde se demuestra que se ha realizado la 
transferencia de zona.
   
```
sudo tail /var/log/syslog 
Dec 9 22:20:43 pandora named[1775]: zone 100.168.192.in-addr.arpa/IN: loaded serial 5
Dec 9 22:20:43 pandora named[1775]: zone 100.168.192.in-addr.arpa/IN: sending notifies (serial 5)
Dec 9 22:20:43 pandora named[1775]: running
Dec 9 22:20:43 pandora named[1775]: zone iesgn.org/IN: loaded serial 5
Dec 9 22:20:43 pandora named[1775]: zone iesgn.org/IN: sending notifies (serial 5)
Dec 9 22:20:43 pandora named[1775]: client @0x7fda40110a10 192.168.100.4#45329 (100.168.192.in-addr.arpa): transfer of '100.168.192.in-addr.arpa/IN': AXFR-style IXFR started (serial 5)
Dec 9 22:20:43 pandora named[1775]: client @0x7fda40110a10 192.168.100.4#45329 (100.168.192.in-addr.arpa): transfer of '100.168.192.in-addr.arpa/IN': AXFR-style IXFR ended
Dec 9 22:20:43 pandora named[1775]: managed-keys-zone: Key 20326 for zone . acceptance timer complete: key now trusted
Dec 9 22:20:43 pandora named[1775]: client @0x7fda40102280 192.168.100.4#41493 (iesgn.org): transfer of 'iesgn.org/IN': AXFR-style IXFR started (serial 5)
Dec 9 22:20:43 pandora named[1775]: client @0x7fda40102280 192.168.100.4#41493 (iesgn.org): transfer of 'iesgn.org/IN': AXFR-style IXFR ended
```


**Tarea 5:** Documenta los siguientes apartados:
        
* Configura un cliente para que utilice los dos servidores como servidores DNS.

Para ello, vamos a editar el fichero _/etc/resolv.conf_ de dicho cliente y pondremos:

```
nameserver 192.168.100.2
nameserver 192.168.100.4
```
       
* Realiza una consulta con dig tanto al maestro como al esclavo para comprobar 
que las respuestas son autorizadas. ¿En qué te tienes que fijar?
   
* Servidor maestro

```
cliente@debian:~$ dig @192.168.100.2 ftp.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @192.168.100.2 ftp.iesgn.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 49907
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: aa0ceb5ae636090191bbe8e75dd6f20f593467f75896453b (good)
;; QUESTION SECTION:
;ftp.iesgn.org.			IN	A

;; ANSWER SECTION:
ftp.iesgn.org.		86400	IN	A	192.168.100.201

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	pandora.iesgn.org.
iesgn.org.		86400	IN	NS	pandora-slave.iesgn.org.

;; ADDITIONAL SECTION:
pandora.iesgn.org.	86400	IN	A	192.168.100.2
pandora-slave.iesgn.org.  86400 IN	A	1192.168.100.4

;; Query time: 1 msec
;; SERVER: 192.168.100.2#53(192.168.100.2)
;; WHEN: Wed Dec 9 23:22:39 GMT 2020
;; MSG SIZE  rcvd: 200
```

* Servidor esclavo

```
cliente@debian:~$ dig @192.168.100.4 ftp.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @192.168.100.4 ftp.iesgn.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 44257
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 69c0d47ca4121ec973850aa45dd6f227d9bb555f4c66dc5c (good)
;; QUESTION SECTION:
;ftp.iesgn.org.			IN	A

;; ANSWER SECTION:
ftp.iesgn.org.		86400	IN	A	192.168.100.201

;; AUTHORITY SECTION:
iesgn.org.		86400	IN	NS	pandora-slave.iesgn.org.
iesgn.org.		86400	IN	NS	pandora.iesgn.org.

;; ADDITIONAL SECTION:
pandora.iesgn.org.	86400	IN	A	192.168.100.2
pandora-slave.iesgn.org.  86400 IN	A	192.168.100.4

;; Query time: 1 msec
;; SERVER: 192.168.100.4#53(192.168.100.4)
;; WHEN: Wed Dec 9 23:23:03 GMT 2020
;; MSG SIZE  rcvd: 200
```
    
Nos tenemos que fijar en que dependiendo de la consulta que realizes, te sale primero el maestro o el
esclavo.


* Solicita una copia completa de la zona desde el cliente ¿qué tiene que 
ocurrir?. Solicita una copia completa desde el esclavo ¿qué tiene que ocurrir?
   
Para realizar la copia completa desde el cliente, hacemos lo siguiente:

```
cliente@debian:~$ dig @192.168.100.4 iesgn.org axfr

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @192.168.100.2 iesgn.org axfr
; (1 server found)
;; global options: +cmd
; Transfer failed.

cliente@debian:~$ dig @192.168.100.2 iesgn.org axfr

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @192.168.100.2 iesgn.org axfr
; (1 server found)
;; global options: +cmd
; Transfer failed.
```

Desde el cliente no nos devuelve nada ya que el cliente no debería tener una zona completa.

Para realizar la copia completa desde el esclavo, realizamos lo siguiente:

```
cliente@debian:~$ dig @192.168.100.2 iesgn.org axfr

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> @192.168.100.2 iesgn.org axfr
; (1 server found)
;; global options: +cmd
iesgn.org.		86400	IN	SOA	pandora.iesgn.org. manuellora.iesgn.org. 5 604800 86400 2419200 86400
iesgn.org.		86400	IN	NS	pandora.iesgn.org.
iesgn.org.		86400	IN	NS	pandora-slave.iesgn.org.
iesgn.org.		86400	IN	MX	10 correo.iesgn.org.
pandora.iesgn.org.	86400	IN	A	192.168.100.2
pandora-slave.iesgn.org. 86400  IN	A	192.168.100.4
cliente.iesgn.org.	86400	IN	A	192.168.100.3
correo.iesgn.org.	86400	IN	A	192.168.100.200
departamentos.iesgn.org. 86400	IN	CNAME	pandora.iesgn.org.
ftp.iesgn.org.		86400	IN	A	192.168.100.201
www.iesgn.org.		86400	IN	CNAME	pandora.iesgn.org.
iesgn.org.		86400	IN	SOA	pandora.iesgn.org. manuellora.iesgn.org. 5 604800 86400 2419200 86400
;; Query time: 2 msec
;; SERVER: 192.168.100.2#53(192.168.100.2)
;; WHEN: Wed Dec 9 23:28:46 GMT 2020
;; XFR size: 22 records (messages 1, bytes 634)
```

**Tarea 6: Muestra al profesor el funcionamiento del DNS esclavo:
       
* Realiza una consulta desde el cliente y comprueba que servidor está 
respondiendo.

* Posteriormente apaga el servidor maestro y vuelve a realizar una consulta 
desde el cliente ¿quién responde?

Como se puede comprobar, aparece después de parar el servicio DNS del servidor maestro, el primero en
_AUTHORITY SECTION_.

```
vagrant@pandora:/etc/bind$ dig ftp.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ftp.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 600
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: f3faf6100bf2e9ec89a1c70c5dd5aaf84fdc6510fab76970 (good)
;; QUESTION SECTION:
;ftp.iesgn.org.			IN	A

;; ANSWER SECTION:
ftp.iesgn.org.		604800	IN	A	192.168.100.201

;; AUTHORITY SECTION:
iesgn.org.		604800	IN	NS	pandora.iesgn.org.
iesgn.org.		604800	IN	NS	pandora-slave.iesgn.org.

;; ADDITIONAL SECTION:
pandora.iesgn.org.	604800	IN	A	192.168.100.2
pandora-slave.iesgn.org. 604800 IN	A	192.168.100.4

;; Query time: 1 msec
;; SERVER: 192.168.100.2#53(192.168.100.2)
;; WHEN: Wed Dec 9 23:40:04 GMT 2020
;; MSG SIZE  rcvd: 200
```

Paramos el servicio de bind9. Y volvemos a hacer el dig:

```
vagrant@pandora:/etc/bind$ dig ftp.iesgn.org

; <<>> DiG 9.11.5-P4-5.1-Debian <<>> ftp.iesgn.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 52501
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 4

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: beb100cc6cea2f01ad745ad95dd5ab5d56c96398d6fb7c9d (good)
;; QUESTION SECTION:
;ftp.iesgn.org.			IN	A

;; ANSWER SECTION:
ftp.iesgn.org.		604800	IN	A	192.168.100.201

;; AUTHORITY SECTION:
iesgn.org.		604800	IN	NS	pandora-slave.iesgn.org.
iesgn.org.		604800	IN	NS	pandora.iesgn.org.

;; ADDITIONAL SECTION:
pandora.iesgn.org.	604800	IN	A	192.168.100.2
pandora-slave.iesgn.org. 604800 IN	A	192.168.100.4

;; Query time: 1 msec
;; SERVER: 192.168.100.4#53(192.168.100.4)
;; WHEN: Wed Dec 9 23:43:45 GMT 2020
;; MSG SIZE  rcvd: 200
```

## Delegación de dominios

Tenemos un servidor DNS que gestiona la zona correspondiente al nombre de 
dominio iesgn.org, en esta ocasión queremos delegar el subdominio 
informatica.iesgn.org para que lo gestione otro servidor DNS. Por lo tanto 
tenemos un escenario con dos servidores DNS:

* pandora.iesgn.org, es servidor DNS autorizado para la zona iesgn.org.
    
* ns.informatica.iesgn.org, es el servidor DNS para la zona 
informatica.iesgn.org y, está instalado en otra máquina.

Los nombres que vamos a tener en ese subdominio son los siguientes:

* www.informatica.iesgn.org corresponde a un sitio web que está alojado en el 
servidor web del departamento de informática.
   
* Vamos a suponer que tenemos un servidor ftp que se llame 
ftp.informatica.iesgn.org y que está en la misma máquina.
   
* Vamos a suponer que tenemos un servidor para recibir los correos que se 
llame correo.informatica.iesgn.org.

**Tarea 7:** Realiza la instalación y configuración del nuevo servidor dns 
con las características anteriormente señaladas. Muestra el resultado al 
profesor.

* Configuración del servidor Maestro:

Añadimos al fichero _/var/cache/bind/db.iesgn.org_ las siguientes lineas:

```
$ORIGIN informatica.iesgn.org.

@               IN    NS    pandora-sub
pandora-sub	IN    A     192.168.100.5
```

* Configuración del subdominio:

Realizamos los mismos pasos que en el inicio del ejercicio de bind9 para que al final nos quede el
siguiente resultado:

- Fichero _/etc/bind/named.conf.local_:

```
zone "informatica.iesgn.org"
{
  type master;
  file "db.informatica.iesgn.org";
};
```

- Fichero _/var/cache/bind/db.informatica.iesgn.org_:

```
$TTL 86400              ; 1 day
@                               IN SOA pandora-sub.informatica.iesgn.org. manuellora.iesgn.org. (
                                        12998 ; serial
                                        21600 ; refresh (6 hours)
                                        3600 ; retry (1 hour)
                                        604800 ; expire (1 week)
                                        21600 ; minimum (6 hours)
                                        )

@       IN      NS      pandora-sub.informatica.iesgn.org.
@       IN      MX  10  correo.informatica.iesgn.org.

$ORIGIN informatica.iesgn.org.

pandora-sub	IN      A        192.168.100.5
```

**Tarea 8:** Realiza las consultas dig/neslookup desde los clientes 
preguntando por los siguientes:
       
* Dirección de www.informatica.iesgn.org, ftp.informatica.iesgn.org
       
* El servidor DNS que tiene configurado la zona del dominio 
informatica.iesgn.org. ¿Es el mismo que el servidor DNS con autoridad para la 
zona iesgn.org?
       
* El servidor de correo configurado para informatica.iesgn.org


