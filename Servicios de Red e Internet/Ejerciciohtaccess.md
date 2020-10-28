# Ejercicio 6: Configuración de apache mediante archivo .htaccess

Un fichero .htaccess (hypertext access), también conocido como archivo de 
configuración distribuida, es un fichero especial, popularizado por el 
Servidor HTTP Apache que nos permite definir diferentes directivas de 
configuración para cada directorio (con sus respectivos subdirectorios) 
sin necesidad de editar el archivo de configuración principal de Apache.

Para permitir el uso de los ficheros .htaccess o restringir las directivas 
que se pueden aplicar usamos ela directiva AllowOverride, que puede ir 
acompañada de una o varias opciones: All, AuthConfig, FileInfo, Indexes, Limit. 
Estudia para que sirve cada una de las opciones.

**Ejercicios**

Date de alta en un proveedor de hosting. ¿Si necesitamos configurar el 
servidor web que han configurado los administradores del proveedor?, 
¿qué podemos hacer? Explica la directiva AllowOverride de apache2. Utilizando 
archivos .htaccess realiza las siguientes configuraciones:


* Habilita el listado de ficheros en la URL _http://host.dominio/nas_.
    
* Crea una redirección permanente: cuando entremos en 
_http://host.dominio/google_ salte a _www.google.es_.

* Pedir autentificación para entrar en la URL _http://host.dominio/prohibido_. 
(No la hagas si has elegido como proveedor CDMON, en la plataforma de prueba, 
no funciona.)

