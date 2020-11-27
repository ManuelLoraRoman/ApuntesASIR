# Cuestionario DHCP

He ignorado preguntas que se encuentran en mis apuntes de DHCP.

Tarea 2. ¿Cómo hay que configurar un cliente DHCP?

Tarea 3. Ventajas de usar un servidor DHCP.

Tarea 6. ¿Qué es APIPA?

Tarea 7. ¿Por qué el mensaje DHCPDISCOVER es del tipo broadcast?

Tarea 8. Desde el estado INIT al estado BOUND. ¿Qué mensajes se transmiten 
desde el cliente al servidor?

Tarea 9. ¿Qué significa el mensaje DHCPDECLINE por parte del cliente?

Tarea 11. ¿Qué es la renovación (RENEWING) de alquiler?

Tarea 12. ¿Qué es el estado de reenganche (REBINDING)?

Tarea 13. ¿Qué ocurre cuando termina el tiempo de concesión del alquiler (T3)?
    
Tarea 14. ¿Qué ocurre cuando un cliente manda un DHCPRELEASE?
    
Tarea 15. ¿Qué ocurre cuando un cliente que ya tiene asignación se reinicia?
    
Tarea 16. Los clientes toman una configuración, y a continuación apagamos el 
servidor dhcp. ¿qué ocurre con el cliente windows? ¿Y con el cliente linux?
    
Tarea 17. Los clientes toman una configuración, y a continuación cambiamos la 
configuración del servidor dhcp (por ejemplo el rango). 
¿Qué ocurriría con un cliente windows? ¿Y con el cliente linux?

Tarea 18. ¿Qué instrucciones en Windows y en Linux nos permiten?:
        
	Para renovar una dirección IP y una nueva configuración de red  
        Para liberar la dirección IP  

Tarea 19. ¿Qué es la lista de concesiones? ¿En qué fichero se guarda en Linux?

Tarea 20. En el servidor isc-dhcp en linux. ¿Qué indican los siguientes 
parámetros?:
        
	max-lease-time
        default-lease-time  

Tarea 21. En el cliente, ¿qué se guarda en los ficheros dhclient-???.lease?


## Tarea 2

Cuando un cliente DHCP ha contactado con un servidor DHCP, se negocia el uso y 
la duración de su dirección IP mediante varios estados internos. La forma de 
adquisición de la dirección IP por el cliente DHCP se explica mejor en
términos de un diagrama de transición de estados.

## Tarea 3

* **Administración de direcciones IP**

* **Configuración de cliente de red centralizada**

* **Compatibilidad con clientes BOOTP**

* **Compatibilidad con clientes locales y remotos**

* **Inicio de red**

* **Amplia compatibilidad de red**

 
# Tarea 6

O direccionamiento privado automático del protocolo de Internet, es un
protocolo que utilizan los sistemas operativos para obtener la configuración
de red cuando está ajustado para obtener una dirección IP de manera dinámica, 
y al iniciar, este no encuentra un servidor DHCP.


# Tarea 7

Porque el cliente no tiene una dirección IP hasta que no el
DHCPDISCOVER-OFFER-REQUEST-ACK se ha completado.

# Tarea 8

El cliente es el que hace DHCPDISCOVER y DHCPREQUEST.

# Tarea 9

El mensaje de DHCPDECLINE implica que el cliente ha descubierto mediante otros
medios que la dirección IP sugerida está en uso. 

# Tarea 11

Es el proceso por el cuál, el cliente DHCP renueva o actualiza su configuración
de dirección IP con el servidor DHCP.

# Tarea 12

Cuando el tiempo de renovación expira, el cliente DHCP intenta renovarlar.
Si pasado un tiempo, no recibe ninguna respuesta o sigue recibiendo
respuestas negativas del servidor, intenta un reenganche. Esto es
esencialmente el mismo proceso, envía un mensaje por broadcast preguntando 
por el servidor DHCP, y se engancha al servidor si la respuesta es positiva.

# Tarea 13

Si un servidor responde con DHCPACK, el cliente renueva el alquiler (T3) y
coloca los temporizadores T1 y T2, retornando al estado BOUND. Si no hay,
el alquiler cesa y el cliente DHCP pasa al estado INIT.

# Tarea 14

Cuando expira la concesión, si el usuario se libera armoniosamente, el cliente
enviará un mensaje DHCPRELEASE al servidor DHCP para cancelar el alquiler y la
dirección IP estará disponible.

# Tarea 15

Depende de la asignación que tengamos puesta en el servidor:

* Asignación manual --> se la volvemos a asignar.

* Asignación automática --> la dirección IP siempre será la misma aunque
reiniciemos.

* Asignación dinámica --> Cuando apagamos, se libera su dirección y la entrega 
al servidor DHCP. Este puede reasignar dicha dirección a otro cliente que 
la pida.

# Tarea 16


# Tarea 17


# Tarea 18

En Debian, para liberar la IP usaremos el siguiente comando:

```sudo dhclient -r -v```

y para renovarla, este otro:

```sudo dhcliente -v```

# Tarea 19

La lista de concesiones es un listado donde se muestra las concesiones de IP
dadas a clientes.

El fichero se guarda en _/var/lib/dhcp/dhcpd.leases

# Tarea 20

* **max-lease-time** --> tiempo máximo que se permite asignar a una concesión
una dirección IP.

* **default-lease-time** --> tiempo que se asigna de manera predeterminada,
medido en ticks, para conceder una dirección IP.

# Tarea 21

Este fichero gestiona una lista de los alquileres que han sido asignados.
Este fichero se encuentra en:

/var/state/dhcp/dhclient.leases
/var/lib/dhclient/dhclient.leases
/var/db/dhclient.leases
