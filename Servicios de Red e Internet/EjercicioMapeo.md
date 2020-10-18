# Ejercicio 4: Mapear URL a ubicaciones de un sistema de ficheros

Tarea 1. Crea un nuevo host virtual que es accedido con el nombre www.mapeo.com, 
cuyo DocumentRoot sea /srv/mapeo.

Tarea 2. Alias: Crea un alias en el host virtual del ejercicio anterior, 
que mi permita entrar en la URL http://www.mapeo.com/documentos y visualice 
los ficheros del /home/usuario/Documentos. En la sección Directory... pon 
las mismas directivas que tiene la sección Directory del fichero 
/etc/apache2/apache2.conf.

Tarea 3. Options: Determina para que sirven las siguientes opciones de 
funcionamiento:

* All
* FollowSymLinks
* Indexes
* MultiViews
* SymLinksOwnerMatch
* ExecCGI

Determina como funciona si delante de las opciones pongo el signo + o -.

* Crea un enlace directo dentro de /home/usuario/document y comprueba si es 
posible seguirlo. Cambia las opciones del directorio para que no siga los 
enlaces símbolicos.

* Deshabilita la opción de que se listen los archivos existentes en la carpeta 
cuando no existe un fichero definido en la directiva DirectoryIndex.

* MultiViews: Para saber más sobre el negociado de contenido. Siguiendo el 
ejemplo de esta página realiza un fichero de bienvenida en español e inglés y 
compruba como se visualiza.

Tarea 4. Usando la directiva Redirect realiza una redirección, que permita 
que cuando entre a tu servidor http://www.mapeo.com, salte a 
http://www.mapeo.com/web.

Tarea 5. Con la directiva ErrorDocument se puede crear Respuesta de error 
personalizadas. Todo esto se puede llevar a cabo en el fichero 
/etc/apache2/conf-available/localized-error-pages.conf. Después de leer 
sobre el tema realiza los siguientes ejercicios.

* Cuando no se encuentre una página (error 404) por un mensaje de error.

* Crea un alias llamado error que corresponda a /srv/mapeo/error. Dentro de 
ese directorio crea páginas personalizadas para visualizar cuando se produzca 
un error 404 y cuando se tenga un forbidden (403). Configura el sistema para 
que se redireccione a estas páginas cuando se produce un error.

* Descomenta en el fichero localized-error-pages.conf las líneas adecuadas 
para tener los mensajes de error traducidos a los diferentes idiomas. Para 
que funcione tienes que hacer dos cosas:
      
* Activar el módulo include.
* Si quieres los mensajes en español modifica adecuadamente la directiva LanguagePriority del módulo negotiation.

