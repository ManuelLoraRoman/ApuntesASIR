# Git y GitHub
------------------------------

## 1. Introducción

En primer lugar, deberás tener una cuenta de Github. Como habitualmente se suele
acceder al mismo mediante SSH, haremos lo siguiente:


1. Copia el contenido del fichero *~/.ssh/id_rsa.pub* y añadelo en el apartado
de:
 
   _```Settings --> SSH and GPG keys --> SSH keys --> New SSH key```_  

   y añadimos dicho contenido.    

2. Instala git en tu PC:

<div align="center">

```apt-get install git```

</div>

3. Para configurar git con tu nombre de usuario y tu email (importante para
los "commits") debemos hacer lo siguiente:

<div align="center">

```git config --global user.name "Nombre de usuario"```
```git config --global user.email email@ejemplo.com```

Esto solo hay que hacerlo una vez únicamente, ya que especificamos la opción
--global.

</div>

4. Clona el repositorio remoto en tu PC. Asegúrese de encontrarse en el 
directorio que usted desea almacenar dicho repositorio para trabajar de manera
local.

<div align="center">

```git clone git@github.com:ManuelLoraRoman/Prueba.git``` 

</div>

## 2. Comandos básicos de Git

* _git add_ --> permite añadir al repositorio un nuevo fichero.

* _git rm_ --> se usa para borrar ficheros del repositorio. Se usa de la misma
               manera que el "_rm_" de la shell.

* _git commit_ --> permite realizar y mandar un commit al repositorio remoto.
                 Se suele usar los parámetros -am para añadir un fichero
		 (add) y escribir el contenido del commit al mismo tiempo.

* _git mv_ --> cambia el nombre de cierto fichero o mueve un fichero de un
	       directorio a otro.

* _git push_ --> envía los cambios al repositorio remoto.

* _git pull_ --> sincroniza el repositorio local con el remoto (en caso de que
               se trabaje con varios repositorios locales).

* _git status_ --> comprueba el estado del repositorio local.


## 3. Git Avanzado


* _git log_ --> lista las confirmaciones hechas sobre el repositorio en el
		que trabajamos en orden cronológico. Muestra varios datos como
		la suma de comprobación SHA-1, nombre, email, fecha, etc.
		
		Al usar el parámetro -p, muestra las diferencias en cada
		confirmación. Al usar -x(nº), muestras las x últimas entradas.
		
		Si usamos --pretty, modificaremos el formato de salida. El 
		formato _oneline_ imprime cada confirmación en una única línea.
		Otras opciones de formato son _short_, _full_ o _fuller_.
		Puedes crear tu propio formato con _format_. Para más
		información sobre esto, visita esta [página](https://uniwebsidad.com/libros/pro-git/capitulo-2/viendo-el-historico-de-confirmaciones).


* _git commit --amend_ --> si haces la confirmación demasiado pronto, y te has
			   olvidado modificar, crear, etc, puedes volver a hacer
			   la confirmación con este comando. 
 
* _git remote -v_ --> muestra todos los repositorios remotos que tienes
		      configurados.

* _git remote add nombre URL_ --> añade a los repositorios configurados un
				  repositorio en cuestión. Útil si no quieres
				  usar toda la URL, y quieres usar un nombre. 

* _git remote show repositorio_ --> permite ver información del repositorio en
				    cuestión.

* _git remote rename repositorio nombrenuevo_ --> cambia el nombre guardado del
						  repositorio. 

* _git fetch repositorio_ --> recibe datos de un repositorio en cuestión.
