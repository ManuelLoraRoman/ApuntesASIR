# Ejercicio: Desplegando aplicaciones flask

## Despliegue en el entorno de desarrollo

Vamos a trabajar con la aplicación flask_temperaturas que puedes encontrar 
en el siguiente enlace: _https://github.com/josedom24/flask_temperaturas_.

Clona el repositorio en tu equipo, mira las versiones de los paquetes necesarios
para que la aplicación funcione en el fichero requirements.txt y responde las 
siguientes preguntas:

* ¿Podríamos instalar estos paquetes con apt?

Si se podría usando por ejemplo el siguiente comando:

```sudo apt-get -y install $(cat requirements.apt)```

Pero no es recomendable ya que dichos paquetes se instalarían según la versión
más reciente, pero no la versión del _pip freeze_.

* ¿Sería buena idea instalar como root estos paquetes en el sistema con pip?

No, ya que todo se hace desde el usuario

* ¿Cómo sería la mejor manera de instalar estos paquetes?

```pip install -r requirements.txt```

## Trabajamos con entornos virtualesPermalink

Crea un entorno virtual con el módulo venv e instala en él los paquetes 
necesarios para que el programa funcione. Una vez instalado, ejecuta la 
aplicación con el servidor de desarrollo y comprueba que funciona.

Realizado.

Pasos a seguir:

```
sudo apt-get install python-virtualenv
virtualenv -p /usr/bin/python3 flask
source flask/bin/activate
----Clonamos repositorio----
pip install -r requirements.txt
python3 app.py
```

## Despliegue en el entorno de producción

El protocolo WSGI define las reglas para que el servidor web se comunique con 
la aplicación web. Cuando al servidor le llega una petición que tenemos que
mandar a la aplicación web python tenemos al menos dos cosas que tener en 
cuenta:

* Tenemos un fichero de entrada, es decir la petición siempre se debe enviar 
un único fichero., Este fichero se llama fichero WSGI.

* La aplicación web python con la que se comunica el servidor web utilizando 
el protocolo WSGI se debe llama application. Por lo tanto el fichero WSGI 
entre otras cosas debe nombrar a la aplicación de esta manera

### Configuración de apache2 para servir una aplicación web flask

```
apt-get install apache2
apt-get install libapache2-mod-wsgi-py3
a2enmod wsgi
```

### Creación del fichero wsgi

En _/var/www/html/_ tenemos que clonar el repositorio en este caso, pero en 
general, es donde debería estar nuestra aplicación. En el directorio de 
nuestra aplicación crearemos el fichero _app.wsgi_:

```
from app import app as application
```

* El primer app corresponde con el nombre del módulo, es decir del fichero 
del programa, en nuestro caso se llama app.py.

* El segundo app corresponde a la aplicación flask creada en 
_app.py: app = Flask(__name__)_.
   
* Importamos la aplicación flask, pero la llamamos application necesario para 
que el servidor web pueda enviarle peticiones.

### Configuración de apache2

```
ServerName www.example.org
DocumentRoot /var/www/html/flask_temperaturas
WSGIDaemonProcess flask_temp user=www-data group=www-data processes=1 threads=5 python-path=/var/www/html/flask_temperaturas:/home/debian/venv/flask/lib/python3.7/site-packages
WSGIScriptAlias / /var/www/html/flask_temperaturas/app.wsgi

<Directory /var/www/html/flask_temperaturas>
        WSGIProcessGroup flask_temp
        WSGIApplicationGroup %{GLOBAL}
        Require all granted
</Directory>
```

Si nos encontramos con algún error en el despligue, es recomendable observar
que errores tenemos viendo el log en _/var/log/apache2/error.log_.
