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

```
subnet 192.168.0.0 netmask 255.255.255.0 {  
range 192.168.0.60 192.168.0.90;  
option routers 192.168.0.254;  
option domain-name-servers 80.58.0.33, 80.58.32.9;  
}  
```

En Windows para liberar la concesión se utiliza _ipconfig /release_ y _renew_
la renueva.

## Creando reservas

En la sección host, podemos reservar una dirección IP para él. En dicha 
sección, debemos poner el nombre que identifica al host y los siguientes 
parámetros:

* **hardware ethernet** --> dirección MAC de la tarjeta de red del host.

* **fixed-address** --> dirección IP que vamos a asignar.

* Podemos usar otras opciones.

## Ejercicio DHCP 1

**Tarea 1.** Configura el servidor dhcp con las siguientes características
   
 * Rango de direcciones a repartir: 192.168.0.100 - 192.168.0.110
 * Máscara de red: 255.255.255.0
 * Duración de la concesión: 1 hora
 * Puerta de enlace: 192.168.0.1
 * Servidores DNS: 8.8.8.8, 8.8.4.4

**Tarea 2.** Configura los clientes para obtener direccionamiento dinámico. 
Comprueba las configuraciones de red que han tomado los clientes. 
Visualiza el fichero del servidor donde se guarda las configuraciones asignadas.


### Tarea 1

* Configuración del fichero _isc-dhcp-server_:

![alt text](../Imágenes/iscdhcpserver.png)

* Configuraciones del fichero _dhcpd.conf_:

![alt text](../Imágenes/dhcpconf1.png)

![alt text](../Imágenes/dhcpconf2.png)

* DHCP iniciando:

![alt text](../Imágenes/dhcpstart.png)

### Tarea 2

Para configurar el direccionamiento para que sea dinámico, debemos modificar en 
la máquina cliente el archivo _/etc/network/interfaces_. Elegiremos la interfaz
de red que tengamos activa, en nuestro caso, _eth0_.


```
auto eth0
iface eth0 inet dhcp
```

Y después, reiniciar las interfaces con este comando:

```sudo /etc/init.d/networking restart```

!!! Antes de realizar dicho cambio, guarda tu configuración actual en caso de
que te encontrases fallos. 


## Ejercicio DHCP 2


**Tarea 1.** Crea en el servidor dhcp una sección HOST para conceder a un 
cliente una dirección IP determinada (por ejemplo la 192.168.0.105)
    
**Tarea 2.** Obtén una nueva dirección IP en el cliente y comprueba que 
es la que has asignado por medio de la sección host.

Vamos a comprobar que ocurre con la configuración de los clientes en determinadas circunstancias, para ello vamos a poner un tiempo de 
concesión muy bajo.

**Tarea 3.** Los clientes toman una configuración, y a continuación apagamos 
el servidor dhcp. ¿qué ocurre con el cliente windows? ¿Y con el cliente linux?
    
**Tarea 4.** Los clientes toman una configuración, y a continuación cambiamos 
la configuración del servidor dhcp (por ejemplo el rango). 
¿qué ocurre con el cliente windows? ¿Y con el cliente linux?


### Tarea 1

Utilizando el ejercicio anterior, debemos configurar la sección host en el
fichero _/etc/dhcp/dhcpd.conf_ de la siguiente manera:

```
host cliente1 {
   hardware ethernet f8:28:19:eb:cc:5f
   fixed-address 192.168.0.105;
}
```

Para saber nuestra dirección MAC, usaremos el comando:

```sudo ip a```

Y en nuestra interfaz , hallaremos en la sección _link/ether_ nuestra dirección
MAC:

![alt text](../Imágenes/MAC.png)


### Tarea 3


El cliente continuará cada 5 minutos intentando conectar al mismo DHCP. Si
expira el 87.5% del tiempo trata de renovar con cualquier otro DHCP. Y si no
consigue renovar al cumplirse el 100% del tiempo, deja de usar su IP y toma 
APIPA.


### Tarea 4

Se les volvería a asignar la misma IP.
