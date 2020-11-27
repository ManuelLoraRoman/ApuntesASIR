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

En primer lugar , generaremos la clave para la CA:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl genrsa -out ca.key 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
....................+++++
...............+++++
e is 65537 (0x010001)
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ ls
ca.key
```

Una vez tengamos eso hecho, generamos un certificado autofirmado para la CA:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl req -new -x509 -key ca.key -out ca.crt
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
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Lorax CA 
Organizational Unit Name (eg, section) []:LORAX CA
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:manuelloraroman@gmail.com
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ ls
ca.crt  ca.key
```

Crearemos ahora el fichero de configuración llamado _ca.cnf_ cuyo contenido contendrá
lo siguiente:

```
# we use 'ca' as the default section because we're usign the ca command
# we use 'ca' as the default section because we're usign the ca command
[ ca ]
default_ca = my_ca

[ my_ca ]
#  a text file containing the next serial number to use in hex. Mandatory.
#  This file must be present and contain a valid serial number.
serial = ./serial

# the text database file to use. Mandatory. This file must be present though
# initially it will be empty.
database = ./index.txt

# specifies the directory where new certificates will be placed. Mandatory.
new_certs_dir = ./newcerts

# the file containing the CA certificate. Mandatory
certificate = ./ca.crt

# the file contaning the CA private key. Mandatory
private_key = ./ca.key

# the message digest algorithm. Remember to not use MD5
default_md = sha1

# for how many days will the signed certificate be valid
default_days = 365

# a section with a set of variables corresponding to DN fields
policy = my_policy

[ my_policy ]
# if the value is "match" then the field value must match the same field in the
# CA certificate. If the value is "supplied" then it must be present.
# Optional means it may be present. Any fields not mentioned are silently
# deleted.
countryName = match
stateOrProvinceName = supplied
organizationName = supplied
commonName = supplied
organizationalUnitName = optional
commonName = supplied

[ ca ]
default_ca = my_ca

[ my_ca ]
#  a text file containing the next serial number to use in hex. Mandatory.
#  This file must be present and contain a valid serial number.
serial = ./serial

# the text database file to use. Mandatory. This file must be present though
# initially it will be empty.
database = ./index.txt

# specifies the directory where new certificates will be placed. Mandatory.
new_certs_dir = ./newcerts

# the file containing the CA certificate. Mandatory
certificate = ./ca.crt

# the file contaning the CA private key. Mandatory
private_key = ./ca.key

# the message digest algorithm. Remember to not use MD5
default_md = sha1

# for how many days will the signed certificate be valid
default_days = 365

# a section with a set of variables corresponding to DN fields
policy = my_policy

[ my_policy ]
# if the value is "match" then the field value must match the same field in the
# CA certificate. If the value is "supplied" then it must be present.
# Optional means it may be present. Any fields not mentioned are silently
# deleted.
countryName = match
stateOrProvinceName = supplied
organizationName = supplied
commonName = supplied
organizationalUnitName = optional
commonName = supplied
```

Y después de editarlo, ejecutaremos también estos otros:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ mkdir newcerts
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ touch index.txt
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ echo '01' > serial
```

Con esto hecho, ya podríamos firmas cualquier _.csr_ que nos llegue con el comando:

```
openssl x509 -req -in [.csr] -CA ca.crt -CAkey ca.key -CAcreateserial -out [.crt]
```

Aunque también se puede firmar con la configuración creada anteriormente:

```
openssl ca -config ca.cnf -out [.crt]```
```

* Debe recibir el fichero CSR (Solicitud de Firmar un Certificado) de su 
compañero, debe firmarlo y enviar el certificado generado a su compañero.

Recibimos el fichero _.csr_ de nuestro compañero llamado _servidor.org.csr_.

Ahora procederemos a firmalo y enviárselo de vuelta.

Otra forma de firmalo, es usando un fichero de configuración que permita el uso 
de AltNames como en el 2º ejemplo de la creación del _.csr_. El contenido de 
ese fichero tiene el siguiente contenido:

```
basicConstraints=CA:FALSE
subjectAltName= @alt_names
subjectKeyIdentifier = hash

[ alt_names ]
DNS.1 = manuelloraroman.iesgn.org
DNS.2 = www.manuelloraroman.iesgn.org
DNS.3 = debian
```

Pero firmaremos el _.csr_ con la configuración comentada en el anterior 
apartado:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl ca -config ca.cnf -out servidor.org.crt -extfile ca.extensions.cnf -in servidor.org.csr 
Using configuration from ca.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'ES'
stateOrProvinceName   :ASN.1 12:'Sevilla'
localityName          :ASN.1 12:'Dos Hermanas'
organizationName      :ASN.1 12:'Servidor Manuel'
organizationalUnitName:ASN.1 12:'MLR'
commonName            :ASN.1 12:'manuelloraroman.iesgn.org'
Certificate is to be certified until Nov 17 18:33:38 2021 GMT (365 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ ls
ca.cnf             index.txt.attr      serial            servidor.org.key
ca.crt             index.txt.attr.old  serial.old        servidor.org.pubkey
ca.extensions.cnf  index.txt.old       servidor.conf
ca.key             newcerts            servidor.org.crt
index.txt          oats.key            servidor.org.csr
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ 
```

* ¿Qué otra información debes aportar a tu compañero para que éste configure 
de forma adecuada su servidor web con el certificado generado?

Se le debe adjuntar también el certificado de la CA para que funcione de manera 
correcta.

El alumno que hace de administrador del servidor web, debe entregar una 
documentación que describa los siguientes puntos:

* Crea una clave privada RSA de 4096 bits para identificar el servidor.

Generamos la clave privada para el servidor:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl genrsa -out servidor.org.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
...............................................................................................................................................................................................................++++
.........................................................................................................................................................................................................................................................++++
e is 65537 (0x010001)
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ ls
ca.crt  ca.key  servidor.org.key
```

Extraeremos la clave pública de la clave privada:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl rsa -in servidor.org.key -pubout -out servidor.org.pubkey
writing RSA key
```

* Utiliza la clave anterior para generar un CSR, considerando que deseas 
acceder al servidor tanto con el FQDN (tunombre.iesgn.org) como con el nombre 
de host (implica el uso de las extensiones Alt Name).

**1era forma:**
   
Utilizaremos dicha clave para la generación del CSR:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl req -new -key servidor.org.key -out servidor.org.csr
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
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Servidor Manuel
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:*.servidor.org
Email Address []:        

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ ls
ca.crt  ca.key  servidor.org.csr  servidor.org.key  servidor.org.pubkey
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ 
```

**2ª forma:**

Creamos un fichero de configuración con el siguiente contenido:

```
[req]
default_bits = 2048
default_keyfile = oats.key
encrypt_key = no
default_md = sha1
utf8 = yes
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = ES
ST = Sevilla
L = Dos Hermanas
O = Servidor Manuel
OU = MLR               
CN = manuelloraroman.iesgn.org

[v3_req]
basicConstraints=CA:FALSE
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = manuelloraroman.iesgn.org
DNS.2 = www.manuelloraroman.iesgn.org
DNS.3 = debian
```

Y crearemos la solicitud _.csr_ con la configuración creada:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ openssl req -new -out servidor.org.csr -config servidor.conf 
Generating a RSA private key
.+++++
......................................................................................................................................................+++++
writing new private key to 'oats.key'
-----
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ ls
ca.cnf  index.txt       newcerts  serial.old        servidor.org.key
ca.crt  index.txt.attr  oats.key  servidor.conf     servidor.org.pubkey
ca.key  index.txt.old   serial    servidor.org.csr
manuel@debian:/media/manuel/Datos/Cosas Seguridad/CA$ 
```

Y se nos creará la solicitud. Esta configuración permite el uso de AltNames.

* Envía la solicitud de firma a la entidad certificadora (su compañero).
   
Le enviamos dicha solicitud a nuestro compañero encargado de la autoridad
certificadora.

* Recibe como respuesta un certificado X.509 para el servidor firmado y el 
certificado de la autoridad certificadora.

Hemos recibido de nuestro compañero (CA) tanto su certificado como el nuestro firmado.

* Configura tu servidor web con https en el puerto 443, haciendo que las 
peticiones http se redireccionen a https (forzar https).
   
Crearemos una pagina web sencilla en nuestra máquina con apache2. El fichero de 
configuración contendrá la siguiente información:

```
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        ServerName manuelloraroman.iesgn.org

        SSLEngine on
        SSLCertificateFile /media/manuel/Datos/Cosas\ Seguridad/CA/servidor.org.crt
        SSLCertificateKeyFile /media/manuel/Datos/Cosas\ Seguridad/CA/oats.key
        SSLCertificateChainFile /media/manuel/Datos/Cosas\ Seguridad/CA/ca.crt

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
```

* Instala ahora un servidor nginx, y realiza la misma configuración que 
anteriormente para que se sirva la página con HTTPS.

Crearemos ahora la misma página, pero ahora con nginx. La configuración necesaria para el uso de 
certificados es la siguiente:

```
server {

	listen 80;
	listen [::]:80;
	
	root /var/www/html;

	index index.html index.htm index.nginx-debian.html index.php;
	
        server_name manuelloraroman.iesgn.org;
	
	ssl	on;
	ssl_certificate	/media/manuel/Datos/Cosas\ Seguridad/CA/servidor.org.crt
	ssl_certificate_key	/media/manuel/Datos/Cosas\ Seguridad/CA/oats.key

	location / {	
			try_files $uri $uri/ =404;
	}
}
```

En la configuración de Nginx, el certificado firmado nuestro, ha de contener tanto el .csr firmado, como
el certificado de la CA.

Y reiniciamos el servicio.
