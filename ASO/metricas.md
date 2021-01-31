# Métricas, logs o monitorización

Utiliza una de las instancias de OpenStack y realiza una de las partes que 
elijas entre las siguientes sobre el servidor de OVH, dulcinea, sancho, 
quijote y frestón:

* Métricas: recolección, gestión centralizada, filtrado o selección de los 
parámetros relevantes y representación gráfica que permita controlar la 
evolución temporal de parámetros esenciales de todos los servidores.
    
* Monitorización: Configuración de un sistema de monitorización que controle 
servidores y servicios en tiempo real y envíe alertas por uso excesivo de 
recursos (memoria, disco raíz, etc.) y disponibilidad de los servicios. 
Alertas por correo, telegram, etc.
    
* Gestión de logs: Implementa un sistema que centralice los logs de todos los 
servidores y que filtre los registros con prioridad error, critical, alert o 
emergency. Representa gráficamente los datos relevantes extraídos de los logs 
o configura el envío por correo al administrador de los logs relevantes 
(una opción o ambas).

Detalla en la documentación claramente las características de la implementación 
elegida, así como la forma de poder verificarla (envía si es necesario usuario 
y contraseña por correo a los profesores, para el panel web si lo hubiera, 
p.ej.).


He escogido las herramientas Prometheus y Rsyslog para realizar esta práctica.

En primer lugar, vamos a utilizar la máquina Quijote (CentOS 8) para 
la instalación y configuración de la herramienta Prometheus.

Una cuestión importante antes de comenzar con la instalación, es que 
Prometheus utiliza el puerto 9090, por lo tanto, tendríamos que incorporar
nuevas reglas en nuestro cortafuegos en Dulcinea y en el propio cortafuegos
de Quijote.

Las reglas que vamos a añadir en el cortafuegos de Dulcinea son los
siguientes:

LAs 4 primeras son las unicas que he puesto y no funcionan

```
* DMZ a red interna y viceversa

iptables -A FORWARD -i eth2 -o eth0 -p tcp --dport 9090 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p tcp --sport 9090 -m state --state ESTABLISHED -j ACCEPT

iptables -A FORWARD -i eth0 -o eth2 -p tcp --dport 9090 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -p tcp --sport 9090 -m state --state ESTABLISHED -j ACCEPT

* DMZ a Dulcinea y viceversa

iptables -A INPUT -s 10.0.2.10 -p tcp --sport 9090 -j ACCEPT
iptables -A OUTPUT -d 10.0.2.10 -p tcp --dport 9090 -j ACCEPT

iptables -A INPUT -s 10.0.2.10 -p tcp --dport 9090 -j ACCEPT
iptables -A OUTPUT -d 10.0.2.10 -p tcp --sport 9090 -j ACCEPT

* DMZ al exterior y viceversa

iptables -A FORWARD -i eth2 -o eth1 -p tcp --dport 9090 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -p tcp --sport 9090 -m state --state ESTABLISHED -j ACCEPT

iptables -A FORWARD -i eth1 -o eth2 -p tcp --dport 9090 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -o eth1 -p tcp --sport 9090 -m state --state ESTABLISHED -j ACCEPT
```

## Comprobación:

```


Y en Quijote debemos realizar adicionalmente:

```
[centos@quijote ~]$ sudo firewall-cmd --zone=public --permanent --add-port 9090/tcp
success
[centos@quijote ~]$ sudo firewall-cmd --reload
success
```
