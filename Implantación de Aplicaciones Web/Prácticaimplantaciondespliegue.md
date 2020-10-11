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


En el fichero _docusaurus.config.js_, se puede cambiar el estilo de la página.

En este fichero se puede modificar el header, el footer y varios iconos.

Para cambiar el nombre de nuestra página, modificaremos el index.js, en 
_function Home()_
