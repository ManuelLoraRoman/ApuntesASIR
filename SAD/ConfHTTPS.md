# Configuración HTTPS

El siguiente paso de nuestro proyecto es configurar de forma adecuada el 
protocolo HTTPS en nuestro servidor web para nuestra aplicaciones web. Para ello
vamos a emitir un certificado wildcard en la AC Gonzalo Nazareno utilizando 
para la petición la utilidad "gestiona".

* Explica los pasos fundamentales para la creación del certificado. 
Especificando los campos que has rellenado en el fichero CSR.

El procedimiento habitual para la generación del fichero .csr es el siguiente:

1. Generamos la clave privada.

```
manuel@debian:~/Descargas/claves$ openssl genrsa -out mikey.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
..................++++
.....................................................++++
e is 65537 (0x010001)
```

2. Extraemos la clave pública de dicha clave privada:

```
manuel@debian:~/Descargas/claves$ openssl rsa -in mikey.key -pubout -out mikey.pubkey
writing RSA key
```

Por último, vamos a utilizar la clave privada para la generación del .csr:

```
manuel@debian:~/Descargas/claves$ openssl req -new -key mikey.key -out centos.csr
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
Organization Name (eg, company) [Internet Widgits Pty Ltd]:IES Gonzalo Nazareno
Organizational Unit Name (eg, section) []:Informática
Common Name (e.g. server FQDN or YOUR name) []:*.manuel-lora.gonzalonazareno.org
Email Address []:manuelloraroman@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

En el parámetro llamado Common Name, debemos incorporar el simbolo * para un wildcard.

Y esperamos a que nos firmen dicha solicitud de certificado wildcard.
   
* Debes hacer una redirección para forzar el protocolo https.
   


* Investiga la regla DNAT en el cortafuego para abrir el puerto 443.
   
* Instala el certificado del AC Gonzalo Nazareno en tu navegador para que se 
pueda verificar tu certificado.

