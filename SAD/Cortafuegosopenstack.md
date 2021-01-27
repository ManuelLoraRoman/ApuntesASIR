# Cortafuegos

Vamos a construir un cortafuegos en dulcinea que nos permita controlar el 
tráfico de nuestra red. El cortafuegos que vamos a construir debe funcionar 
tras un reinicio.

## Política por defecto

La política por defecto que vamos a configurar en nuestro cortafuegos será de 
tipo DROP.

```
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
```

## NAT 

* Configura de manera adecuada las reglas NAT para que todas las máquinas de 
nuestra red tenga acceso al exterior.

```
iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o eth1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth1 -j MASQUERADE
```
   
* Configura de manera adecuada todas las reglas NAT necesarias para que los 
servicios expuestos al exterior sean accesibles.

```
iptables -t nat -A PREROUTING -p udp --dport 53 -i eth1 -j DNAT --to 10.0.1.10
iptables -t nat -A PREROUTING -p tcp --dport 53 -i eth1 -j DNAT --to 10.0.1.10
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j DNAT --to 10.0.2.10
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 443 -j DNAT --to 10.0.2.10
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 25 -j DNAT --to 10.0.1.10
```

## Reglas

Para cada configuración, hay que mostrar las reglas que se han configurado y 
una prueba de funcionamiento de la misma:


## Ping

1. Todas las máquinas de las dos redes pueden hacer ping entre ellas.

```
Permitir ping Dulcinea con la red interna y la DMZ

iptables -A OUTPUT -o eth0 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -i eth0 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT

iptables -A OUTPUT -o eth2 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -i eth2 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT

Permitir ping DMZ con la red interna

iptables -A FORWARD -i eth2 -o eth0 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT

Permitir ping red interna con la DMZ

iptables -A FORWARD -i eth0 -o eth2 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT
```

2. Todas las máquinas pueden hacer ping a una máquina del exterior.
   
```
Permitir ping red interna al exterior

iptables -A FORWARD -i eth0 -o eth1 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT

Permitir ping DMZ al exterior

iptables -A FORWARD -i eth2 -o eth1 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT
```

3. Desde el exterior se puede hacer ping a dulcinea.
   
```
iptables -A INPUT -i eth1 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -o eth1 -p icmp -m icmp --icmp-type echo-reply -j ACCEPT
```

4. A dulcinea se le puede hacer ping desde la DMZ, pero desde la LAN se le debe 
rechazar la conexión (REJECT).

```
Permitir ping de DMZ hacia Dulcinea

iptables -A INPUT -i eth2 -p icmp -m icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -o eth2 -p icmp -m icmp --icmpt-type echo-reply -j ACCEPT

Rechazar ping de red interna hacia Dulcinea

iptables -A INPUT -i eth0 -p icmp -m icmp --icmp-type echo-request -j REJECT --reject-with icmp-port-unreachable
```

## ssh

1. Podemos acceder por ssh a todas las máquinas.
   
```
Permitir ssh de DMZ hacia la red interna

iptables -A FORWARD -i eth2 -o eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

Permitir ssh de red interna hacia la DMZ

iptables -A FORWARD -i eth0 -o eth2 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

Permitir ssh de Dulcinea a ambas redes

iptables -A OUTPUT -o eth2 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth2 -p tcp -m tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o eth0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

```

2. Todas las máquinas pueden hacer ssh a máquinas del exterior.
   
```
Permitir ssh desde la red interna hacia el exterior

iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

Permitir ssh desde la DMZ hacia el exterior

iptables -A FORWARD -i eth2 -o eth1 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
```

3. La máquina dulcinea tiene un servidor ssh escuchando por el puerto 22, pero 
al acceder desde el exterior habrá que conectar al puerto 2222.

```
iptables -A INPUT -s 0.0.0.0/0 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -d 0.0.0.0/0 -p tcp -m tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
```

## DNS

1. El único dns que pueden usar los equipos de las dos redes es freston, no 
pueden utilizar un DNS externo.
   
```
Permitir hacer consultas desde el exterior hacia Freston

iptables -A FORWARD -s 10.0.1.10 -d 0.0.0.0/24 -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 0.0.0.0/24 -d 10.0.1.10 -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

Permitir hacer consultas desde la DMZ hacia Freston

iptables -A FORWARD -s 10.0.2.0/24 -d 10.0.1.10 -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 10.0.1.10 -d 10.0.2.0/24 -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
```

Sancho no requiere de configuración por iptables ya que se encuentra en la misma red que Freston.

2. Dulcinea puede usar cualquier servidor DNS.

```
Permitir hacer consultas desde Dulcinea a Freston

iptables -A OUTPUT -d 10.0.1.10 -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -s 10.0.1.10 -d 10.0.1.4 -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

Permitir hacer consultas desde Dulcinea hacia cualquier otro servidor DNS

iptables -A OUTPUT -o eth1 -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth1 -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
```

3. Tenemos que permitir consultas dns desde el exterior a freston, para que, 
por ejemplo, papion-dns pueda preguntar.

```
iptables -A FORWARD -i eth1 -o eth0 -s 0.0.0.0/0 -d 10.0.1.10 -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -s 10.0.1.10 -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
```

## Base de datos

1. A la base de datos de sancho sólo pueden acceder las máquinas de la DMZ.

```
Permitir a la DMZ conexión a la base de datos

iptables -A FORWARD -i eth2 -o eth0 -p tcp --dport 3306 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p tcp --sport 3306 -m state --state ESTABLISHED -j ACCEPT
```

## Web

1. Las páginas web de quijote (80, 443) pueden ser accedidas desde todas las 
máquinas de nuestra red y desde el exterior.

```
iptables -t nat -A PREROUTING -i eth1 -p tcp -m multiport --dports 80,443 -j DNAT --to 10.0.2.10

Permitir acceso a la web desde ambas redes al exterior

iptables -A FORWARD -i eth2 -o eth1 -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT

iptables -A FORWARD -i eth0 -o eth1 -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o eth1 -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth1 -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT

Permitir acceso desde la red interna hacia nuestra página web

iptables -A FORWARD -i eth0 -o eth2 -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT

Permitir acceso a la página web desde el exterior

iptables -A FORWARD -i eth1 -o eth2 -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -o eth1 -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT

Permitir acceso a la página web desde Dulcinea

iptables -A OUTPUT -o eth2 -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth2 -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT
```

## Más servicios

1. Configura de manera adecuada el cortafuegos, para otros servicios que tengas 
instalado en tu red (ldap, correo, ...)

## Bacula

```
Permitir conexión a Bacula hacia la DMZ

iptables -A FORWARD -i eth2 -o eth0 -p tcp --dport 9101:9103 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p tcp --sport 9101:9103 -m state --state ESTABLISHED -j ACCEPT

iptables -A FORWARD -i eth0 -o eth2 -p tcp --dport 9101:9103 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -p tcp --sport 9101:9103 -m state --state ESTABLISHED -j ACCEPT

Permitir conexión a Bacula hacia Dulcinea

iptables -A INPUT -i eth0 -p tcp --dport 9101:9103 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 9101:9103 -m state --state ESTABLISHED -j ACCEPT
```

## Correo

```
Permitir correo desde la DMZ

iptables -A FORWARD -i eth2 -o eth1 -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT

Permitir correo desde Dulcinea

iptables -A INPUT -i eth0 -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT

Permitir correo desde el exterior

iptables -A FORWARD -i eth1 -o eth0 -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
```

## LDAP/LDAPS

```
Permitir conexión LDAP/LDAPS desde la DMZ

iptables -A FORWARD -i eth2 -o eth0 -p tcp -m multiport --dports 389,636 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p tcp -m multiport --sports 389,636 -m state --state ESTABLISHED -j ACCEPT

Permitir conexión LDAP/LDAPS desde Dulcinea

iptables -A INPUT -i eth0 -p tcp -m multiport --dports 389,636 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 389,636 -m state --state ESTABLISHED -j ACCEPT
```
