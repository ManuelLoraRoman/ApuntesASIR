# Cuestionario de repaso


## Repaso TCP/IP


* **Tarea 1.** Teniendo en cuenta el siguiente esquema de red, configura la interfaz de red 
	       de un cliente para tener acceso a internet, utiliza direccionamiento estático. 
	       ¿Qué diferencia hay entre dirección estática y dinámica? 
	       ¿Qué dirección del router es la pública? ¿Cuál es la privada? 
	       Define cada uno de los parámetros que has configurado: puerta de enlace, 
	       mascara de red, etc.


* **Tarea 2.** Cambia el direccionamiento de red de nuestra internet con la red 172.22.0.0/16 
	       ¿Cuantos equipos podemos tener en esta red?


* **Tarea 3.** Nuestro clientes pueden acceder a internet porque el router hace Source NAT 
	       ¿Explica en que consiste? Si tenemos un servidor linux haciendo de router, 
	       ¿cómo se configura para hacer SNAT?. Del mismo modo si 
	       tenemos un servidor Windows, ¿cómo se se configura?


* **Tarea 4.** ¿Qué puerto se utiliza por defecto para conectarse a un servidor web?
	       ¿Y para el servidor DNS? ¿Para qué se usa el puerto 22?


* **Tarea 5.** Imagina que en nuestra intranet instalamos un servidor web. 
	       ¿Qué configuración hay que hacer en el router para poder acceder 
	       desde internet al servidor? ¿Cómo se llama esta técnica?


* **Tarea 6.** Si nombramos las máquinas de nuestra intranet, y tenemos un sistema linux, 
	       ¿en qué fichero se configura el nombre?


* **Tarea 7.** ¿Qué es la resolución estática de nombres? 
	       ¿En qué fichero se configura en Windows?¿Y en linux?


* **Tarea 8** Si nuestro cliente tiene un sistema linux, 
	      ¿en qué fichero hemos configurado la red?¿y los servidores DNS?


* **Tarea 9** Muestra la configuración de red de tu ordenador de clase. 
	      ¿Qué servidor DNS se está utilizando?


### Tarea 1

Una dirección IP dinámica es la que cambia cada cierto tiempo, es decir, la IP
cambia en función de las necesidades del servidor, siendo útil en el balanceo
de carga. Mientras tanto la IP estática es asignada a un dispositivo, y nunca
se modifica.

La IP pública del router es aquella que aparece en la _Puerta de enlace_ 
_predeterminada_.

La dirección privada suele empezar por 192.168....

Definiciones:

* **Puerta de enlace** --> es el nodo que sirve como enlace entre dos redes.
			   Es aquel dispositivo que conecta y dirige el
			   tráfico de datos entre dos redes.

* **Máscara de red** --> es una combinación de bits que sirve para delimitar
			 el ámbito de una red de computadoras. Su función es 
			 indicar a los dispositivos qué parte de la dirección
			 IP es el número de la red y cuál es la del host.


### Tarea 3

Source NAT cambia la dirección de origen en el encabezado IP de los paquetes.
También cambia el puerto de origen en encabezados TCP/UDP. El uso típico
es cambiar de dirección/puerto privado a uno público para paquetes que salen
de tu red.

Para configurar SNAT, se debe implementar iptables.


### Tarea 4

El puerto 80, usado habitualmente para el protocolo HTTP.

Para el servidor DNS se utiliza el puerto 53.

El puerto 22 (SSH) sirve para acceder a máquinas remotas a través de una red.


### Tarea 5

La técnica utilizada se llama _"abrir los puertos"_.


### Tarea 6

Hostnames


### Tarea 7

En Windows se hará en el System32, y en Linux

### Tarea 8

La herramienta que se encarga de traducir nombres de máquina a direcciones IP
y viceversa.

La red se configura en el fichero /etc/network/interfaces.

El DNS se configura en este otro: /etc/resolv.conf.


### Tarea 9

Servidor DNS de Google



## Repaso DNS


* **Tarea 1.** ¿Qué herramientas se usa en linux para realizar una consulta DNS?¿Y en Windows? 
	       Pregunta en varios sistemas cuál es la dirección IP de www.marca.com. 
	       Realiza una consulta para saber los servidores DNS 
	       que conocen el dominio gonzalonazareno.org.


* **Tarea 2.** ¿Qué ocurre si hacemos una consulta para averiguar la ip de 
	       dit.gonzalonazareno.org desde el ordenador del aula y desde 
	       el ordenador de tu casa? Razona la respuesta.


* **Tarea 3.** A qué servidor DNS le estás consultando desde clase. 
	       Realiza una consulta a www.google.es consultando a nuestro DNS. 
	       Vuelve a hacer la consulta usando el servidor público que ofrece google.


* **Tarea 4.** ¿Qué información puedo guardar en una zona DNS? ¿Qué registros puedo guardar? 
	       ¿Cuantos tipos de zonas existen?


* **Tarea 5.** Si desde clase, consulto la dirección IP de www.josedomingo.org? 
	       ¿Cuál es el proceso de consultas que se realiza? 
	       ¿A que servidores se va preguntando?


* **Tarea 6.** ¿Qué son los root server? ¿Cuántos hay?


* **Tarea 7.** Haz una consulta a www.nyu.edu ¿Cuánto ha tardado la consulta?. Vuelve a hacerla, 
	       ¿Ha durado menos? ¿por qué?



* **Tarea 8.** ¿Por qué desde clase la consulta a la dirección IP dit.gonzalonazareno.org 
	       es distinta que si la hacemos desde casa?


* **Tarea 9.** ¿Qué dirección IP tiene babuino.gonzalonazareno.org y dit.gonzalonazareno.org 
	       desde clase? ¿Qué relación existe ambos nombres?


* **Tarea 10.** ¿A que servidor mandamos el correo cuya dirección de destino 
		es correo@josedomingo.org? ¿Y si lo mandamos a usuario@amazon.es?


* **Tarea 11.** Desde clase, ¿cómo se llama el ordenador que tiene la dirección IP 192.168.103.2?


* **Tarea 12.** ¿Por qué hay varios servidores con autoridad sobre la zona josedomingo.org?


* **Tarea 13.** Una vez que sepas la dirección del servidor con autoridad sobre la zona 
		josedomingo.org, realiza una consulta a ese servidor preguntando por 
		www.josedomingo.org. ¿qué proceso de consultas se sigue?


Una zona DNS es el conjunto de nombres definidos en un dominio.
Cada zona estan guardadas dentro de un fichero en un servidor. A ese servidor se
le llama Servidor DNS con autoridad sobre la zona. Pueden ser varios servidores.


dig ns _servidor_ --> te muestra los servidores con autoridad.


### Tarea 1




### Tarea 2




### Tarea 3




### Tarea 4




### Tarea 5




### Tarea 6




### Tarea 7




### Tarea 8




### Tarea 9




### Tarea 10




### Tarea 11




### Tarea 12




### Tarea 13
