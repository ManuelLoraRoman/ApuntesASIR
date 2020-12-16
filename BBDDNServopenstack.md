# Servidores Web, Base de Datos y DNS.

## Servidor DNS

Primero de todo, instalaremos el paquete bind9 en nuestra máquina freston.

Después, vamos a configurar el fichero _/etc/bind/named.conf.local_ para tener
las diferentes vistas:

```
view interna {
    match-clients { 10.0.1.0/24; };
    allow-recursion { any; };

        zone "manuel-lora.gonzalonazareno.org"
        {
                type master;
                file "db.interna.gonzalonazareno.org";
        };
        zone "1.0.10.in-addr.arpa"
        {
                type master;
                file "db.1.0.10";
        };
        zone "2.0.10.in-addr.arpa"
        {
                type master;
                file "db.2.0.10";
        };
        include "/etc/bind/zones.rfc1918";
        include "/etc/bind/named.conf.default-zones";
};

view externa {
    match-clients { 172.22.0.0/15; 192.168.202.2;};
    allow-recursion { any; };

        zone "manuel-lora.gonzalonazareno.org"
        {
                type master;
                file "db.externa.gonzalonazareno.org";
        };
        include "/etc/bind/zones.rfc1918";
        include "/etc/bind/named.conf.default-zones";
};

view DMZ {
    match-clients { 10.0.2.0/24; };
    allow-recursion { any; };

        zone "manuel-lora.gonzalonazareno.org"
        {
                type master;
                file "db.DMZ.gonzalonazareno.org";
        };
        zone "2.0.10.in-addr.arpa"
        {
                type master;
                file "db.2.0.10";
        };
        zone "1.0.10.in-addr.arpa"
        {
                type master;
                file "db.1.0.10";
        };
        include "/etc/bind/zones.rfc1918";
        include "/etc/bind/named.conf.default-zones";
};
```

Debemos a su vez, comentar la siguiente línea del fichero 
_/etc/bind/named.conf_:

```
// include "/etc/bind/named.conf.default-zones";
```

Ahora, crearemos los diferentes ficheros en _/var/cache/bind_:

* db.interna.gonzalonazareno.org

```
$TTL    86400
@   IN  SOA freston.manuel-lora.gonzalonazareno.org. manuelloraroman.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@               IN  NS  freston.manuel-lora.gonzalonazareno.org.

$ORIGIN manuel-lora.gonzalonazareno.org.
dulcinea        IN      A       10.0.1.4
sancho          IN      A       10.0.1.11
freston         IN      A       10.0.1.10
quijote         IN      A       10.0.2.10
www             IN      CNAME   quijote
bd              IN      CNAME   sancho
```

* db.externa.gonzalonazareno.org

```
$TTL    86400
@   IN  SOA freston.manuel-lora.gonzalonazareno.org. manuelloraroman.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@               IN      NS      dulcinea.manuel-lora.gonzalonazareno.org.

$ORIGIN manuel-lora.gonzalonazareno.org.
dulcinea        IN      A       172.22.200.146
www             IN      CNAME   dulcinea
```

* db.DMZ.gonzalonazareno.org

```
$TTL    86400
@   IN  SOA freston.manuel-lora.gonzalonazareno.org. manuelloraroman.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@               IN      NS      freston.manuel-lora.gonzalonazareno.org.

$ORIGIN manuel-lora.gonzalonazareno.org.
dulcinea        IN      A       10.0.2.11
sancho          IN      A       10.0.1.11
freston         IN      A       10.0.1.10
quijote         IN      A       10.0.2.10
www             IN      CNAME   quijote
bd              IN      CNAME   sancho
```

* db.1.0.10

```
$TTL    86400
@   IN  SOA freston.manuel-lora.gonzalonazareno.org. manuelloraroman.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@                       IN      NS  freston.manuel-lora.gonzalonazareno.org.

$ORIGIN 1.0.10.in-addr.arpa.
4       IN      PTR     dulcinea.manuel-lora.gonzalonazareno.org.
11      IN      PTR     sancho.manuel-lora.gonzalonazareno.org.
10      IN      PTR     freston.manuel-lora.gonzalonazareno.org.
```

* db.2.0.10

```
$TTL    86400
@   IN  SOA freston.manuel-lora.gonzalonazareno.org. manuelloraroman.gonzalonazareno.org. {
                  1     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
              86400 )   ; Negative Cache TTL
;
@                       IN      NS  freston.manuel-lora.gonzalonazareno.org.

$ORIGIN 2.0.10.in-addr.arpa.
10      IN      PTR     quijote.manuel-lora.gonzalonazareno.org.
11      IN      PTR     dulcinea.manuel-lora.gonzalonazareno.org.
```


Configuramos también las reglas de iptable DNAT en dulcinea:

```
debian@dulcinea:~$ sudo iptables -t nat -A PREROUTING -p udp --dport 53 -i eth1 -j DNAT --to 10.0.1.10
debian@dulcinea:~$ sudo iptables -t nat -A PREROUTING -p tcp --dport 53 -i eth1 -j DNAT --to 10.0.1.10
```

Y ahora vamos a comprobar que funciona el DNS. 
Instalamos en las diferentes máquinas el paquete _dnsutils_
y para CentOS 8 instalaremos _bind-utils_ y comprobamos:

* Consulta desde el exterior:

```
manuel@debian:~/.ssh$ dig @10.0.0.4 dulcinea.manuel-lora.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> @10.0.0.4 dulcinea.manuel-lora.gonzalonazareno.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60514
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;dulcinea.manuel-lora.gonzalonazareno.org. IN A

;; ANSWER SECTION:
dulcinea.manuel-lora.gonzalonazareno.org. 900 IN CNAME macaco.gonzalonazareno.org.
macaco.gonzalonazareno.org. 900	IN	A	80.59.1.152

;; Query time: 70 msec
;; SERVER: 10.0.0.4#53(10.0.0.4)
;; WHEN: mar dic 15 21:24:44 CET 2020
;; MSG SIZE  rcvd: 106
```

* Consulta red interna:

```
debian@dulcinea:~$ dig sancho.manuel-lora.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> sancho.manuel-lora.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 14762
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: dd68191eca0b4aa4cf0109a75fd91c5ed2043e2f1a1f6045 (good)
;; QUESTION SECTION:
;sancho.manuel-lora.gonzalonazareno.org.	IN A

;; ANSWER SECTION:
sancho.manuel-lora.gonzalonazareno.org.	86400 IN A 10.0.1.11

;; AUTHORITY SECTION:
manuel-lora.gonzalonazareno.org. 86400 IN NS	freston.manuel-lora.gonzalonazareno.org.

;; ADDITIONAL SECTION:
freston.manuel-lora.gonzalonazareno.org. 86400 IN A 10.0.1.10

;; Query time: 3 msec
;; SERVER: 10.0.1.10#53(10.0.1.10)
;; WHEN: Tue Dec 15 20:28:14 UTC 2020
;; MSG SIZE  rcvd: 149
```

```
debian@dulcinea:~$ dig quijote.manuel-lora.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> quijote.manuel-lora.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 10735
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 0082ee534b89bf367c0e3dd25fd91c9773d8a40649424ca3 (good)
;; QUESTION SECTION:
;quijote.manuel-lora.gonzalonazareno.org. IN A

;; ANSWER SECTION:
quijote.manuel-lora.gonzalonazareno.org. 86400 IN A 10.0.2.10

;; AUTHORITY SECTION:
manuel-lora.gonzalonazareno.org. 86400 IN NS	freston.manuel-lora.gonzalonazareno.org.

;; ADDITIONAL SECTION:
freston.manuel-lora.gonzalonazareno.org. 86400 IN A 10.0.1.10

;; Query time: 1 msec
;; SERVER: 10.0.1.10#53(10.0.1.10)
;; WHEN: Tue Dec 15 20:29:11 UTC 2020
;; MSG SIZE  rcvd: 150
```

```
debian@dulcinea:~$ dig freston.manuel-lora.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> freston.manuel-lora.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53459
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: f9d421dca3d711b0375bf3e55fd9224a92998c96eb0fbb29 (good)
;; QUESTION SECTION:
;freston.manuel-lora.gonzalonazareno.org. IN A

;; ANSWER SECTION:
freston.manuel-lora.gonzalonazareno.org. 86400 IN A 10.0.1.10

;; AUTHORITY SECTION:
manuel-lora.gonzalonazareno.org. 86400 IN NS	freston.manuel-lora.gonzalonazareno.org.

;; Query time: 2 msec
;; SERVER: 10.0.1.10#53(10.0.1.10)
;; WHEN: Tue Dec 15 20:53:30 UTC 2020
;; MSG SIZE  rcvd: 126
```

* Red DMZ:

```
[centos@quijote ~]$ dig dulcinea.manuel-lora.gonzalonazareno.org

; <<>> DiG 9.11.20-RedHat-9.11.20-5.el8 <<>> dulcinea.manuel-lora.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 18991
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 5d083a5d3662a33ed2f1e3c15fd93e942e144f5ad63b409e (good)
;; QUESTION SECTION:
;dulcinea.manuel-lora.gonzalonazareno.org. IN A

;; ANSWER SECTION:
dulcinea.manuel-lora.gonzalonazareno.org. 86400	IN A 10.0.2.11

;; AUTHORITY SECTION:
manuel-lora.gonzalonazareno.org. 86400 IN NS	freston.manuel-lora.gonzalonazareno.org.

;; ADDITIONAL SECTION:
freston.manuel-lora.gonzalonazareno.org. 86400 IN A 10.0.1.10

;; Query time: 2 msec
;; SERVER: 10.0.1.10#53(10.0.1.10)
;; WHEN: Tue Dec 15 22:54:12 UTC 2020
;; MSG SIZE  rcvd: 151
```

* Resolución inversa:

```
[centos@quijote httpd]$ dig -x 10.0.1.11

; <<>> DiG 9.11.20-RedHat-9.11.20-5.el8 <<>> -x 10.0.1.11
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54472
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 0df922daeea4e5861516e74e5fd9f893d5e593d86d3da7b5 (good)
;; QUESTION SECTION:
;11.1.0.10.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
11.1.0.10.in-addr.arpa.	86400	IN	PTR	sancho.manuel-lora.gonzalonazareno.org.

;; AUTHORITY SECTION:
1.0.10.in-addr.arpa.	86400	IN	NS	freston.manuel-lora.gonzalonazareno.org.

;; ADDITIONAL SECTION:
freston.manuel-lora.gonzalonazareno.org. 86400 IN A 10.0.1.10

;; Query time: 3 msec
;; SERVER: 10.0.1.10#53(10.0.1.10)
;; WHEN: Wed Dec 16 12:07:47 UTC 2020
;; MSG SIZE  rcvd: 169
```

```
debian@dulcinea:~$ dig -x 10.0.1.10

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> -x 10.0.1.10
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6640
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: f247cc74949209a8a83062215fd9fe259350d7c12bb27910 (good)
;; QUESTION SECTION:
;10.1.0.10.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
10.1.0.10.in-addr.arpa.	86400	IN	PTR	freston.manuel-lora.gonzalonazareno.org.

;; AUTHORITY SECTION:
1.0.10.in-addr.arpa.	86400	IN	NS	freston.manuel-lora.gonzalonazareno.org.

;; ADDITIONAL SECTION:
freston.manuel-lora.gonzalonazareno.org. 86400 IN A 10.0.1.10

;; Query time: 2 msec
;; SERVER: 10.0.1.10#53(10.0.1.10)
;; WHEN: Wed Dec 16 12:31:33 UTC 2020
;; MSG SIZE  rcvd: 162
```

```

```

Ahora vamos a configurar las máquinas para que usen el DNS (configuramos el fichero _/etc/resolv.conf_.

* Dulcinea

```
nameserver 10.0.1.10
nameserver 192.168.202.2
domain manuel-lora.gonzalonazareno.org
search manuel-lora.gonzalonazareno.org
```

* Freston

```
nameserver 10.0.1.10
nameserver 192.168.202.2
domain manuel-lora.gonzalonazareno.org
search manuel-lora.gonzalonazareno.org
```

* Sancho

```
nameserver 10.0.1.10
nameserver 192.168.202.2
domain manuel-lora.gonzalonazareno.org
search manuel-lora.gonzalonazareno.org
```

* Quijote

```
search manuel-lora.gonzalonazareno.org
nameserver 10.0.1.10 
search openstacklocal
nameserver 192.168.202.2
```

Hemos configurado el FQDN de cada máquina para que al ejecutar el comando ```hostname -f```
nos salga lo siguiente:

* Dulcinea

```
debian@dulcinea:~$ hostname -f
dulcinea.manuel-lora.gonzalonazareno.org
```

* Freston

```
debian@freston:/etc/bind$ hostname -f
freston.manuel-lora.gonzalonazareno.org
```

* Sancho

```
ubuntu@sancho:~$ hostname -f
sancho.manuel-lora.gonzalonazareno.org
```

* Quijote

```
[centos@quijote ~]$ hostname -f
quijote.manuel-lora.gonzalonazareno.org
```

Y por último, delegamos la zona a Papion. Una vez hecho esto, vamos a realizar
las consultas preguntando a papion:

* Dulcinea:

```

```

* Freston:

```

```

* Sancho:

```

```

* Quijote:

```

```

## Servidor Web

En quijote (CentOs)(Servidor que está en la DMZ) vamos a instalar un servidor 
web apache. Configura el servidor para que sea capaz de ejecutar código php 
(para ello vamos a usar un servidor de aplicaciones php-fpm). Entrega una 
captura de pantalla accediendo a www.tunombre.gonzalonazareno.org/info.php donde
se vea la salida del fichero info.php. Investiga la reglas DNAT de cortafuegos 
que tienes que configurar en dulcinea para, cuando accedemos a la IP flotante 
se acceda al servidor web.

Para instalar el servidor web de Apache2 en CentOS 8 debemos instalar el
siguiente paquete:

```
[centos@quijote ~]$ sudo dnf install httpd
Last metadata expiration check: 0:54:04 ago on Tue 15 Dec 2020 10:17:14 PM UTC.
Dependencies resolved.
================================================================================
 Package           Arch   Version                               Repo       Size
================================================================================
Installing:
 httpd             x86_64 2.4.37-30.module_el8.3.0+561+97fdbbcc AppStream 1.7 M
Installing dependencies:
 apr               x86_64 1.6.3-11.el8                          AppStream 125 k
 apr-util          x86_64 1.6.1-6.el8                           AppStream 105 k
 centos-logos-httpd
                   noarch 80.5-2.el8                            BaseOS     24 k
 httpd-filesystem  noarch 2.4.37-30.module_el8.3.0+561+97fdbbcc AppStream  37 k
 httpd-tools       x86_64 2.4.37-30.module_el8.3.0+561+97fdbbcc AppStream 104 k
 mailcap           noarch 2.1.48-3.el8                          BaseOS     39 k
 mod_http2         x86_64 1.15.7-2.module_el8.3.0+477+498bb568  AppStream 154 k
Installing weak dependencies:
 apr-util-bdb      x86_64 1.6.1-6.el8                           AppStream  25 k
 apr-util-openssl  x86_64 1.6.1-6.el8                           AppStream  27 k
Enabling module streams:
 httpd                    2.4                                                  

Transaction Summary
================================================================================
Install  10 Packages

Total download size: 2.3 M
Installed size: 6.0 M
Is this ok [y/N]: y
.
.
.
Installed:
  apr-1.6.3-11.el8.x86_64                                                       
  apr-util-1.6.1-6.el8.x86_64                                                   
  apr-util-bdb-1.6.1-6.el8.x86_64                                               
  apr-util-openssl-1.6.1-6.el8.x86_64                                           
  centos-logos-httpd-80.5-2.el8.noarch                                          
  httpd-2.4.37-30.module_el8.3.0+561+97fdbbcc.x86_64                            
  httpd-filesystem-2.4.37-30.module_el8.3.0+561+97fdbbcc.noarch                 
  httpd-tools-2.4.37-30.module_el8.3.0+561+97fdbbcc.x86_64                      
  mailcap-2.1.48-3.el8.noarch                                                   
  mod_http2-1.15.7-2.module_el8.3.0+477+498bb568.x86_64                         

Complete!
```

Una vez terminada la instalación, iniciamos el servicio _httpd_:

```
[centos@quijote ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```

CentOS 8 tiene activado el firewall por defecto, así que si queremos permitir
el acceso tendremos que añadir los servicios http y https a la
configuración del firewall:

```
[centos@quijote ~]$ sudo firewall-cmd --permanent --add-service={http,https}
success
```

Y ya tendríamos acceso al servidor web de Apache desde fuera de la máquina CentOS.

Ahora vamos a configurar Apache, y para ello, tenemos que dirigirnos al
directorio _/etc/httpd/conf_ y editar el fichero httpd.conf.

Miraremos el parámetro DocumentRoot y vamos a cambiarla a:

```
DocumentRoot "/var/www/manuel-lora"
```

Modificaremos también el parámetro de ServerName para que se ajuste al
ejercicio:

```
ServerName www.manuel-lora.gonzalonazareno.org:80
```

Y para crear el VirtualHost debemos hacer lo siguiente:

1. Creamos un directorio _/etc/httpd/sites-available/_ y _/etc/httpd/sites-enabled_:

```
[centos@quijote ~]$ sudo mkdir /etc/httpd/sites-available
[centos@quijote ~]$ sudo mkdir /etc/httpd/sites-enabled
[centos@quijote httpd]$ ls
conf    conf.modules.d  modules  sites-available  state
conf.d  logs            run      sites-enabled
```

Y volveremos a editar el fichero _httpd.conf_ y añadimos la siguiente
línea al final del mismo:

```
IncludeOptional	sites-enabled/*.conf
```

2. Creamos el bloque en el directorio _/etc/httpd/conf.d/www.manuel-lora.gonzalonazareno.conf_:

```
<VirtualHost *:80>
        ServerName www.manuel-lora.gonzalonazareno.org
        DocumentRoot /var/www/manuel-lora
        <Directory /var/www/manuel-lora>
                Options -Indexes
                AllowOverride all
                Require all granted
        </Directory>
        ErrorLog /var/log/httpd/error_www.manuel-lora.gonzalonazareno.log
        CustomLog /var/log/httpd/access_www.manuel-lora.gonzalonazareno.log combined
</VirtualHost>
```

Y reiniciamos el servicio de apache2.

## Servidor de Base de Datos

En sancho (Ubuntu) vamos a instalar un servidor de base de datos mariadb 
(bd.tu_nombre.gonzalonazareno.org). Entrega una prueba de funcionamiento donde 
se vea como se realiza una conexión a la base de datos desde quijote.
