# Práctica: Servidor DHCP

**Tarea 1.** Lee el documento _Teoría: Servidor DHCP_ y explica el 
funcionamiento del servidor DHCP resumido en este gráfico.



## Preparación del escenario

Crea un escenario usando Vagrant que defina las siguientes máquinas:

* **Servidor**: Tiene dos tarjetas de red: una pública y una privada que 
se conectan a la red local.
    
* **nodo_lan1**: Un cliente conectado a la red local.

Instala un servidor dhcp en el ordenador “servidor” que de servicio a los 
ordenadores de red local, teniendo en cuenta que el tiempo de concesión 
sea 12 horas y que la red local tiene el direccionamiento _192.168.100.0/24_.


**Tarea 2**: Entrega el fichero Vagrantfile que define el escenario.
    
**Tarea 3**: Muestra el fichero de configuración del servidor, la lista de 
concesiones, la modificación en la configuración que has hecho en el cliente 
para que tome la configuración de forma automática y muestra la salida 
del comando _`ip address`_.

**Tarea 4**: Configura el servidor para que funcione como router y NAT, 
de esta forma los clientes tengan internet.
    
**Tarea 5**: Realizar una captura, desde el servidor usando tcpdump, 
de los cuatro paquetes que corresponden a una concesión: DISCOVER, OFFER, 
REQUEST, ACK.

**Tarea 6**: Los clientes toman una configuración, y a continuación apagamos 
el servidor dhcp. ¿qué ocurre con el cliente windows? ¿Y con el cliente linux?
    
**Tarea 7**: Los clientes toman una configuración, y a continuación cambiamos 
la configuración del servidor dhcp (por ejemplo el rango). ¿qué ocurriría 
con un cliente windows? ¿Y con el cliente linux?

**Tarea 8**: Indica las modificaciones realizadas en los ficheros de 
configuración y entrega una comprobación de que el cliente ha tomado esa 
dirección.

## Uso de varios ámbitos

Modifica el escenario Vagrant para añadir una nueva red local y un nuevo nodo:

* **Servidor**: En el servidor hay que crear una nueva interfaz.
    
* **nodo_lan2**: Un cliente conectado a la segunda red local.

Configura el servidor dhcp en el ordenador “servidor” para que de servicio a 
los ordenadores de la nueva red local, teniendo en cuenta que el tiempo de 
concesión sea 24 horas y que la red local tiene el direccionamiento 
_192.168.200.0/24_.


**Tarea 9**: Entrega el nuevo fichero Vagrantfile que define el escenario.
    
**Tarea 10**: Explica las modificaciones que has hecho en los distintos 
ficheros de configuración. Entrega las comprobaciones necesarias de que 
los dos ámbitos están funcionando.
    
**Tarea 11**: Realiza las modificaciones necesarias para que los cliente de 
la segunda red local tengan acceso a internet. Entrega las comprobaciones 
necesarias.


