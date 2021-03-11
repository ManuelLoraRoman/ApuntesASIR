<div align="center">

## Rocket.Chat implementado con Docker y autenticación con LDAP

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
además de poder hacerlo mediante otros sistemas como Github, Nextcloud u Google, entre otros.

Por otra parte, también existen alternativas _Open-source_ además de Rocket.Chat. Algunas de ellas son 
_Matrix.org_ y _Mattermost_. Ambas ofrecen funcionalidades parecidas y pueden ser una alternativa
más que viable en caso de que _Rocket.Chat_ sea echado para atrás.

Por un lado, _Matrix_ ofrece tanto Videollamadas, mensajería e integración con otras aplicaciones
incluyendo para la autenticación. Utiliza los algoritmos de _Olm y Megolm_ para encriptar los mensajes.
El funcionamiento de _Matrix_ se basa en que cuando se envía un mensaje, éste se replica en todos los
servidores cuyos usuarios participan en dicha conversación, siendo similar a _Git_.
Por lo general, lo que más llama la atención de este software es la posibilidad de crear una red de
communicación con otras herramientas como Telegram, Discord, Slack o IRC y con los propios usuarios. 
Es decir, cada aplicación y/o usuario despliega un servidor por su propia cuenta y se conecta a la
red con su cliente. Por lo tanto, en caso de que uno de los servidores se caiga, la comunicación pasa
a otro servidor ininterrumpidamente. 

Esta principal característica, es lo que me ha hecho elegir Rocket.Chat, ya que se adaptaría mejor
en el entorno de trabajo de nuestro instituto.

Y por otro lado tenemos _Mattermost_. Esta opción es más interesante que la anterior, ya que se 
adecua mejor a la estructura cliente-servidor. Ofrece la posibilidad de desplegar dicho servidor también
en una nube privada de manera totalmente gratuita.

La instalación recomendada es en Ubuntu 18.04/20.04, aunque es posible la instalación en muchos otros
como puede ser en Debian, CentOS u Oracle Linux, pudiendolo implementar con Docker, Kubernetes o Helm.

Las funcionalidades que dispone _Mattermost_ son las siguientes:

* Combina la automatización con la supervisión, para maximizar el tiempo de funcionamiento, reduciendo
así el tiempo de respuesta.

* Monitorización del progreso de actividades, incluyendo testeos en tiempo real.

* Grupos de discusión.

* Notificaciones.

* Canales dedicados para visibilizar incidentes.

* Videoconferencias.

* Programación con bots.

El único inconveniente es que muchas de las funcionalidades de las que dispone _Mattermost_ están 
mayormente orientadas a su servicio de Cloud público, pudiendo estar dentro del plan gratuito o detrás
de un _paywall_ como con Slack. Aunque esto puede ser un inconveniente, se verá más adelante que tan
buena opción podría ser en comparación.

Para resumir un poco, _Rocket.Chat_ dispone de estas funcionalidades esenciales:

* Videoconferencia, con posibilidad de integrar el servicio con jitsi o BigBlueButton.

* Autenticación mediante diferentes sistemas.

* Compartir pantalla o directorios.

* Transferencia de ficheros.

* Buscador avanzado de conversaciones.

* Grupos de discusión.

* Programación de Bots.


Explicado un poco qué es _Rocket.Chat_ y algunas de sus funcionalidades, los objetivos a conseguir
con este proyecto serían:

* Instalación de la aplicación mediante Docker.

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


La documentación de algunas de las aplicaciones comentadas aquí:

* https://docs.rocket.chat/

* https://docs.mattermost.com/

* https://matrix.org/docs/guides/getting-involved

* https://alternativeto.net/software/rocket-chat/
