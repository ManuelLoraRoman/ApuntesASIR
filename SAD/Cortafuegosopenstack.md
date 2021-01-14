# Cortafuegos

Vamos a construir un cortafuegos en dulcinea que nos permita controlar el 
tráfico de nuestra red. El cortafuegos que vamos a construir debe funcionar 
tras un reinicio.

## Política por defecto

La política por defecto que vamos a configurar en nuestro cortafuegos será de 
tipo DROP.

```

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


## ping

1. Todas las máquinas de las dos redes pueden hacer ping entre ellas.

```
iptables -A INPUT -i eth0 -p icmp -j ACCEPT
iptables -A OUTPUT -o eth2 -p icmp -j ACCEPT

iptables -A INPUT -i eth2 -p icmp -j ACCEPT
iptables -A OUTPUT -o eth0 -p icmp -j ACCEPT

iptables -A INPUT -i eth0 -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -o eth2 -p icmp --icmp-type echo-request -j ACCEPT

iptables -A INPUT -i eth2 -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -o eth0 -p icmp --icmp-type echo-request -j ACCEPT
```
   
2. Todas las máquinas pueden hacer ping a una máquina del exterior.
   
```
iptables -A FORWARD -i eth0 -o eth1 -s 
```

3. Desde el exterior se puede hacer ping a dulcinea.
   
```

```

4. A dulcinea se le puede hacer ping desde la DMZ, pero desde la LAN se le debe 
rechazar la conexión (REJECT).

```

```

## ssh

1. Podemos acceder por ssh a todas las máquinas.

### Permitir desde la DMZ
   
```
iptables -A INPUT -s 
```

2. Todas las máquinas pueden hacer ssh a máquinas del exterior.
   
```

```

3. La máquina dulcinea tiene un servidor ssh escuchando por el puerto 22, pero 
al acceder desde el exterior habrá que conectar al puerto 2222.

```
iptables -t nat -A PREROUTING -i eth1 -p tcp -m tcp --dport 2222 -j REDIRECT --to-ports 22
```

## dns

1. El único dns que pueden usar los equipos de las dos redes es freston, no 
pueden utilizar un DNS externo.
   
```

```

2. Dulcinea puede usar cualquier servidor DNS.
   
```

```

3. Tenemos que permitir consultas dns desde el exterior a freston, para que, 
por ejemplo, papion-dns pueda preguntar.

```

```

## Base de datos

1. A la base de datos de sancho sólo pueden acceder las máquinas de la DMZ.

```

```

## Web

1. Las páginas web de quijote (80, 443) pueden ser accedidas desde todas las 
máquinas de nuestra red y desde el exterior.

```

```

## Más servicios

1. Configura de manera adecuada el cortafuegos, para otros servicios que tengas 
instalado en tu red (ldap, correo, ...)

```

```
