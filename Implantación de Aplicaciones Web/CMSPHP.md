# Práctica: Instalación local de un CMS PHP


## Tarea 1: Instalación de un servidor LAMP

* Crea una instancia de vagrant basado en un box debian o ubuntu.

* Instala en esa máquina virtual toda la pila LAMP.

Entrega una documentación resumida donde expliques los pasos fundamentales para
realizar esta tarea.

Dicha documentación la podemos encontrar en el siguiente [enlace](./LAMP.md)


## Tarea 2: Instalación de drupal en mi servidor local


* Configura el servidor web con virtual hosting para que el CMS sea accesible 
desde la dirección: www.nombrealumno-drupal.org.

Seguiremos las mismas intrucciones que en el ejercicio de [VirtualHosting](https://github.com/ManuelLoraRoman/ApuntesASIR/blob/master/Servicios%20de%20Red%20e%20Internet/VirtualHosting.md),
salvo que modificaremos el ServerName por _www.manuelloraroman-drupal.org_.

![alt text](../Imágenes/Servername1.png)

* Crea un usuario en la base de datos para trabajar con la base de datos 
donde se van a guardar los datos del CMS.

Esta información la hemos incorporado en el enlace de LAMP.

* Descarga la versión que te parezca más oportuna de Drupal y realiza la 
instalación.

Como drupal no se puede descargar mediante paquete debemos hacer la siguiente
descarga e instalación:

```
sudo wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz
sudo tar xvf drupal.tar.gz
sudo mv drupal-9.0.7 /var/www/nombrealumno-drupal
sudo chown -R www-data:www-data /var/www/nombrealumno-drupal
```

![alt text](../Imágenes/drupalinstall.png)

Una vez accedemos a la página, nos aparecerá lo siguiente:

![alt text](../Imágenes/drupal1.png)

Y procederemos a la instalación:

![alt text](../Imágenes/drupal2.png)

Nos pedirá qué tipo de BBDD queremos utilizar, alguna que tengamos creada y un
usuario de dicha base de datos.

![alt text](../Imágenes/drupal3.png)

Nos pedirá ahora rellenar diferentes campos con información:

![alt text](../Imágenes/drupal4.png)

Y así, ya tendriamos instalado Drupal.

![alt text](../Imágenes/drupalfinal.png)

* Realiza una configuración mínima de la aplicación (Cambia la plantilla, 
crea algún contenido,…)

Para quitar el !!!Warning que tenemos sobre las URLs limpias, debemos hacer:

```
sudo a2enmod rewrite
```

Y modificamos el fichero _.conf_ de nuestro VirtualHosting con las siguientes
lineas:

```
<Directory /var/www/html>
	AllowOverride All
</Directory>
```

Y ya podriamos modificar nuestro sitio web con drupal.

Primero, crearemos un articulo:

![alt text](../Imágenes/articulodrupal.png)

Ahora instalaremos un nuevo tema:

![alt text](../Imágenes/temanuevodrupal.png)

![alt text](../Imágenes/temanuevodrupal2.png)

En la Pestaña _Apariencia --> Temas Desinstalados --> Adminimal ..._ le damos a
instalar y después le damos a _Configurar como predeterminado_.

* Instala un módulo para añadir alguna funcionalidad a drupal.

Ahora instalaremos algún módulo:

![alt text](../Imágenes/modulonuevodrupal.png)

![alt text](../Imágenes/modulonuevodrupal2.png)

Y nos iriamos a la Pestaña _Ampliar --> Listado --> Otros (en nuestro caso)_ y
lo seleccionamos y le damos a _Instalar_. Y ya tendríamos el módulo activado.

En este momento, muestra al profesor la aplicación funcionando en local. 
Entrega un documentación resumida donde expliques los pasos fundamentales 
para realizar esta tarea.

