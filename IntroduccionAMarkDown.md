# Introducción a MarkDown

## 1. Encabezado

Con el símbolo # , puedes poner diferentes tipos de encabezados. Mientras más #,
más irá disminuyendo el tamaño del encabezado. Aquí algunos ejemplos:

# H1
## H2
### H3
#### H4
##### H5

## 2. Énfasis

Para añadir el estilo cursiva a tu texto, puedes colocar tanto asteriscos (*) o
guión bajo (_) al principio y al final del texto.

Ejemplo: *Asteriscos* _Guión Bajo_

Si por otra parte queremos el estilo negrita, colocaremos dos asteriscos o 
guiones bajos en vez de uno.

Ejemplo: **Asteriscos** __Guiones Bajos__

Se pueden combinar ambos estilos añadiendo al texto 3 de dichos símbolos.

Ejemplo: ***Asteriscos*** ___Guiones Bajos___

En caso de que queramos tachar alguna porción de un texto, usaremos
virgulilla (~) al principio y al final del mismo.

Ejemplo: ~Virgulilla~  

## 3. Listas

Hay dos tipos de listas, las que siguen un orden y las que no. En primer lugar,
las que siguen un orden: usaremos los números según el orden que queramos
establecer y después un punto (.). Acto seguido escribiremos lo que queramos:

1. Primer ejemplo
2. Segundo ejemplo
3. Tercer ejemplo

Si queremos hacer una sublista, usaremos los *leading spaces* (  ) antes de escribir
el número:

1. Primer ejemplo
   2. Primer primer ejemplo  
3. Segundo ejemplo

Note que puedes poner tantos *leading spaces* como quieras para ir añadiendo 
espacios en blanco para, por ejemplo, añadir párrafos entre las listas.
No olvidar añadir dos *leading spaces* al final de cada línea.

  Aquí un primer párrafo  
  de ejemplo  
  para ver el funcionamiento.  

Si por el contrario, queremos hacer listas sin orden, podemos usar tanto
asteriscos (*), como menos (-) o más (+).

* Asterisco

- Menos

+ Más

## 4. Links

Hay dos formas de incorporar un link. La primera y más obvia es añadir 
directamente la URL o la URL con el soporte (<>).

https://es.wikipedia.org/wiki/Felis_silvestris_catus

Con soporte:

<https://es.wikipedia.org/wiki/Felis_silvestris_catus>

La otra manera es añadir corchetes ([]) al texto que queramos añadirle un link
y después entre paréntesis copiar tanto una URL, una búsqueda con referencia,
un link hacia un archivo de un repositorio. Por ejemplo:

[Este texto nos lleva a una página web](https://es.wikipedia.org/wiki/Felis_silvestris_catus)

[Y este otro hacia el archivo README.md de nuestro repositorio](./README.md)

## 5. Imágenes

Para añadir una imagen a nuestro texto, podemos usar
"![alt text](ubicación de la imagen)"

Ejemplo:

<div align="center"> ![alt text](https://github.com/ManuelLoraRoman/Prueba/blob/master/Yo.png) </div>  

o hacer referencia a ella con "[texto]: ubicación del archivo" y luego
sustituir (ubicación de la imagen) por [texto]

Ejemplo:

[logo]: https://github.com/ManuelLoraRoman/Prueba/blob/master/Yo.png

<div align="center"> ![alt text][logo] </div>  


## 6. Bloques de programación


Si queremos que cierto código se remarque en nuestro texto, usaremos tanto al
principio como al final las comillas invertidas (`).

Ejemplo: Aquí nuestras `comillas invertidas` puestas en uso.


Pero cuando vayamos a colocar un bloque de programación, usaremos 3 comillas
invertidas o 4 espacios. Su funcionamiento es el siguiente: 


"\`\`\`lenguaje de programación
código\`\`\`"


Ejemplo: 

```python
s = "Phyton syntax highlighting"
print s
```

## 7. Tablas

Las tablas no son algo propiamente de MarkDown, pero se pueden hacer igualmente.
Se pueden hacer de la siguiente manera:

   " | Tablas | De | Ejemplo |"  
   " |--------|----|---------|"  
   " |  ABC   | DE |  FGHI   |"  
   " |  abc   | de |  fghi   |"  

| Tablas | De | Ejemplo |
|--------|----|---------|
|  ABC   | DE |  FGHI   |
|  abc   | de |  fghi   |

No hace falta que sea algo perfecto puesto que automáticamente nos añadirá la
tabla correctamente.

   "  Tablas | De | Ejemplo "  
   " ----|----|---"  
   "   ABC   | DE |  FGHI   "  
   "   abc   | de |  fghi   "  

Tablas | De | Ejemplo
----|----|---
ABC   | DE |  FGHI
abc   | de |  fghi

## 8. Anotaciones

Para hacer un bloque de anotaciones, usaremos el símbolo de soporte (>)
Mientras más soportes coloques, más subanotaciones se producirán.

> Soporte
>> 2 soportes
>>> 3 soportes
Se pueden hacer múltiples anotaciones

> Esto van a ser dos líneas de texto
> metidas en el mismo bloque de anotaciones.

## 9. Uso de HTML

Como apunte, se puede usar el propio lenguaje de HTML en MarkDown, y prácticamente
funcionará a la perfección en la mayoría de los casos.

## 10. Regla Horizontal

Si queremos añadir una línea en nuestro texto, usaremos 3 o más de, tanto guiones (-),
asteriscos (*) o guiones bajos (_).


-----------------

Guiones


*****************


Asteriscos

_________________


Guiones Bajos

## 11. Alineamiento

MarkDown automáticamente, alinea a la izquierda. Para, por ejemplo, centrar al centro,
usaremos <div align="center">

Ejemplo:

<div align="left"> Texto alineado a la izquierda </div>

<div align="center"> Texto alineado en el centro </div>

<div align="right"> Texto alineado a la derecha </div>
