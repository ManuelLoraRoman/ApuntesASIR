<div align="center">

# Cortafuegos

</div>


Permite analizar el tráfico de red al atravesar un dispositivo y tomar 
decisiones acerca del mismo:

* Permitir / Denegar el paso.

* Modificar el tráfico.

* Seleccionar tráfico para otra aplicación.

Se usa para controlar el tráfico y mejorar el rendimiento.

El filtrado se puede hacer a diferentes capas: nivel de enlace (MAC), nivel
de red (IP), nivel de transporte (Puerta destino, TCP) o a nivel de 
aplicación (DNS, HTTP, FTP,...).

El filtrado de paquetes en Linux se puede hacer mediante iptables y nftables.

SNAT --> un equipo con dirección privada pueda acceder a Internet.

DNAT --> un equipo pueda acceder a un servicio ubicado en un equipo con
dirección privada.
