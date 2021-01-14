# Cortafuegos

Vamos a construir un cortafuegos en dulcinea que nos permita controlar el 
tráfico de nuestra red. El cortafuegos que vamos a construir debe funcionar 
tras un reinicio.

## Política por defecto

La política por defecto que vamos a configurar en nuestro cortafuegos será de 
tipo DROP.

```

```

## NAT 

* Configura de manera adecuada las reglas NAT para que todas las máquinas de 
nuestra red tenga acceso al exterior.
   
* Configura de manera adecuada todas las reglas NAT necesarias para que los 
servicios expuestos al exterior sean accesibles.


## Reglas

Para cada configuración, hay que mostrar las reglas que se han configurado y 
una prueba de funcionamiento de la misma:


## ping

1. Todas las máquinas de las dos redes pueden hacer ping entre ellas.
   
2. Todas las máquinas pueden hacer ping a una máquina del exterior.
   
3. Desde el exterior se puede hacer ping a dulcinea.
   
4. A dulcinea se le puede hacer ping desde la DMZ, pero desde la LAN se le debe 
rechazar la conexión (REJECT).


## ssh

1. Podemos acceder por ssh a todas las máquinas.
   
2. Todas las máquinas pueden hacer ssh a máquinas del exterior.
   
3. La máquina dulcinea tiene un servidor ssh escuchando por el puerto 22, pero 
al acceder desde el exterior habrá que conectar al puerto 2222.


## dns

1. El único dns que pueden usar los equipos de las dos redes es freston, no 
pueden utilizar un DNS externo.
   
2. Dulcinea puede usar cualquier servidor DNS.
   
3. Tenemos que permitir consultas dns desde el exterior a freston, para que, 
por ejemplo, papion-dns pueda preguntar.


## Base de datos

1. A la base de datos de sancho sólo pueden acceder las máquinas de la DMZ.

## Web

1. Las páginas web de quijote (80, 443) pueden ser accedidas desde todas las 
máquinas de nuestra red y desde el exterior.

## Más servicios

1. Configura de manera adecuada el cortafuegos, para otros servicios que tengas 
instalado en tu red (ldap, correo, ...)
