<div align="center">

# Cortafuegos

</div>


Permite analizar el tráfico de red al atravesar un dispositivo y tomar 
decisiones acerca del mismo:

* Permitir / Denegar el paso.

* Modificar el tráfico.

* Seleccionar tráfico para otra aplicación.

Se usa para controlar el tráfico y mejorar el rendimiento.

El filtrado se puede hacer a diferentes capas: nivel de enlace (MAC), nivel
de red (IP), nivel de transporte (Puerta destino, TCP) o a nivel de 
aplicación (DNS, HTTP, FTP,...).

El filtrado de paquetes en Linux se puede hacer mediante iptables y nftables.

SNAT --> un equipo con dirección privada pueda acceder a Internet.

DNAT --> un equipo pueda acceder a un servicio ubicado en un equipo con
dirección privada.

Ejemplo de iptables:

```
root@maquina:/home/debian# iptables -F           --> limpia tablas de filter
root@maquina:/home/debian# iptables -t nat -F    --> limpia tablas de nat
root@maquina:/home/debian# iptables -Z           --> pone contadores a 0
root@maquina:/home/debian# iptables -L -n        --> lista las iptables de filter
root@maquina:/home/debian# iptables -t nat -L -n -v  --> lista las iptables de nat
root@maquina:/home/debian# iptables -A INPUT -i eth0 -s 172.22.0.0/16 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT --> permitir ssh de dicha red
root@maquina:/home/debian# iptables -A OUTPUT -d 172.22.0.0/16 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT --> permitir ssh de dicha red
root@maquina:/home/debian# iptables -P INPUT DROP
root@maquina:/home/debian# iptables -P OUTPUT DROP
root@maquina:/home/debian# iptables -A INPUT -i lo -p icmp -j ACCEPT --> permitir hacer ping
root@maquina:/home/debian# iptables -A OUTPUT -o lo -p icmp -j ACCEPT --> permitir hacer ping
root@maquina:/home/debian# iptables -A INPUT -i eth0 -p icmp --icmp-type echo-reply -j ACCEPT --> permitir respuesta del ping
root@maquina:/home/debian# iptables -A OUTPUT -o eth0 -p icmp --icmp-type echo-request -j ACCEPT --> permitir respuesta ping
root@maquina:/home/debian# iptables -A OUTPUT -o eth0 -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT --> permitir http
root@maquina:/home/debian# iptables -A INPUT -i eth0 -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT --> permitir http

iptables -L -n --line-numbers
iptables -D OUTPUT 4
```


Ejemplo de nftables: (las tablas no vienen creadas como con iptables)

```
root@maquina:~# nft add table inet filter --> añade la tabla tipo inet llamada 
				filter (inet permite filtrar con ipv4 y ipv6)

Añade las cadenas de Input y Output

root@maquina:~# nft add chain inet filter input { type filter hook input priority 0 \; counter \; policy accept \; }
root@maquina:~# nft add chain inet filter output { type filter hook output priority 0 \; counter \; policy accept \; }



Lista las cadenas de la tabla filter

root@maquina:~# nft list chains
table inet filter {
	chain input {
		type filter hook input priority 0; policy accept;
	}
	chain output {
		type filter hook output priority 0; policy accept;
	}
}

Traducir una regla de iptables --> usamos el comando iptables-translate

Permitir conexión desde la red a nuestra máquina por ssh

root@maquina:~# nft add rule inet filter input ip saddr 172.22.0.0/16 tcp 
dport 22 ct state new,established counter accept

root@maquina:~# nft add rule inet filter output ip daddr 172.22.0.0/16 tcp 
sport 22 ct state new,established  counter accept

PING al localhost

root@maquina:~# nft add rule inet filter input iifname "lo" counter accept    
root@maquina:~# nft add rule inet filter output oifname "lo" counter accept

Permitir ICMP

root@maquina:~# nft add rule inet filter output oifname "eth0" icmp type echo-reply counter accept
root@maquina:~# nft add rule inet filter input iifname "eth0" icmp type echo-request counter accept

Permitir consultas DNS

root@maquina:~# nft add rule inet filter output oifname "eth0" udp dport 53 ct state new,established  counter accept
root@maquina:~# nft add rule inet filter input iifname "eth0" udp sport 53 ct state established  counter accept

Permitir HTTP/HTTPS

root@maquina:~# nft add rule inet filter output oifname "eth0" ip protocol tcp tcp dport { 80,443 } ct state new,established  counter accept
root@maquina:~# nft add rule inet filter input iifname "eth0" ip protocol tcp tcp sport { 80,443 } ct state established  counter accept


Permitir acceso a nuestro servidor web

root@maquina:~# nft add rule inet filter output oifname "eth0" tcp sport 80 ct state established counter accept
root@maquina:~# nft add rule inet filter input iifname "eth0" tcp dport 80 ct state new,established counter accept

Copia de seguridad

root@maquina:~# echo "nft flush ruleset" > backup.nft
root@maquina:~# nft list ruleset >> backup.nft

Y ejecutar nft -f backup.nft
```

Ejercicios Iptables en Nftables:

1. Permite poder hacer conexiones ssh al exterior.

```
root@maquina:~# nft add rule inet filter output oif "eth0" tcp dport 22 ct state new,established counter accept
root@maquina:~# nft add rule inet filter input iif "eth0" tcp sport 22 ct state new,established counter accept
```
  
Comprobación:

```

```


2. Deniega el acceso a tu servidor web desde una ip concreta.
  
3. Permite hacer consultas DNS sólo al servidor 192.168.202.2. Comprueba que 
no puedes hacer un dig @1.1.1.1.
  
4. No permitir el acceso al servidor web de www.josedomingo.org (Tienes que 
utilizar la ip). ¿Puedes acceder a fp.josedomingo.org?
  
5. Permite mandar un correo usando nuestro servidor de correo: babuino-smtp. 
Para probarlo ejecuta un telnet bubuino-smtp.gonzalonazareno.org 25.
  
6. Instala un servidor mariadb, y permite los accesos desde la ip de tu 
cliente. Comprueba que desde otro cliente no se puede acceder.

