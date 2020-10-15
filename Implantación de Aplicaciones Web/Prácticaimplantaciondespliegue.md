# Práctica: Implantación y despliegue de una aplicación web estática

**Tarea 1.** Selecciona una combinación entre generador de páginas estáticas y
servicio donde desplegar la página web. Escribe tu propuesta en redmine, cada
propuesta debe ser original.

**Tarea 2.** Comenta la instalación del generador de página estática. 
Recuerda que el generador tienes que instalarlo en tu entorno de desarrollo. 
Indica el lenguaje en el que está desarrollado y el sistema de plantillas 
que utiliza.

**Tarea 3.** Configura el generador para cambiar el nombre de tu página, 
el tema o estilo de la página,… Indica cualquier otro cambio de 
configuración que hayas realizado.

**Tarea 4.** Genera un sitio web estático con al menos 3 páginas. 
Deben estar escritas en Markdown y deben tener los siguientes elementos HTML: 
títulos, listas, párrafos, enlaces e imágenes. El código que estas 
desarrollando, configuración del generado, páginas en markdown,… 
debe estar en un repositorio Git (no es necesario que el código generado 
se guarde en el repositorio, evitalo usando el fichero .gitignore).

**Tarea 5.** Explica el proceso de despliegue utilizado por el 
servicio de hosting que vas a utilizar.

**Tarea 6.** Piensa algún método (script, scp, rsync, git,…) que te permita 
automatizar la generación de la página (integración continua) y 
el despliegue automático de la página en el entorno de producción, 
después de realizar un cambio de la página en el entorno de desarrollo. 
Muestra al profesor un ejemplo de como al modificar la página 
se realiza la puesta en producción de forma automática.



## Tarea 1 y Tarea 2

Para el generador de nuestra páginas estáticas, usaremos Docusaurus. 
La documentación de dicho generador la podemos encontrar [aquí](https://v2.docusaurus.io/).

Dicho generador utiliza javascript y MarkDown/REACT.

Y para el servicio donde desplegar nuestra página, [Surge](https://surge.sh/).


## Tarea 3

Para cambiar el nombre de nuestra página de Inicio, modificaremos el fichero 
_src/pages/index.js_, en _function Home()_,en la sección _title_.

![alt text](../Imágenes/nombrepagina.png)

Para cambiar el contenido de la página de inicio, modificamos este mismo 
archivo.

Por otra parte, si queremos cambiar el _header_, _footer_ o el propio icono,
debemos ir a _docusaurus.config.js_:

![alt text](../Imágenes/configjs1.png)


Los temas están centrados en el lado del cliente, mientras que los plugins, lo 
están en el lado del servidor. Para usar temas, debemos especificarlos en el
fichero _docusaurus.config.js_.

```
module.exports = {
  // ...
  themes: ['@docusaurus/theme-classic'],
};
```

Por lo general, todo lo modificado sería lo siguiente:


* Los documentos MarkDown se encuentran en mi-pagina/docs

* La página de inicio se encuentra en mi-pagina/src/pages

* En docusaurus.config.js se incorporan varios pluggins además de los elementos de la página de Inicio.

* En static se encuentran las imágenes

* En el fichero index.js, se modifica el contenido de la página inicial.

* En el fichero sidebars.js se encuentra la barra lateral.


## Tarea 4

La página generada está en el siguiente repositorio de [Github](https://github.com/ManuelLoraRoman/Docusaurus/tree/main/ManuelLoraRoman)


## Tarea 5

Con el comando:

```npm run build```

Creamos una carpeta llamada _build_ que nos permite guardar en un directorio de
contenidos estáticos, el cual podremos usar para desplegarla con Surge.

Una vez tenemos el directorio creado, ejecutaremos la instrucción _surge_ dentro
de la misma:

![alt text](../Imágenes/surgepagina.png)

Para ello, antes es necesario la creación de un usuario.

Le pondremos en el dominio lo que queramos, siempre y cuando acabe en 
_.surge.sh_ y ya lo tendriamos desplegado. Cada vez que queramos desplegar
la página, nos pedirá un dominio. Si queremos siempre usar el mismo, haremos
lo siguiente dentro del directorio _build_:

```echo [Nombre de la página].surge.sh > CNAME```

Y automáticamente, cuando despleguemos la página, se nos pondrá dicho dominio.

Mi página Web (ManuelLoraRoman.surge.sh)

## Tarea 6



