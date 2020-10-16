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

```a2ensite apache1```

