# Git y GitHub
------------------------------

## 1. Introducción

En primer lugar, deberás tener una cuenta de Github. Como habitualmente se suele
acceder al mismo mediante SSH, haremos lo siguiente:


1. Copia el contenido del fichero *~/.ssh/id_rsa.pub* y añadelo en el apartado
de:
 
   ```_Settings --> SSH and GPG keys --> SSH keys --> New SSH key_```  

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

* _git commit_ --> permite realizar y mandar un commit al repositorio remoto.
                 Se suele usar los parámetros -am para añadir un fichero
		 (add) y escribir el contenido del commit al mismo tiempo.

* _git mv_ --> cambia el nombre de cierto fichero.

* _git push_ --> envía los cambios al repositorio remoto.

* _git pull_ --> sincroniza el repositorio local con el remoto (en caso de que
               se trabaje con varios repositorios locales).

* _git status_ --> comprueba el estado del repositorio local.
