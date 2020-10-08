# Práctica: Servidor DHCP

**Tarea 1.** Lee el documento _Teoría: Servidor DHCP_ y explica el 
funcionamiento del servidor DHCP resumido en este gráfico.

* **Paso 1**: se inicializa el cliente DHCP, comenzando en el estado INIT.

* **Paso 2**: como desconoce sus parámetros IP, envía un broadcast DHCPDISCOVER. Este, se 
encapsula en un paquete UDP. El DHCPDISCOVER usa la dirección IP de broadcast 255.255.255.255.

* **Paso 3**: si no hay un servidor DHCP en la red local, el router debe tener un DHCP relay
que soporte la retransmisión de esta petición hacia otras subredes. 

* **Paso 4**: antes de enviar el DHCPDISCOVER, el cliente espera un tiempo aleatorio para 
evitar colisiones.

* **Paso 5**: el cliente ingresa al estado SELECTING, donde recibirá mensaje DHCPOFFER de 
los servidores DHCP. 

* **Paso 6**: si el cliente recibe varias respuestas, elegirá una. Como respuesta a esto, 
enviará un mensaje DHCPREQUEST para elegir un servidor DHCP, que responderá con un DHCPACK.

* **Paso 7**: el cliente controla la dirección IP enviada en el DHCPACK para verificar si
está en uso o no. En caso de estarlo, el DHCPACK se ignora y se envía un DHCPDECLINE, con lo
cual el cliente vuelve al estado INIT y vuelve a comenzar los pasos de nuevo.

* **Paso 8**: si se acepta el DHCPACK, se colocan 3 valores de temporización y el cliente 
DHCP pasa al estado BOUND.

	* **T1**: temporizador de renovación de alquiler.
	* **T2**: temporizador de reenganche.
	* **T3**: duración del alquiler.

* **Paso 9**: el DHCPACK trae consigo el T3. Los demás se configuran en el servidor

* **Paso 10**: después de la expiración del T1, el cliente pasa del estado BOUND al 
RENEWING. En este último, se debe negociar un nuevo alquiler para la dirección IP. 

* **Paso 11**: si por algún motivo, no se renueva el alquiler, enviará un DHCPNACK y el 
cliente pasará otra vez al estado INIT, y lo volverá a intentar. En caso contrario, el 
servidor DHCP enviará un DHCPACK el cual contiene la duración del nuevo alquiler. Entonces 
el cliente pasará al estado BOUND.

* **Paso 12**: si el T2 expira mientras el cliente está esperando en el estado RENEWING una 
respuesta DHCPACK o DHCPNACK, el cliente pasará al estado REBINDING. 

* **Paso 13**: al expirar el T2, el cliente DHCP enviará un DHCPREQUEST a la red, para 
contactar con cualquier servidor DHCP para extender su alquiler, pasando al estado 
REBINDING. Espera a que cualquier servidor DHCP le conteste, y si alguno responde con un 
DHCPACK, el cliente renueva el alquiler y retorna al BOUND.

* **Paso 14**: si no hay servidor DHCP, entonces el alquiler cesa, y retorna al estado INIT.

* **Paso 15**: al acabar el T3, el cliente debe devolver su dirección IP y cesar las 
acciones con dicha dirección IP.

* **Paso 16**: si un usuario se libera armoniosamente, el cliente DHCP enviará un
DHCPRELEASE al servidor DHCP para cancelar el alquiler, y la dirección IP estará disponible.


## Preparación del escenario

Crea un escenario usando Vagrant que defina las siguientes máquinas:

* **Servidor**: Tiene dos tarjetas de red: una pública y una privada que 
se conectan a la red local.
    
* **nodo_lan1**: Un cliente conectado a la red local.

Instala un servidor dhcp en el ordenador “servidor” que de servicio a los 
ordenadores de red local, teniendo en cuenta que el tiempo de concesión 
sea 12 horas y que la red local tiene el direccionamiento _192.168.100.0/24_.

Instalaremos el paquete _isc-dhcp-server_ en la máquina servidor.

**Tarea 2**: Entrega el fichero Vagrantfile que define el escenario.

Aquí el fichero [Vagrantfile](./Vagrantfile)
    
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


