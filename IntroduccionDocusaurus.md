# Introducción a Docusaurus

Para empezar a trabajar con Docusaurus, son necesarios los siguientes paquetes:

* **Node.js** version >= 10.15.1

* **npm** 

Una vez hecho esto, debemos crear un directorio donde queramos. Una vez ya
creado, nos iremos a dicha carpeta y ejecutaremos el siguiente comando:

```npx @docusaurus/init@next init [nombre de la página] [template]```

El _template_ que utilizaremos será el **classic** ya que incluye blog, 
documentación, páginas, etc.

Por lo tanto el comando quedaría así:

```npx @docusaurus/init@nex init mi-pagina classic```

Para ejecutar la página localmente, usaremos esta intrucción:

```cd mi-pagina```  
```npm run start```

Para poder desplegar nuestra página generada, debemos construir la página en un
directorio de contenidos estáticos y ponerlo en el servidor web. Para ello,
ejecutaremos el siguiente comando:

```
npm run build
```

# Introducción a Surge

Surge es una herramienta que sirve para desplegar nuestro sitio web.

Nos iremos al directorio creado anteriormente, y ejecutamos:

```surge```

Y nos desplegará la página estática en un dominio generado aleatoriamente.

## Consejos y características de ambas herramientas:

* Los documentos MarkDown se encuentran en mi-pagina/docs

* La página de inicio se encuentra en mi-pagina/src/pages

* En docusaurus.config.js se incorporan varios pluggins además de los elementos
de la página de Inicio.

* En static se encuentran las imágenes

* Surge, cada vez que desplegamos la página, se nos despliega en un dominio 
diferente, por eso es recomendable, hacer un:

```echo [primer dominio que nos haya salido] > CNAME```

Y después al desplegarlo cogerá dicho CNAME.

* En el fichero index.js, se modifica el contenido de la página inicial.

* En el fichero sidebars.js se encuentra la barra lateral.


