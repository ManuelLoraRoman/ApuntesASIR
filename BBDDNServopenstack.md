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
[centos@quijote ~]$ dig -x 10.0.2.10

; <<>> DiG 9.11.20-RedHat-9.11.20-5.el8 <<>> -x 10.0.2.10
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3261
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: a5b21089b1f696c39bc3dd445fdb153c59aec44eefcbd838 (good)
;; QUESTION SECTION:
;10.2.0.10.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
10.2.0.10.in-addr.arpa.	86400	IN	PTR	quijote.manuel-lora.gonzalonazareno.org.

;; AUTHORITY SECTION:
2.0.10.in-addr.arpa.	86400	IN	NS	freston.manuel-lora.gonzalonazareno.org.

;; ADDITIONAL SECTION:
freston.manuel-lora.gonzalonazareno.org. 86400 IN A 10.0.1.10

;; Query time: 3 msec
;; SERVER: 10.0.1.10#53(10.0.1.10)
;; WHEN: Thu Dec 17 08:22:20 UTC 2020
;; MSG SIZE  rcvd: 170
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

```
manuel@debian:~/.ssh$ dig dulcinea.manuel-lora.gonzalonazareno.org

; <<>> DiG 9.11.5-P4-5.1+deb10u2-Debian <<>> dulcinea.manuel-lora.gonzalonazareno.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 58292
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 820e6ffb07fa032bfd35d79b5fdb15c79c2d3466f2f6d16f (good)
;; QUESTION SECTION:
;dulcinea.manuel-lora.gonzalonazareno.org. IN A

;; ANSWER SECTION:
dulcinea.manuel-lora.gonzalonazareno.org. 85610	IN A 172.22.200.146

;; AUTHORITY SECTION:
manuel-lora.gonzalonazareno.org. 85590 IN NS	dulcinea.manuel-lora.gonzalonazareno.org.

;; Query time: 0 msec
;; SERVER: 192.168.202.2#53(192.168.202.2)
;; WHEN: jue dic 17 09:24:39 CET 2020
;; MSG SIZE  rcvd: 127
```

## Servidor Web

En quijote (CentOs)(Servidor que está en la DMZ) vamos a instalar un servidor 
web apache. Configura el servidor para que sea capaz de ejecutar código php 
(para ello vamos a usar un servidor de aplicaciones php-fpm). Entrega una 
captura de pantalla accediendo a www.tunombre.gonzalonazareno.org/info.php donde
se vea la salida del fichero info.php. Investiga la reglas DNAT de cortafuegos 
que tienes que configurar en dulcinea para, cuando accedemos a la IP flotante 
se acceda al servidor web.

Para instalar el servidor web de Apache2 en CentOS 8 debemos instalar los
siguientes paquetes:

```
[centos@quijote ~]$ sudo dnf install httpd php-fpm
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
        ErrorLog /var/www/manuel-lora/log/error.log
        CustomLog /var/www/manuel-lora/log/requests.log combined
</VirtualHost>
```

Asignamos los permisos correspondientes y los propietarios a los directorios:

```
[centos@quijote www]$ sudo chown -R $USER:$USER /var/www/manuel-lora/
[centos@quijote www]$ sudo chmod -R 755 /var/www
```

Nos instalaremos el paquete _policycoreutils-python-utils_ y ejecutamos
las siguientes instrucciones:

```
[root@quijote www]# semanage fcontext -a -t httpd_log_t "/var/www/manuel-lora/log(/.*)?"
[root@quijote www]# restorecon -R -v /var/www/manuel-lora/log
Relabeled /var/www/manuel-lora/log from unconfined_u:object_r:httpd_sys_content_t:s0 to unconfined_u:object_r:httpd_log_t:s0
```

Esto permitirá al servicio de apache usar el directorio log. Hecho esto,
reiniciamos el servicio de apache2.

Y comprobamos la conexión desde dulcinea:

```
             Página web de quijote.manuel-lora.gonzalonazareno.org












Commands: Use arrow keys to move, '?' for help, 'q' to quit, '<-' to go back.
  Arrow keys: Up and Down to move.  Right to follow a link; Left to go back.
 H)elp O)ptions P)rint G)o M)ain screen Q)uit /=search [delete]=history list 
```

Ahora procedemos a instalarnos el paquete _php_. Una vez instalado, creamos
un fichero llamado info.php en nuestro DocumentRoot que contiene las 
siguientes líneas:

```
<?php

phpinfo();
```

Reiniciamos el servicio y comprobamos que funciona:

```
                                                            phpinfo() (p1 of 34)
   PHP logo

PHP Version 7.2.24

   System Linux quijote 4.18.0-193.28.1.el8_2.x86_64 #1 SMP Thu Oct 22
   00:20:22 UTC 2020 x86_64
   Build Date Oct 22 2019 08:28:36
   Server API FPM/FastCGI
   Virtual Directory Support disabled
   Configuration File (php.ini) Path /etc
   Loaded Configuration File /etc/php.ini
   Scan this dir for additional .ini files /etc/php.d
   Additional .ini files parsed /etc/php.d/20-bz2.ini,
   /etc/php.d/20-calendar.ini, /etc/php.d/20-ctype.ini,
   /etc/php.d/20-curl.ini, /etc/php.d/20-exif.ini,
   /etc/php.d/20-fileinfo.ini, /etc/php.d/20-ftp.ini,
   /etc/php.d/20-gettext.ini, /etc/php.d/20-iconv.ini,
   /etc/php.d/20-phar.ini, /etc/php.d/20-sockets.ini,
   /etc/php.d/20-tokenizer.ini
-- press space for next page --
  Arrow keys: Up and Down to move.  Right to follow a link; Left to go back.
 H)elp O)ptions P)rint G)o M)ain screen Q)uit /=search [delete]=history list 
```

## Servidor de Base de Datos

En sancho (Ubuntu) vamos a instalar un servidor de base de datos mariadb 
(bd.tu_nombre.gonzalonazareno.org). Entrega una prueba de funcionamiento donde 
se vea como se realiza una conexión a la base de datos desde quijote.

En primer lugar, en sancho nos instalaremos un servidor MariaDB:

```
ubuntu@sancho:~$ sudo apt-get install mariadb-server
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  galera-3 libcgi-fast-perl libcgi-pm-perl libconfig-inifiles-perl
  libdbd-mysql-perl libdbi-perl libencode-locale-perl libfcgi-perl
  libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
  libhttp-date-perl libhttp-message-perl libio-html-perl
  liblwp-mediatypes-perl libmysqlclient21 libsnappy1v5 libterm-readkey-perl
  libtimedate-perl liburi-perl mariadb-client-10.3 mariadb-client-core-10.3
  mariadb-common mariadb-server-10.3 mariadb-server-core-10.3 mysql-common
  socat
Suggested packages:
  libclone-perl libmldbm-perl libnet-daemon-perl libsql-statement-perl
  libdata-dump-perl libipc-sharedcache-perl libwww-perl mailx mariadb-test
  tinyca
The following NEW packages will be installed:
  galera-3 libcgi-fast-perl libcgi-pm-perl libconfig-inifiles-perl
  libdbd-mysql-perl libdbi-perl libencode-locale-perl libfcgi-perl
  libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
  libhttp-date-perl libhttp-message-perl libio-html-perl
  liblwp-mediatypes-perl libmysqlclient21 libsnappy1v5 libterm-readkey-perl
  libtimedate-perl liburi-perl mariadb-client-10.3 mariadb-client-core-10.3
  mariadb-common mariadb-server mariadb-server-10.3 mariadb-server-core-10.3
  mysql-common socat
0 upgraded, 28 newly installed, 0 to remove and 46 not upgraded.
Need to get 21.1 MB of archives.
After this operation, 173 MB of additional disk space will be used.
Do you want to continue? [Y/n] 
.
.
.
Setting up libhtml-template-perl (2.97-1) ...
Setting up mariadb-server (1:10.3.25-0ubuntu0.20.04.1) ...
Setting up libcgi-fast-perl (1:2.15-1) ...
Processing triggers for systemd (245.4-4ubuntu3.2) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.1) ...
```

Terminada la descarga, vamos a proceder como con la pila LAMP, a crear la 
contraseña de root, borrar usuarios por defecto, etc....:

```
ubuntu@sancho:~$ sudo mysql_secure_installation 

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] Y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] Y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] Y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] Y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] Y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

Ahora, para acceder de forma remota, tenemos que configurar el fichero
_/etc/mysql/mariadb.conf.d/50-server.cnf_:

```
bind-address            = 0.0.0.0
```

Y reiniciamos el servicio para guardar los cambios.

Ahora procedemos a crear un usuario, la base de datos y los privilegios al mismo.

```
ubuntu@sancho:~$ sudo mysql -u root
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 36
Server version: 10.3.25-MariaDB-0ubuntu0.20.04.1 Ubuntu 20.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE USER 'cliente' identified by 'cliente';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> CREATE DATABASE sanchodb;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT USAGE ON *.* TO 'cliente'@'%' IDENTIFIED BY 'cliente';
Query OK, 0 rows affected (0.002 sec)
```

En dulcinea, instalamos el paquete _mariadb-client_ y comprobamos que 
tenemos conexión con la base de datos:

```
debian@dulcinea:~$ sudo mysql -u cliente_serv -p sanchodb -h bd.manuel-lora.gonzalonazareno.org
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 38
Server version: 10.3.25-MariaDB-0ubuntu0.20.04.1 Ubuntu 20.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [sanchodb]> 
```

Y para quijote, debemos realizar los siguiente antes de poder conectarnos:

```
[centos@quijote ~]$ sudo dnf -y install mariadb-server
Last metadata expiration check: 2:30:47 ago on Thu 17 Dec 2020 07:35:28 AM UTC.
Dependencies resolved.
================================================================================
 Package                Arch   Version                          Repo       Size
================================================================================
Installing:
 mariadb-server         x86_64 3:10.3.17-1.module_el8.1.0+257+48736ea6
                                                                AppStream  16 M
Installing dependencies:
 libaio                 x86_64 0.3.112-1.el8                    BaseOS     33 k
 mariadb                x86_64 3:10.3.17-1.module_el8.1.0+257+48736ea6
.
.
.
  perl-podlators-4.11-1.el8.noarch                                              
  perl-threads-1:2.21-2.el8.x86_64                                              
  perl-threads-shared-1.58-2.el8.x86_64                                         

Complete!
```

```
[centos@quijote ~]$ sudo mysql -u cliente_serv -p sanchodb -h bd.manuel-lora.gonzalonazareno.org
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 39
Server version: 10.3.25-MariaDB-0ubuntu0.20.04.1 Ubuntu 20.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [sanchodb]> 
```
