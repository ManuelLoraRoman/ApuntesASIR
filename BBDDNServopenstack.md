# Servidores Web, Base de Datos y DNS.

## Servidor DNS



## Servidor Web

En quijote (CentOs)(Servidor que está en la DMZ) vamos a instalar un servidor 
web apache. Configura el servidor para que sea capaz de ejecutar código php 
(para ello vamos a usar un servidor de aplicaciones php-fpm). Entrega una 
captura de pantalla accediendo a www.tunombre.gonzalonazareno.org/info.php donde
se vea la salida del fichero info.php. Investiga la reglas DNAT de cortafuegos 
que tienes que configurar en dulcinea para, cuando accedemos a la IP flotante 
se acceda al servidor web.

En primer lugar, instalaremos un servidor apache en la máquina Quijote:

```


```


## Servidor de Base de Datos

En sancho (Ubuntu) vamos a instalar un servidor de base de datos mariadb 
(bd.tu_nombre.gonzalonazareno.org). Entrega una prueba de funcionamiento donde 
se vea como se realiza una conexión a la base de datos desde quijote.
