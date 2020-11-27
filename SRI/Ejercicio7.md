# Ejercicio 7: Módulos en apache

a2enmod userdir
creamos directorio con index en el home del usuario
y para entrar ponemos nuestra ip/~nombre
En el userdir.conf estaria configurado todas las opciones


a2enmod dav dav_fs
copiar configuracion ejercicio
dav//ip en otras ubicaciones y podemos mover los ficheros

a2enmod rewrite --> reescribe url a una url que queramos.
permite crear urls limpias y redireccionar de http a https
se puede configurar en el virtualhost o en el .htaccess
Options FollowSymLinks
RewriteEngine On
RewriteRule expresion regular lo que tiene que sobreescribir
RewriteBase / --> define la raiz
[nc] no tener en cuenta las mayusc y minusc
[L] es como un break;
Para hacer URL limpia, se necesita un tocho de expresion regular
RewriteCond

