# Ejercicio: Instalación y configuración del servidor DHCP en Linux


## Instalación del servidor isc-dhcp-server

```sudo apt-get install isc-dhcp-server```

Cuando lo instalamos por primera vez, nos producirá un error ya que no está 
configurado. Para ver los errores: _/var/log/syslog_.


## Configuración del servidor isc-dhcp-server

Primero hay que configurar la interfaz de red por la que trabajaremos con el
servidor dhcp. Editamos el siguiente fichero _/etc/default/isc-dhcp-server_.

* **Parámetro interfaces**:

```INTERFACES="eth1"```

El fichero principal de configuración es: _/etc/dhcp/dhcp.conf_. Este está
configurado en dos partes:

* Parte principal --> especifica los parámetros generales que definen la 
concesión y los parámetros adicionales que se proporcionarán al cliente.

* Secciones:  

   * Subnet --> especifican rangos de direcciones IPs que serán cedidas a los  
		clientes que lo soliciten.  

   * Host --> especificaciones concretas de equipos.  

En la parte principal nos encontramos lo siguiente:

* **max-lease-time** --> tiempo de la concesión de la dirección IP.

* **default-lease-time** --> tiempo de renovación de la concesión.

* **option routers** --> indicamos la dirección de red de la puerta de enlace 
para salir a Internet.

* **option domain-name-servers** --> se pone las direcciones IP de los 
servidores DNS que va a utilizar el cliente.

* **option-domain-name** --> nombre del dominio que se manda al cliente.

* **option subnetmask** --> subred enviada a los clientes.

* **option broadcast-address** --> dirección de difusión de la red.

Al indicar una sección subnet, tenemos que indicar la dirección de la red y la
máscara de red y entre llaves podemos poner:

* **range** --> indicamos el rango de direcciones IP que vamos a asignar.

Ejemplo de configuración de la sección subnet:

```subnet 192.168.0.0 netmask 255.255.255.0 {  
range 192.168.0.60 192.168.0.90;  
option routers 192.168.0.254;  
option domain-name-servers 80.58.0.33, 80.58.32.9;  
}  
```
