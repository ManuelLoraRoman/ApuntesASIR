# Práctica: Certificados digitales. HTTPS

## Certificado digital de persona física

**Tarea 1** Instalación del certificado.


1. Una vez que hayas obtenido tu certificado, explica brevemente como se 
instala en tu navegador favorito.

Una vez descargado nuestro certificado, nos iremos a nuestro explorador web. 
En nuestro caso, lo estamos haciendo con Mozilla Firefox. Nos iremos a:

```Abrir Menú --> Preferencias --> Privacidad y Seguridad --> Certificados```

Una vez ahí, le damos a _Ver certificados..._ y en la pestaña de 
_Sus certificados_ le damos a importar y seleccionaremos nuestro certificado.

![alt text](../Imágenes/mozillacert.png)

2. Muestra una captura de pantalla donde se vea las preferencias del navegador 
donde se ve instalado tu certificado.
   
En el anterior apartado se muestra nuestro certificado.

3. ¿Cómo puedes hacer una copia de tu certificado?, ¿Como vas a realizar la 
copia de seguridad de tu certificado?. Razona la respuesta.
   
Nos iremos a la ubicación de nuestro certificado en nuestro explorador web y
seleccionaremos nuestro certificado. Para hacer una copia regular, le damos
a la pestaña de _Hacer copia..._ y nos pedirá una ubicación donde guardarlo en
nuestra máquina. Hecho esto, nos pedirá definir una contraseña para proteger
nuestra copia de respaldo del certificado.

![alt text](../Imágenes/copiacert.png)

4. Investiga como exportar la clave pública de tu certificado.

En Mozilla Firefox, debemos seleccionar nuestro certificado y le damos a la
pestaña _Ver..._. Se nos abrirá una ventana emergente con dos pestañas, 
_General_ y _Detalles_. Le damos a Detalles y pulsamos el botón de exportar. 
De esta manera, solo se exportará la clave pública de nuestro certificado.


**Tarea 2:** Validación del certificado

1. Instala en tu ordenador el software autofirma y desde la página de VALIDe 
valida tu certificado. Muestra capturas de pantalla donde se comprueba la 
validación.

Nos descargamos el fichero del siguiente link:

```
wget https://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma_Linux.zip
unzip AutoFirma_Linux.zip
sudo dpkg -i AutoFirma_1_6_5.deb
```

Con esto, ya tendríamos instalado el software de Autofirma en nuestra máquina.

Ahora nos dirigimos a la página de VALIDe y nos vamos a la zona de 
_Validar Certificado_.

Al pulsar en _Seleccionar Certificado_ nos permitirá elegir el software de 
Autofirma. En nuestro caso particular, no nos funciona el software de autofirma
y usaremos la opción de validar el certificado manualmente.

Introducimos el certificado y pondremos el código de seguridad, y nos dirá si
es válido.

![alt text](../Imágenes/precert.png)

![alt text](../Imágenes/certvalido.png)


**Tarea 3:** Firma electrónica

1. Utilizando la página VALIDe y el programa autofirma, firma un documento 
con tu certificado y envíalo por correo a un compañero.


   
2. Tu debes recibir otro documento firmado por un compañero y utilizando las 
herramientas anteriores debes visualizar la firma (Visualizar Firma) y 
(Verificar Firma). ¿Puedes verificar la firma aunque no tengas la clave 
pública de tu compañero?, ¿Es necesario estar conectado a internet para hacer 
la validación de la firma?. Razona tus respuestas.
   
3. Entre dos compañeros, firmar los dos un documento, verificar la firma para 
comprobar que está firmado por los dos.



**Tarea 4:** Autentificación

1. Utilizando tu certificado accede a alguna página de la administración 
pública )cita médica, becas, puntos del carnet,…). Entrega capturas de 
pantalla donde se demuestre el acceso a ellas.

![alt text](../Imágenes/citamedica.png)

![alt text](../Imágenes/citamedica2.png)



## HTTPS / SSL

**Tarea 1:** Certificado autofirmado

Esta práctica la vamos a realizar con un compañero. En un primer momento un 
alumno creará una Autoridad Certficadora y firmará un certificado para la 
página del otro alumno. Posteriormente se volverá a realizar la práctica con 
los roles cambiados.

Para hacer esta práctica puedes buscar información en internet, algunos 
enlaces interesantes:

* Phil’s X509/SSL Guide
* How to setup your own CA with OpenSSL
* Crear autoridad certificadora (CA) y certificados autofirmados en Linux

El alumno que hace de Autoridad Certificadora deberá entregar una documentación donde explique los siguientes puntos:

* Crear su autoridad certificadora (generar el certificado digital de la CA). 
Mostrar el fichero de configuración de la AC.

En primer lugar crearemos la clave privada para la CA:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl genrsa -des3 -out ca.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
.............................................++++
...................................................................................................................................................................................................................................................................................................++++
e is 65537 (0x010001)
Enter pass phrase for ca.key:
140253891232896:error:28078065:UI routines:UI_set_result_ex:result too small:../crypto/ui/ui_lib.c:905:You must type in 4 to 1023 characters
Enter pass phrase for ca.key:
Verifying - Enter pass phrase for ca.key:
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ ls
ca.key
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ chmod 700 ca.key
```

Ahora creamos el certificado. Este se mostrará en el nivel más alto cuando
firmes otros certificado. Le pondremos cuando queremos que expire:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
Enter pass phrase for ca.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ES
State or Province Name (full name) [Some-State]:Sevilla
Locality Name (eg, city) []:Dos Hermanas
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Certificado Manuel Lora
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:Debian Manuel
Email Address []:manuelloraroman@gmail.com
```




* Debe recibir el fichero CSR (Solicitud de Firmar un Certificado) de su 
compañero, debe firmarlo y enviar el certificado generado a su compañero.

* ¿Qué otra información debes aportar a tu compañero para que éste configure 
de forma adecuada su servidor web con el certificado generado?

El alumno que hace de administrador del servidor web, debe entregar una 
documentación que describa los siguientes puntos:

* Crea una clave privada RSA de 4096 bits para identificar el servidor.

Creamos la clave privada:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl genrsa -des3 -out manuelloraroman.iesgn.org.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
..............................................++++
...................................................................................................++++
e is 65537 (0x010001)
Enter pass phrase for manuelloraroman.iesgn.org.key:
Verifying - Enter pass phrase for manuelloraroman.iesgn.org.key:
```

Y creamos la solicitud:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl req -new -key manuelloraroman.iesgn.org.key -out manuelloraroman.iesgn.org.csr
Enter pass phrase for manuelloraroman.iesgn.org.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ES
State or Province Name (full name) [Some-State]:Sevilla
Locality Name (eg, city) []:Dos Hermanas
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Certificado Manuel Lora
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:manuelloraroman.iesgn.org
Email Address []:manuelloraroman@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

Si utilizamos algún servicio tipo Apache o Postfix, debemos eliminar la
contraseña de la clave:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl rsa -in manuelloraroman.iesgn.org.key -out manuelloraroman.iesgn.org.key.insecure
Enter pass phrase for manuelloraroman.iesgn.org.key:
writing RSA key
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ mv manuelloraroman.iesgn.org.key manuelloraroman.iesgn.org.key.secure
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ mv manuelloraroman.iesgn.org.key.insecure manuelloraroman.iesgn.org.key
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ ls
ca.crt  manuelloraroman.iesgn.org.csr  manuelloraroman.iesgn.org.key.secure
ca.key  manuelloraroman.iesgn.org.key
```

Y ponemos los permisos:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ chmod 700 manuelloraroman.iesgn.org.key
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ chmod 700 manuelloraroman.iesgn.org.key.secure 
```

* Utiliza la clave anterior para generar un CSR, considerando que deseas 
acceder al servidor tanto con el FQDN (tunombre.iesgn.org) como con el nombre 
de host (implica el uso de las extensiones Alt Name).
   
* Envía la solicitud de firma a la entidad certificadora (su compañero).
   
* Recibe como respuesta un certificado X.509 para el servidor firmado y el 
certificado de la autoridad certificadora.
   
* Configura tu servidor web con https en el puerto 443, haciendo que las 
peticiones http se redireccionen a https (forzar https).
   
* Instala ahora un servidor nginx, y realiza la misma configuración que 
anteriormente para que se sirva la página con HTTPS.


