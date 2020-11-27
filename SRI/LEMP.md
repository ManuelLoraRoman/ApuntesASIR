# Instalación de un servidor LEMP

1. Instala un servidor web nginx.

Ejecutaremos ```sudo apt-get install nginx``` para instalar el servidor web nginx.

2. Instala un servidor de base de datos MariaDB. Ejecuta el programa necesario 
para asegurar el servicio, ya que lo vamos a tener corriendo en el entorno de 
producción.

Ejecutaremos ```sudo apt-get install mariadb-server``` y después haremos lo
siguiente:

```
debian@pandora:~$ sudo mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] Y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] Y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] Y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] Y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] Y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
debian@pandora:~$ 
```

3. Instala un servidor de aplicaciones php php-fpm.

Simplemente tenemos que ejecutar el siguiente comando:

```sudo apt-get install php php-fpm```

4. Crea un virtualhost al que vamos acceder con el nombre www.iesgnXX.es. 
Recuerda que tendrás que crear un registro CNAME en la zona DNS.


Iremos al directorio _/etc/nginx/sites-available_ y haremos una copia del 
fichero default:

```sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/iesgn10```

Ahora haremos un enlace simbólico de dicho fichero de configuración:

```ln -s /etc/nginx/sites-available/iesgn10 /etc/nginx/sites-enabled/```

Y modificaremos el fichero de configuración:

```
server {
        listen 80 default_server;
        listen [::]:80 default_server;
root /var/www/html/iesgn10;

index index.html index.htm index.nginx-debian.html;

server_name www.iesgn10.es;

location / {
       try_files $uri $uri/ =404;
}
}
```

Modificaremos el fichero _/etc/hosts_ de nuestra máquina para comprobar que la
instalación es correcta.

![alt text](../Imágenes/ovhnginx.png)

Para crear un registro CNAME en la zona DNS, nos iremos al ```Panel de Control --> Zona DNS```
y lo añadiremos:

![alt text](../Imágenes/cnameovh.png)

5. Cuando se acceda al virtualhost por defecto default nos tiene que redirigir 
al virtualhost que hemos creado en el punto anterior.

Modificaremos el fichero de configuración _default_ y cambiaremos las siguientes
lineas:

```
server {
        listen 80 default_server;
	root /var/www/html/default;

        index index.html index.htm index.nginx-debian.html;

        server_name _;

        return 301 $scheme://www.iesgn10.es$request_uri;

        location / {
                try_files $uri $uri/ =404;
        }
}
```

Crearemos los directorios pertinentes en _/var/www/html_ y haremos una prueba
de funcionamiento:

https://youtu.be/4YcJIGOTsPk

6. Cuando se acceda a www.iesgnXX.es se nos redigirá a la página 
www.iesgnXX.es/principal.

Modificaremos el fichero de configuración de iesgn10 con las siguientes lineas:

```
location / {
        return 301 /principal/index.html;
        try_files $uri $uri/ =404;
        location /principal {
                autoindex off;
        }
}
```

Y aqui estaría la comprobación de dicha redirección:

https://youtu.be/w3PNeOi10LU

7. En la página www.iesgnXX.es/principal se debe mostrar una página web 
estática (utiliza alguna plantilla para que tenga hoja de estilo). En esta 
página debe aparecer tu nombre, y una lista de enlaces a las aplicaciones que 
vamos a ir desplegando posteriormente.

Nos descargaremos del siguiente enlace esta hoja de estilo, la cual
introduciremos en nuestro directorio _/principal_:

http://solucija.com/templates/distinctive.zip

Modificaremos su contenido y nos quedará algo así:

```
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="Robots" content="index,follow" />
        <meta name="author" content="Luka Cvrk (www.solucija.com)" />
        <meta name="description" content="Description" />
        <meta name="keywords" content="key, words" />
        <link rel="stylesheet" type="text/css" href="css/screen.css" media="screen" />
        <title>Distinctive - web development company</title>
</head>
<body>
        <div id="content">
                <p id="top">Página web estática del Servidor OVH</p>
                <div id="logo">
                        <h1><a href="index.html">OVH</a></h1>
                </div>
                <ul id="menu">
                        <li class="current"><a href="#">Inicio</a></li>
                        <li><a href="#">Nuevo</a></li>
                        <li><a href="#">Documentos</a></li>
                        <li><a href="#">Servicios</a></li>
                        <li><a href="#">Sobre mi</a></li>
                        <li><a href="#">Contacto</a></li>
                </ul>
                <div class="line"></div>
                <div id="pitch">
                        <h1>Manuel Lora Román<br />Estudiante de ASIR</h1>
                        <h2>En esta página web estática añadiremos enlaces <br /> hacia nuestras aplicaciones.</h2>
                </div>
        </div>
</body>
</html>
```

Y accedemos a nuestra página web estática:

![alt text](../Imágenes/estaticaovh.png)

8. Configura el nuevo virtualhost, para que pueda ejecutar PHP. Determina que 
configuración tiene por defecto php-fpm (socket unix o socket TCP) para 
configurar nginx de forma adecuada.

Como Nginx no tiene un procesamiento PHP nativo, hemos instalado anteriormente
el paquete _php-fpm_.

Modificaremos el fichero de configuración de iesgn10 con las siguientes lineas:

```
location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
}
```

Este nuevo bloque de ubicación administra el procesamiento de PHP orientando
Nginx al archivo de configuración _fastcgi-php.conf_ y al archivo
_php7.2-fpm.sock_, que declara el socket que se asocia con php-fpm.

9. Crea un fichero info.php que demuestre que está funcionando el servidor LEMP.

A continuación, crearemos un fichero llamado _info.php_:

```
sudo nano PHP/info.php
```

Y le introduciremos el siguiente contenido:

```
<?php
phpinfo();
```

Y ahora comprobaremos el funcionamiento de la pila LEMP:

![alt text](../Imágenes/phpovh.png)
