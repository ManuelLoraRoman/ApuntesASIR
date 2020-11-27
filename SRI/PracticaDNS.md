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

**Tarea 3:** Realiza las consultas dig/nslookup desde los clientes preguntando 
por los siguientes:

   
* Dirección de pandora.iesgn.org, www.iesgn.org, ftp.iesgn.org.
   
* El servidor DNS con autoridad sobre la zona del dominio iesgn.org.
   
* El servidor de correo configurado para iesgn.org.
   
* La dirección IP de _www.josedomingo.org_.
   
* Una resolución inversa.


## Servidor DNS esclavo

El servidor DNS actual funciona como DNS maestro. Vamos a instalar un nuevo 
servidor DNS que va a estar configurado como DNS esclavo del anterior, donde 
se van a ir copiando periódicamente las zonas del DNS maestro. Suponemos que 
el nombre del servidor DNS esclavo se va llamar _afrodita.iesgn.org_.

    
**Tarea 4:** Realiza la instalación del servidor DNS esclavo. Documenta los 
siguientes apartados:
       
* Entrega la configuración de las zonas del maestro y del esclavo.
       
* Comprueba si las zonas definidas en el maestro tienen algún error con el 
comando adecuado.
       
* Comprueba si la configuración de named.conf tiene algún error con el comando 
adecuado.
       
* Reinicia los servidores y comprueba en los logs si hay algún error. No olvides
incrementar el número de serie en el registro SOA si has modificado la 
zona en el maestro.
       
* Muestra la salida del log donde se demuestra que se ha realizado la 
transferencia de zona.
   
**Tarea 5:** Documenta los siguientes apartados:
        
* Configura un cliente para que utilice los dos servidores como servidores DNS.
       
* Realiza una consulta con dig tanto al maestro como al esclavo para comprobar 
que las respuestas son autorizadas. ¿En qué te tienes que fijar?
       
* Solicita una copia completa de la zona desde el cliente ¿qué tiene que 
ocurrir?. Solicita una copia completa desde el esclavo ¿qué tiene que ocurrir?
   
**Tarea 6: Muestra al profesor el funcionamiento del DNS esclavo:
       
* Realiza una consulta desde el cliente y comprueba que servidor está 
respondiendo.

* Posteriormente apaga el servidor maestro y vuelve a realizar una consulta 
desde el cliente ¿quién responde?


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

**Tarea 8:** Realiza las consultas dig/neslookup desde los clientes 
preguntando por los siguientes:
       
* Dirección de www.informatica.iesgn.org, ftp.informatica.iesgn.org
       
* El servidor DNS que tiene configurado la zona del dominio 
informatica.iesgn.org. ¿Es el mismo que el servidor DNS con autoridad para la 
zona iesgn.org?
       
* El servidor de correo configurado para informatica.iesgn.org


