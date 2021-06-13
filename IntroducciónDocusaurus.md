---
layout: post
title: Introducción a Docusaurus y Surge
date: 2021-03-11 22:31 +0800
last_modified_at: 2021-03-11 22:32:25 +0800
tags: [Docusaurus, Surge, Pagina Web, Estatica, Tutorial]
toc:  true
---
Docusaurus es una herramienta para crear y mantener páginas estáticas. Surge nos permite desplegar dichas
páginas.
{: .message }


Para empezar a trabajar con Docusaurus, son necesarios los siguientes paquetes:

* **Node.js** version >= 10.15.1

* **npm** 

Una vez hecho esto, debemos crear un directorio donde queramos. Una vez ya
creado, nos iremos a dicha carpeta y ejecutaremos el siguiente comando:

{% highlight js linenos %}

npx @docusaurus/init@next init [nombre de la página] [template]

{% endhighlight %}

El _template_ que utilizaremos será el **classic** ya que incluye blog, 
documentación, páginas, etc.

Por lo tanto el comando quedaría así:

{% highlight js linenos %}

npx @docusaurus/init@nex init mi-pagina classic

{% endhighlight %}

Para ejecutar la página localmente, usaremos esta intrucción:

{% highlight js linenos %}

cd mi-pagina  
npm run start

{% endhighlight %}

Para poder desplegar nuestra página generada, debemos construir la página en un
directorio de contenidos estáticos y ponerlo en el servidor web. Para ello,
ejecutaremos el siguiente comando:

{% highlight js linenos %}

npm run build

{% endhighlight %}

# Introducción a Surge

Surge es una herramienta que sirve para desplegar nuestro sitio web.

Nos iremos al directorio creado anteriormente, y ejecutamos:

> surge

Y nos desplegará la página estática en un dominio generado aleatoriamente.

## Consejos y características de ambas herramientas:

* Los documentos MarkDown se encuentran en mi-pagina/docs

* La página de inicio se encuentra en mi-pagina/src/pages

* En docusaurus.config.js se incorporan varios pluggins además de los elementos
de la página de Inicio.

* En static se encuentran las imágenes

* Surge, cada vez que desplegamos la página, se nos despliega en un dominio 
diferente, por eso es recomendable, hacer un:

{% highlight js linenos %}

echo [primer dominio que nos haya salido] > CNAME

{% endhighlight %}

Y después al desplegarlo cogerá dicho CNAME.

* En el fichero index.js, se modifica el contenido de la página inicial.

* En el fichero sidebars.js se encuentra la barra lateral.


