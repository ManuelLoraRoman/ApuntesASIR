# Despliegue de aplicaciones python

## Tarea 1: Entorno de desarrollo

En primer lugar, debemos de asegurarnos que tenemos instalados tanto pyhton3
como Django. 

Para instalar Django, crearemos un entorno virtual de la siguiente manera:

```
debian@drupal:~$ virtualenv django -p python3
Already using interpreter /usr/bin/python3
Using base prefix '/usr'
New python executable in /home/debian/django/bin/python3
Also creating executable in /home/debian/django/bin/python
Installing setuptools, pkg_resources, pip, wheel...done.
debian@drupal:~$ ls
django
```

Para instalar Django haremos esto otro:

```
debian@drupal:~$ source ~/django/bin/activate
(django) debian@drupal:~$ python -m pip install Django
Collecting Django
  Downloading Django-3.1.3-py3-none-any.whl (7.8 MB)
     |████████████████████████████████| 7.8 MB 5.1 MB/s 
Collecting sqlparse>=0.2.2
  Downloading sqlparse-0.4.1-py3-none-any.whl (42 kB)
     |████████████████████████████████| 42 kB 300 kB/s 
Collecting pytz
  Downloading pytz-2020.4-py2.py3-none-any.whl (509 kB)
     |████████████████████████████████| 509 kB 5.5 MB/s 
Collecting asgiref<4,>=3.2.10
  Downloading asgiref-3.3.1-py3-none-any.whl (19 kB)
Installing collected packages: sqlparse, pytz, asgiref, Django
Successfully installed Django-3.1.3 asgiref-3.3.1 pytz-2020.4 sqlparse-0.4.1
(django) debian@drupal:~$ 
```

Vamos a desarrollar la aplicación del tutorial de django 3.1. Vamos a configurar
tu equipo como entorno de desarrollo para trabajar con la aplicación, para ello:

* Realiza un fork del repositorio de GitHub: _https://github.com/josedom24/django_tutorial_.

Una vez ya estamos en el entorno virtual, hariamos un fork del repositorio
de GitHub, y lo clonaremos en nuestra máquina.

```
(django) debian@drupal:~/django_tutorial-master$ ls
django_tutorial  manage.py  polls  README.md  requirements.txt
```

* Crea un entorno virtual de python3 e instala las dependencias necesarias para 
que funcione el proyecto (fichero requirements.txt).

El entorno virtual ya lo hemos creado con anterioridad, así que lo siguiente que
tenemos que hacer es la instalación de las dependencias:

```
(django) debian@drupal:~/django_tutorial-master$ pip install -r requirements.txt 
Requirement already satisfied: pytz==2020.4 in /home/debian/django/lib/python3.7/site-packages (from -r requirements.txt (line 3)) (2020.4)
Requirement already satisfied: sqlparse==0.4.1 in /home/debian/django/lib/python3.7/site-packages (from -r requirements.txt (line 4)) (0.4.1)
Collecting asgiref==3.3.0
  Downloading asgiref-3.3.0-py3-none-any.whl (19 kB)
Collecting Django==3.1.3
  Downloading Django-3.1.3-py3-none-any.whl (7.8 MB)
     |████████████████████████████████| 7.8 MB 5.6 kB/s 
Requirement already satisfied: sqlparse==0.4.1 in /home/debian/django/lib/python3.7/site-packages (from -r requirements.txt (line 4)) (0.4.1)
Requirement already satisfied: pytz==2020.4 in /home/debian/django/lib/python3.7/site-packages (from -r requirements.txt (line 3)) (2020.4)
Installing collected packages: asgiref, Django
  Attempting uninstall: asgiref
    Found existing installation: asgiref 3.3.1
    Uninstalling asgiref-3.3.1:
      Successfully uninstalled asgiref-3.3.1
  Attempting uninstall: Django
    Found existing installation: Django 3.1.4
    Uninstalling Django-3.1.4:
      Successfully uninstalled Django-3.1.4
Successfully installed Django-3.1.3 asgiref-3.3.0
```

* Comprueba que vamos a trabajar con una base de datos sqlite 
(django_tutorial/settings.py). ¿Cómo se llama la base de datos que vamos a 
crear?

Efectivamente, vamos a usar sqlite, y el nombre de la base de datos se llamará:
"db.sqlite3"

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```

* Crea la base de datos: python3 manage.py migrate. A partir del modelo de datos
se crean las tablas de la base de datos.

```
(django) debian@drupal:~/django_tutorial-master$ python3 manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, polls, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying polls.0001_initial... OK
  Applying sessions.0001_initial... OK
```

* Crea un usuario administrador: python3 manage.py createsuperuser.

```
(django) debian@drupal:~/django_tutorial-master$ python3 manage.py createsuperuser
Username (leave blank to use 'debian'): 
Email address: manuelloraroman@gmail.com
Password: 
Password (again): 
This password is too common.
Bypass password validation and create user anyway? [y/N]: y
Superuser created successfully.
```

* Ejecuta el servidor web de desarrollo y entra en la zona de administración 
(\admin) para comprobar que los datos se han añadido correctamente.

![alt text](../Imágenes/adminpython.png)

* Crea dos preguntas, con posibles respuestas.

![alt text](../Imágenes/polls.png)
