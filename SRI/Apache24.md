# Introducción a Apache2.4

Gestión del servicio:

```apache2ctl [-k start | restart | graceful | graceful-stop | stop]```

El fichero de configuración de Apache2 en Debian está dividida en varias partes,
es decir, es descentralizada. Por lo tanto, el fichero principal de 
configuración está repleto de _Include..._.

En _/etc/apache2/apache2.conf_, las siguientes lineas detallan que las 
opciones desarrolladas ahí, afectan al directorio incluido y a todos sus
subdirectorios:

```
<Directory /var/wwww/>
	Options Indexes FollowSymLinks
	AllowOverride None
	Require all granted
<Directory>
```

Por eso es recomendable crear todas nuestras páginas web en el directorio
_/var/www/_. Si queremos cambiar dicho directorio, añadimos la ruta y 
comentamos las lineas anteriores.

Las variables de entorno se encuentran en _/etc/apache2/envvars_.

Para cambiar la configuración del virtualhost por defecto, encontraremos los 
siguientes ficheros:

* _/etc/apache2/sites-available/000-default.conf_

* _/etc/apache2/sites-enabled/000-default.conf_

Entre ellos dos hay enlaces simbólicos.

Para activar la configuración de una página en concreto, debemos ejecutar:

```a2ensite [Nombre]```

```a2ensite apache2```

## Control de acceso Apache2

* VirtualHosting por IP --> en el _Directory_ / _conf_ se incorpora la IP del 
Servidor donde el puerto ( IP : Puerto) para acceder al Servidor por ese 
puerto.

* El parámetro _Require_ permite el acceso. Tiene varias opciones:

1. _All granted_

2. _All denied_

------ AUTENTIFICACIÓN
|
|3. _user ...._
|
|4. _group ...._ ====> crear el fichero de grupos:
|			NombreGrupo: usuario1 usuario2 ...
|
|5. _valid-user_ ====> crear el fichero de usuarios:
|                    ```htpasswd [-c] /etc/apache2/claves/passwd.txt dominio usuario1```
------

6. _Ip_

7. _Dominio_


## Autentificación Digest

```htdigest [-c] /etc/apache2/claves/digest.txt```

## .htaccess

La opción _AllowOverride_ permite el uso de ficheros _.htaccess_.

El _.htaccess_ funcionará dentro de su directorio y sus subdirectorios.
