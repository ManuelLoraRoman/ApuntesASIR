# Servidor DHCP

El protocolo de configuración dinámica de host, es un estándar TCP/IP que 
simplifica la administración de la configuración IP haciéndola automática.

Este servidor recibe peticiones de clientes solicitando una configuración de 
red IP y este proporciona los parámetros que permitan a los clientes
autoconfigurarse. El servidor DHCP proporciona la configuración de red:

Es una extensión de protocolo BOOTP que da más flexibilidad al administrar las 
direcciones IP.

* **Dirección de red**

* **Máscara de red**

* **Dirección del servidor DNS**

* **Nombre DNS**

* **Puerta de enlace de la dirección IP**

* **Dirección de Publicación Masiva (broadcast address)**

* **MTU para la interfaz**

* **Servidor NTP**

* **Servidor SMTP**

* **Servidor TFTP**

Conceptos con los que trabajar:

* **Ámbito servidor DHCP** --> agrupamiento administrativo de equipos o clientes
 de una subred.

* **Rango servidor DHCP** --> grupo de direcciones IP en una subred.

* **Concesión o alquiler de direcciones** --> período de tiempo que los
 servidores DHCP especifican, durante el cual un equipo puede utilizar una
 dirección IP.

* **Reserva de direcciones IP** --> direcciones IP que se asignan siempre a los
 mismos equipos.

* **Exclusiones** --> conjunto de direcciones IP pertenecientes al rango que no 
se van a asignar.

## Administración de direcciones con el DHCP

A) **Asignación manual**: el administrador de red pone manualmente la dirección
IP del cliente DHCP. 

B) **Asignación automática**: lo mismo que la asignación dinámica pero con
período de tiempo infinito.

C) **Asignación dinámica**: el DHCP asigna una dirección IP al cliente DHCP 
por un tiempo determinado. Después que expire este lapso, se revoca la dirección
IP y el cliente DHCP tiene que devolverla.


