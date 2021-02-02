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
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 9090 -j DNAT --to 10.0.2.10

* DMZ a red interna



* DMZ a Dulcinea 

iptables -A INPUT -i eth2 -p tcp --sport 9090 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth2 -p tcp --dport 9090 -m state --state ESTABLISHED -j ACCEPT

* DMZ al exterior y viceversa




correcta

iptables -A FORWARD -i eth1 -o eth2 -p tcp --dport 9090 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -o eth1 -p tcp --sport 9090 -m state --state ESTABLISHED -j ACCEPT
```

Y en Quijote debemos realizar adicionalmente:

```
[centos@quijote ~]$ sudo firewall-cmd --zone=public --permanent --add-port 9090/tcp
success
[centos@quijote ~]$ sudo firewall-cmd --reload
success
```

Terminada la preconfiguración, vamos a proceder a la instalación y posterior
configuración de Prometheus. En primer lugar, en nuestra máquina Quijote,
vamos a realizar un ```dnf update -y ```. 

Hecho esto, vamos a dirigirnos hacia la página oficial de [Prometheus](https://prometheus.io/download/)
y nos descargamos de la pestaña de "prometheus" la versión para Linux:

```
[centos@quijote ~]$ curl -LO url -LO https://github.com/prometheus/prometheus/releases/download/v2.24.1/prometheus-2.24.1.linux-amd64.tar.gz
curl: Remote file name has no length!
curl: try 'curl --help' or 'curl --manual' for more information
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   640  100   640    0     0    935      0 --:--:-- --:--:-- --:--:--   934
100 62.4M  100 62.4M    0     0  8444k      0  0:00:07  0:00:07 --:--:-- 10.7M
[centos@quijote ~]$ ls
ifcfg-eth0  mikey.pubkey  prometheus-2.24.1.linux-amd64.tar.gz
[centos@quijote ~]$ tar -xvf prometheus-2.24.1.linux-amd64.tar.gz 
prometheus-2.24.1.linux-amd64/
prometheus-2.24.1.linux-amd64/consoles/
prometheus-2.24.1.linux-amd64/consoles/index.html.example
prometheus-2.24.1.linux-amd64/consoles/node-cpu.html
prometheus-2.24.1.linux-amd64/consoles/node-disk.html
prometheus-2.24.1.linux-amd64/consoles/node-overview.html
prometheus-2.24.1.linux-amd64/consoles/node.html
prometheus-2.24.1.linux-amd64/consoles/prometheus-overview.html
prometheus-2.24.1.linux-amd64/consoles/prometheus.html
prometheus-2.24.1.linux-amd64/console_libraries/
prometheus-2.24.1.linux-amd64/console_libraries/menu.lib
prometheus-2.24.1.linux-amd64/console_libraries/prom.lib
prometheus-2.24.1.linux-amd64/prometheus.yml
prometheus-2.24.1.linux-amd64/LICENSE
prometheus-2.24.1.linux-amd64/NOTICE
prometheus-2.24.1.linux-amd64/prometheus
prometheus-2.24.1.linux-amd64/promtool
[centos@quijote ~]$ mv prometheus-2.24.1.linux-amd64
mv: missing destination file operand after 'prometheus-2.24.1.linux-amd64'
Try 'mv --help' for more information.
[centos@quijote ~]$ ls
ifcfg-eth0    prometheus-2.24.1.linux-amd64
mikey.pubkey  prometheus-2.24.1.linux-amd64.tar.gz
[centos@quijote ~]$ mv prometheus-2.24.1.linux-amd64 prometheus-files
[centos@quijote ~]$ ls
ifcfg-eth0    prometheus-2.24.1.linux-amd64.tar.gz
mikey.pubkey  prometheus-files
```

A continuación, crearemos un usuario y un grupo para Prometheus, con sus 
respectivos directorios:

```
[centos@quijote ~]$ sudo useradd --no-create-home --shell /bin/false prometheus
[centos@quijote ~]$ sudo mkdir /etc/prometheus
[centos@quijote ~]$ sudo mkdir /var/lib/prometheus
[centos@quijote ~]$ sudo chown prometheus:prometheus /etc/prometheus
[centos@quijote ~]$ sudo chown prometheus:prometheus /var/lib/prometheus/
```

Copiaremos tanto el binario de prometheus y de promtool en el directorio
_/usr/local/bin_ y cambiaremos sus propietarios:

```
[centos@quijote ~]$ sudo cp prometheus-files/prometheus /usr/local/bin
[centos@quijote ~]$ sudo cp prometheus-files/promtool /usr/local/bin
[centos@quijote ~]$ sudo chown prometheus:prometheus /usr/local/bin/prometheus
[centos@quijote ~]$ sudo chown prometheus:prometheus /usr/local/bin/promtool 
```

Y haremos lo mismo con las consolas y las librerias en _/etc/prometheus_:

```
[centos@quijote ~]$ sudo cp -r prometheus-files/consoles /etc/prometheus/
[centos@quijote ~]$ sudo cp -r prometheus-files/console_libraries/ /etc/prometheus/
[centos@quijote ~]$ sudo chown prometheus:prometheus /etc/prometheus/consoles
[centos@quijote ~]$ sudo chown prometheus:prometheus /etc/prometheus/console_libraries/
[centos@quijote ~]$ 
```

Terminada la instalación, pasamos a la configuración. Toda la configuración
para Prometheus debe de estar en un fichero llamado _prometheus.yml_
ubicado en el directorio _/etc/prometheus_.

Vamos a crearlo y a añadirle el siguiente contenido:

```
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
```

Y le cambiamos el propietario:

```
[centos@quijote ~]$ sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
```

Seguidamente, vamos a crear un servicio para Prometheus y le copiamos el 
siguiente contenido:

```
[centos@quijote ~]$ sudo nano /etc/systemd/system/prometheus.service

[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
```

Y reiniciamos el servicio de systemd para registrar el servicio de Prometheus:

```
[centos@quijote ~]$ sudo systemctl daemon-reload
[centos@quijote ~]$ sudo systemctl start prometheus
[centos@quijote ~]$ sudo systemctl status prometheus
● prometheus.service - Prometheus
   Loaded: loaded (/etc/systemd/system/prometheus.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2021-02-01 17:24:45 UTC; 1min 43s ago
 Main PID: 45582 (prometheus)
    Tasks: 6 (limit: 2731)
   Memory: 24.0M
   CGroup: /system.slice/prometheus.service
           └─45582 /usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb>

Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.092Z caller=head.go:659 com>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.092Z caller=head.go:665 com>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.095Z caller=head.go:717 com>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.095Z caller=head.go:722 com>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.098Z caller=main.go:758 fs_>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.098Z caller=main.go:761 msg>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.098Z caller=main.go:887 msg>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.099Z caller=main.go:918 msg>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.099Z caller=main.go:710 msg>
Feb 01 17:24:46 quijote prometheus[45582]: level=info ts=2021-02-01T17:24:46.099Z caller=tls_config.go:1>
```

Ahora podremos acceder a Prometheus mediante la web:

![alt text](../Imágenes/prometheus.png)

Con esto, tendríamos ya configurado el servidor Prometheus. Pero las gráficas 
mostradas son solo de Quijote. Para mostrar las demás máquinas, debemos 
editar de nuevo el fichero _prometheus.yml_ y cambiamos el siguiente parámetro:


```
- targets: ['localhost:9090','10.0.1.10:9090','10.0.1.11:9090','10.0.2.11:9090','146.59.196.92:9090']
```

