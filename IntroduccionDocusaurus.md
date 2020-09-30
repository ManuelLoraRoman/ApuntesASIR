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
```npm run build```  

