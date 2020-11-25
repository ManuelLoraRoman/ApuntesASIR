# HTTPS

## Vamos a configurar el protocolo HTTPS para el acceso a nuestras aplicaciones, para ello tienes que tener en cuenta los siguiente.

1. Vamos a utilizar el servicio _https://letsencrypt.org_ para solicitar los certificados de 
nuestras páginas.

2. Explica detenidamente cómo se solicita un certificado en Let's Encrypt. En tu explicación 
deberás responder a estas preguntas:

* ¿Qué función tiene el cliente ACME?
    


* ¿Qué configuración se realiza en el servidor web?
   
* ¿Qué pruebas realiza Let's Encrypt para asegurar que somos los administrados del sitio web?
   
* ¿Se puede usar el DNS para verificar que somos administradores del sitio?


En primer lugar, podemos realizar la descarga del _Client Certbot_ tanto desde la página web llamada
_https://certbot.eff.org_ o desde apt con el comando ```sudo apt-get install certbot```.

Si lo hacemos desde la página web, aparecerá un instalador, pero en nuestro caso, lo haremos desde la
terminal:

```
debian@pandora:~$ sudo apt-get install certbot
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  python-pyicu python3-acme python3-certbot python3-configargparse
  python3-distutils python3-future python3-josepy python3-lib2to3 python3-mock
  python3-openssl python3-parsedatetime python3-pbr python3-requests-toolbelt
  python3-rfc3339 python3-setuptools python3-tz python3-zope.component
  python3-zope.event python3-zope.hookable python3-zope.interface
Suggested packages:
  python3-certbot-apache python3-certbot-nginx python-certbot-doc
  python-acme-doc python-future-doc python-mock-doc python-openssl-doc
  python3-openssl-dbg python-setuptools-doc
The following NEW packages will be installed:
  certbot python-pyicu python3-acme python3-certbot python3-configargparse
  python3-distutils python3-future python3-josepy python3-lib2to3 python3-mock
  python3-openssl python3-parsedatetime python3-pbr python3-requests-toolbelt
  python3-rfc3339 python3-setuptools python3-tz python3-zope.component
  python3-zope.event python3-zope.hookable python3-zope.interface
0 upgraded, 21 newly installed, 0 to remove and 0 not upgraded.
Need to get 1,901 kB of archives.
After this operation, 9,537 kB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://deb.debian.org/debian buster/main amd64 python3-openssl all 19.0.0-1 [52.1 kB]
Get:2 http://deb.debian.org/debian buster/main amd64 python3-josepy all 1.1.0-2 [27.7 kB]
Get:3 http://deb.debian.org/debian buster/main amd64 python3-lib2to3 all 3.7.3-1 [76.7 kB]
Get:4 http://deb.debian.org/debian buster/main amd64 python3-distutils all 3.7.3-1 [142 kB]
Get:5 http://deb.debian.org/debian buster/main amd64 python3-setuptools all 40.8.0-1 [306 kB]
Get:6 http://deb.debian.org/debian buster/main amd64 python3-pbr all 4.2.0-5 [56.5 kB]
Get:7 http://deb.debian.org/debian buster/main amd64 python3-mock all 2.0.0-4 [60.3 kB]
Get:8 http://deb.debian.org/debian buster/main amd64 python3-requests-toolbelt all 0.8.0-1 [38.2 kB]
Get:9 http://deb.debian.org/debian buster/main amd64 python3-tz all 2019.1-1 [27.1 kB]
Get:10 http://deb.debian.org/debian buster/main amd64 python3-rfc3339 all 1.1-1 [6,644 B]
Get:11 http://deb.debian.org/debian buster/main amd64 python3-acme all 0.31.0-2 [50.5 kB]
Get:12 http://deb.debian.org/debian buster/main amd64 python3-configargparse all 0.13.0-1 [22.5 kB]
Get:13 http://deb.debian.org/debian buster/main amd64 python3-future all 0.16.0-1 [346 kB]
Get:14 http://deb.debian.org/debian buster/main amd64 python3-parsedatetime all 2.4-2 [39.7 kB]
Get:15 http://deb.debian.org/debian buster/main amd64 python3-zope.hookable amd64 4.0.4-4+b4 [10.6 kB]
Get:16 http://deb.debian.org/debian buster/main amd64 python3-zope.interface amd64 4.3.2-1+b2 [90.1 kB]
Get:17 http://deb.debian.org/debian buster/main amd64 python3-zope.event all 4.2.0-1 [8,412 B]
Get:18 http://deb.debian.org/debian buster/main amd64 python3-zope.component all 4.3.0-1 [43.0 kB]
Get:19 http://deb.debian.org/debian buster/main amd64 python3-certbot all 0.31.0-1 [225 kB]
Get:20 http://deb.debian.org/debian buster/main amd64 certbot all 0.31.0-1 [38.5 kB]
Get:21 http://deb.debian.org/debian buster/main amd64 python-pyicu amd64 2.2-2 [234 kB]
Fetched 1,901 kB in 0s (17.5 MB/s) 
Selecting previously unselected package python3-openssl.
(Reading database ... 33946 files and directories currently installed.)
Preparing to unpack .../00-python3-openssl_19.0.0-1_all.deb ...
Unpacking python3-openssl (19.0.0-1) ...
Selecting previously unselected package python3-josepy.
Preparing to unpack .../01-python3-josepy_1.1.0-2_all.deb ...
Unpacking python3-josepy (1.1.0-2) ...
Selecting previously unselected package python3-lib2to3.
Preparing to unpack .../02-python3-lib2to3_3.7.3-1_all.deb ...
Unpacking python3-lib2to3 (3.7.3-1) ...
Selecting previously unselected package python3-distutils.
Preparing to unpack .../03-python3-distutils_3.7.3-1_all.deb ...
Unpacking python3-distutils (3.7.3-1) ...
Selecting previously unselected package python3-setuptools.
Preparing to unpack .../04-python3-setuptools_40.8.0-1_all.deb ...
Unpacking python3-setuptools (40.8.0-1) ...
Selecting previously unselected package python3-pbr.
Preparing to unpack .../05-python3-pbr_4.2.0-5_all.deb ...
Unpacking python3-pbr (4.2.0-5) ...
Selecting previously unselected package python3-mock.
Preparing to unpack .../06-python3-mock_2.0.0-4_all.deb ...
Unpacking python3-mock (2.0.0-4) ...
Selecting previously unselected package python3-requests-toolbelt.
Preparing to unpack .../07-python3-requests-toolbelt_0.8.0-1_all.deb ...
Unpacking python3-requests-toolbelt (0.8.0-1) ...
Selecting previously unselected package python3-tz.
Preparing to unpack .../08-python3-tz_2019.1-1_all.deb ...
Unpacking python3-tz (2019.1-1) ...
Selecting previously unselected package python3-rfc3339.
Preparing to unpack .../09-python3-rfc3339_1.1-1_all.deb ...
Unpacking python3-rfc3339 (1.1-1) ...
Selecting previously unselected package python3-acme.
Preparing to unpack .../10-python3-acme_0.31.0-2_all.deb ...
Unpacking python3-acme (0.31.0-2) ...
Selecting previously unselected package python3-configargparse.
Preparing to unpack .../11-python3-configargparse_0.13.0-1_all.deb ...
Unpacking python3-configargparse (0.13.0-1) ...
Selecting previously unselected package python3-future.
Preparing to unpack .../12-python3-future_0.16.0-1_all.deb ...
Unpacking python3-future (0.16.0-1) ...
Selecting previously unselected package python3-parsedatetime.
Preparing to unpack .../13-python3-parsedatetime_2.4-2_all.deb ...
Unpacking python3-parsedatetime (2.4-2) ...
Selecting previously unselected package python3-zope.hookable.
Preparing to unpack .../14-python3-zope.hookable_4.0.4-4+b4_amd64.deb ...
Unpacking python3-zope.hookable (4.0.4-4+b4) ...
Selecting previously unselected package python3-zope.interface.
Preparing to unpack .../15-python3-zope.interface_4.3.2-1+b2_amd64.deb ...
Unpacking python3-zope.interface (4.3.2-1+b2) ...
Selecting previously unselected package python3-zope.event.
Preparing to unpack .../16-python3-zope.event_4.2.0-1_all.deb ...
Unpacking python3-zope.event (4.2.0-1) ...
Selecting previously unselected package python3-zope.component.
Preparing to unpack .../17-python3-zope.component_4.3.0-1_all.deb ...
Unpacking python3-zope.component (4.3.0-1) ...
Selecting previously unselected package python3-certbot.
Preparing to unpack .../18-python3-certbot_0.31.0-1_all.deb ...
Unpacking python3-certbot (0.31.0-1) ...
Selecting previously unselected package certbot.
Preparing to unpack .../19-certbot_0.31.0-1_all.deb ...
Unpacking certbot (0.31.0-1) ...
Selecting previously unselected package python-pyicu.
Preparing to unpack .../20-python-pyicu_2.2-2_amd64.deb ...
Unpacking python-pyicu (2.2-2) ...
Setting up python3-configargparse (0.13.0-1) ...
Setting up python3-requests-toolbelt (0.8.0-1) ...
Setting up python3-zope.event (4.2.0-1) ...
Setting up python3-zope.interface (4.3.2-1+b2) ...
Setting up python3-openssl (19.0.0-1) ...
Setting up python-pyicu (2.2-2) ...
Setting up python3-tz (2019.1-1) ...
Setting up python3-zope.hookable (4.0.4-4+b4) ...
Setting up python3-josepy (1.1.0-2) ...
Setting up python3-rfc3339 (1.1-1) ...
Setting up python3-lib2to3 (3.7.3-1) ...
Setting up python3-distutils (3.7.3-1) ...
Setting up python3-setuptools (40.8.0-1) ...
Setting up python3-pbr (4.2.0-5) ...
update-alternatives: using /usr/bin/python3-pbr to provide /usr/bin/pbr (pbr) in auto mode
Setting up python3-zope.component (4.3.0-1) ...
Setting up python3-mock (2.0.0-4) ...
Setting up python3-acme (0.31.0-2) ...
Setting up python3-future (0.16.0-1) ...
update-alternatives: using /usr/bin/python3-futurize to provide /usr/bin/futurize (futurize) in auto mode
update-alternatives: using /usr/bin/python3-pasteurize to provide /usr/bin/pasteurize (pasteurize) in auto mode
Setting up python3-parsedatetime (2.4-2) ...
Setting up python3-certbot (0.31.0-1) ...
Setting up certbot (0.31.0-1) ...
Created symlink /etc/systemd/system/timers.target.wants/certbot.timer → /lib/systemd/system/certbot.timer.
Processing triggers for man-db (2.8.5-2) ...
```

Descargado el paquete, modificaremos el fichero de configuración de nuestro virtualhost con las
siguientes lineas:

```
location ~ /.well-known {
	allow all;
}
```

Y pasamos a la creación del certificado usando certbot:

```
cerbot certonly
```

Antes de seguir, debemos parar el servicio de nginx, ya que Certbot se coloca en el puerto 80 para
escuchar al servicio de nuestra página.

Se nos aparecerá un menú interactivo en el cual tendremos que ir introduciendo información:

```
debian@pandora:~$ sudo certbot certonly
Saving debug log to /var/log/letsencrypt/letsencrypt.log

How would you like to authenticate with the ACME CA?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: Spin up a temporary webserver (standalone)
2: Place files in webroot directory (webroot)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 1
Plugins selected: Authenticator standalone, Installer None
Please enter in your domain name(s) (comma and/or space separated)  (Enter 'c'
to cancel): www.iesgn10.es
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for www.iesgn10.es
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/www.iesgn10.es/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/www.iesgn10.es/privkey.pem
   Your cert will expire on 2021-02-23. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

Hecho esto, podremos volver a activar el servicio de nginx y visualizar la información del certificado:

```
debian@pandora:~$ sudo certbot certificates
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Found the following certs:
  Certificate Name: www.iesgn10.es
    Domains: www.iesgn10.es
    Expiry Date: 2021-02-23 12:16:06+00:00 (VALID: 89 days)
    Certificate Path: /etc/letsencrypt/live/www.iesgn10.es/fullchain.pem
    Private Key Path: /etc/letsencrypt/live/www.iesgn10.es/privkey.pem
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
debian@pandora:~$
```

3. Utiliza dos ficheros de configuración de nginx: uno para la configuración del virtualhost 
HTTP y otro para la configuración del virtualhost HTTPS.

4. Realiza una redirección o una reescritura para que cuando accedas a HTTP te redirija al 
sitio HTTPS.

5. Comprueba que se ha creado una tarea cron que renueva el certificado cada 3 meses.

6. Comprueba que las páginas son accesible por HTTPS y visualiza los detalles del certificado 
que has creado.

7. Modifica la configuración del cliente de Nextcloud para comprobar que sigue en funcionamiento 
con HTTPS.
