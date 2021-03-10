<div align="center">

## Proyecto TFG

</div>

La idea principal de mi proyecto es la implementación de la aplicación _Rocket.Chat_ con contenedores
Docker. Rocket.Chat es una herramienta que permite, de manera segura, mantener los datos y las 
comunicaciones centralizadas. 

Sale como propuesta _Open-source_ a las diferentes herramientas como pueden ser WhatsApp, Gmail, Slack
entre otros, en los cuáles, los datos terminan siendo almacenados en contenedores aislados, 
lo que dificulta la gestión de la información entrante.

Dicha aplicación es totalmente configurable, en contrapartida, por ejemplo a Slack, en la que algunas
de sus funcionalidades están bloqueadas por un _paywall_. Además, ya que Rocket.Chat solamente
puede instalarse en servidores internos, dispones del almacenamiento que dispongas, y no de una
capacidad limitada por espacio de trabajo.

Además, los datos que se guarden con Rocket.Chat solamente podrán ser accedidos por personas 
autorizadas, mientras que en las demás herramientas no está garantizado. 

Otra ventaja de la que dispone Rocket.Chat es que es una aplicación multilingüe, en contra partida a
Slack cuya interfaz está enteramente en inglés.

A todo esto, incluyele la posible integración de autenticación con _OpenLDAP_ u _Active Directory_, 
además de por hacerlo mediante otros sistemas como Github, Nextcloud u Google, entre otros.

Para resumir un poco, _Rocket.Chat_ dispone de estas funcionalidades esenciales:

* Videoconferencia, con posibilidad de integrar el servicio con jitsi o BigBlueButton.

* Autenticación mediante diferentes sistemas.

* Compartir pantalla.

* Transferencia de ficheros.

* Buscador avanzado de conversaciones.

* Grupos de discusión.

* Programación de Bots.

La documentación de dicha herramienta se encuentra aquí:

* https://docs.rocket.chat/


Explicado un poco qué es _Rocket.Chat_ y algunas de sus funcionalidades, los objetivos a conseguir
con este proyecto serían:

* Instalación de la aplicación Rocket.Chat mediante Docker.

* Configuración de la seguridad de la aplicación.

* Configuración de la autenticación con LDAP.

* Implementación de dicha herramienta en el clúster del instituto.


Con respecto a la previsión de medios, los requisitos para la instalación de dicha aplicación 
varían muchos con respecto a los usuarios conectados concurrentemente, la cantidad de  dispositivos 
conectados por usuario, la misma actividad de los usuarios o la integración de bots. Por ello,
lo mínimo requerido sería:

* Ubuntu 18.04 LTS

* Intel Xeon E5-2603 v4 o equivalente [1.7 GHz, 6 cores]

* 4 GB RAM

* 500 GB o más de disco duro

Esta configuración es ideal en caso de empresas con 1000 usuarios con hasta 300 usuarios activos de
manera concurrente.


Si la configuración va a ser virtual, los requisitos serían los siguientes:

|Minimo | Recomendado|
|-------|------------|
|Single core (2 GHz)|Dual-Core(2 GHz)|
|1 GB RAM|2 GB RAM|
|30 GB SSD|40 GB SSD|

La configuración permite hasta 200 usuarios, 50 de ellos activos de manera concurrente, mientras que la
recomendada sería de 500 y hasta 100 activos al mismo tiempo.
