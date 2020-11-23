# Servidor DNS

El DNS se utiliza para diferentes propósitos:

* **Resolución de nombres**: dado un nombre de un host, obtiene una IP.

* **Resolución inversa de direcciones**: dada una IP, obtiene el nombre
					 asociado a la misma.

* **Resolución de servidores de correo**: dado un nombre de dominio, obtener
					  el servidor a través del cual debe
					  realizarse la entrega del correo.

* Una zona DNS es un conjunto de nombre definidos para un dominio. También 
guardamos información del servidor DNS. Cada zona está guardado en un servidor 
DNS, y el servidor que lo guarda que se llama _Servidor con autoridad de la zona_.

Un servidor recursivo es aquel que es capaz de llamar a los _root servers_.

* **Tipo NS** --> servidores DNS

* **Tipo A** --> nombres de los equipos que quiero que sean conocidos.

* **Tipo CNAME** --> mediante un alias (por ejemplo, el nombre de un equipo)

* **Tipo MX** --> servidores de correo

Nombre de dominio para la resolucion inversa con respecto a la IP 172.22.X.X es
22.172.in-addr.arpa. .

El SOA de la resolucion inversa es el mismo que la directa.

El NS es el mismo también.

$ORIGIN --> lo ponemos para no poner todo el nombre cualificado.
$ORIGIN 22.172.in-addr.arpa.

Ejemplo:

2.1 PTR pepito.iesgnXX.es

3.1 PTR juanito...  


* **PTR** significa pointer


```nano db.empty``` para realizar el ejercicio.

* **TTL** --> tiempo de vida

