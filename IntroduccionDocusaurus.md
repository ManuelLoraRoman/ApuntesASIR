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

```npm run build```

## Tips

* Los documentos MarkDown se encuentran en mi-pagina/docs

* La página de inicio se encuentra en mi-pagina/src/pages

* En docusaurus.config.js se incorporan varios pluggins además de los elementos
de la página de Inicio.

* En static se encuentran las imágenes
