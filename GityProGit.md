# Git y GitHub
------------------------------

## 1. Introducción

En primer lugar, deberás tener una cuenta de Github. Como habitualmente se suele
acceder al mismo mediante SSH, haremos lo siguiente:

<div align="center">

1. Copia el contenido del fichero *~/.ssh/id_rsa.pub* y añadelo en el
   apartado de ```_Settings --> SSH and GPG keys --> SSH keys --> New SSH key_```
   y añadimos dicho contenido.

2. Instala git en tu PC:

```apt-get install git```

3. Para configurar git con tu nombre de usuario y tu email (importante para
los "commits") debemos hacer lo siguiente:

```git config --global user.name "Nombre de usuario"```
```git config --global user.email email@ejemplo.com```

Esto solo hay que hacerlo una vez únicamente, ya que especificamos la opción
--global.

4. Clona el repositorio remoto en tu PC. Asegúrese de encontrarse en el 
directorio que usted desea almacenar dicho repositorio para trabajar de manera
local.

```git clone git@github.com:ManuelLoraRoman/Prueba.git``` 

</div>

## 2. Comandos básicos de Git

* git add --> permite añadir al repositorio un nuevo fichero.

* git commit --> permite realizar y mandar un commit al repositorio remoto.
                 Se suele usar los parámetros -am para añadir un fichero
		 (add) y escribir el contenido del commit al mismo tiempo.

* git mv --> cambia el nombre de cierto fichero.

* git push --> envía los cambios al repositorio remoto.

* git pull --> sincroniza el repositorio local con el remoto (en caso de que
               se trabaje con varios repositorios locales).

* git status --> comprueba el estado del repositorio local.
