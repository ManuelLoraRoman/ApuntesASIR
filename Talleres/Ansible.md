# Taller de Ansible

## Presentación

Existe un conflicto con los devops, y es que tradicionalmente, el desarrollo y
el personal de sistemas, tienen objetivos y responsabilidades diferentes,
cuando el objetivo debería ser común.

Para solucionar dicho conflicto, se pueden seguir estas pautas:

* Uso de las mismas herramientas.

* Buenas praxis de desarrollo a sistemas, es decir, de integración continua a
entrega/despliegue continuo.

Es necesario que el servidor tenga recursos elásticos y un escalado horizontal,
para que no nos encontremos con problemas como una denegación de servicio 
debido a un _OUT_OF_MEMORY_. Por esto, se puede realizar automatización en 
la creación y destrucción de nodos.

Las aplicaciones que se adaptan mejor a esta situación, se llaman microservicios
y normalmente se hace a través de contenedores.

¿Qué es lo que programamos?

* Escenarios: MV, redes o almacenamiento.

* COnfiguración de sistemas o aplicaciones.

* Recursos de alto nivel: DNSaaS, DBaaS, LBaaS,....

* Respuestas ante eventos.

### Orquestación

* Vagrant

* Heat (Openstack)

* Cloudformation (AWS)

* Terraform (misma compañía que Vagrant)

* Juju (Canonical (Ubuntu))

### Gestión de la configuración

* Puppet --> escrito en C++ y Clojure. Instala unos agentes en los clientes y la
configuración en el servidor, y cada cierto tiempo, el cliente va preguntando 
si tiene que aplicar cambios (Arquitectura cliente-servidor). La configuración
mediante manifiestos.

* Chef --> escrito en Ruby. Sigue una arquitectura pull (Chef server, chef 
client y workstation), y se basa en que la configuración se realiza mediante 
recetas y libros de recetas. 

* Ansible

* Salt (Saltstack) --> escrito en python. Se usa el esquema de Master y minions.
Descripción de recursos en YAML e incluye monitorización para respuesta a 
eventos.


## Ansible

Cambio de paradigma entre despliegue tradicional y continuo. Por ello, se
usa la infraestructura como código:

* Utiliza software de control de versiones.

* Editor de texto.

* Legible y con comentarios.

* Software de orquestación y gestión de configuración.

* Devops


### Software de gestión de la configuración (CMS)

Su propiedad más característica es que utiliza el ámbito de la idempotencia, es
decir, se puede ejecutar varias veces la receta de un CMS, pero solo el primer 
resultado es diferente a los demás, que siempre tienen que tener el mismo
resultado.

Ejemplo: Quiero que mi máquina tenga un Apache. Cuando se ejecuta, se instala
Apache, pero las demás veces, como el estado es el deseado, no hace nada. 

Ansible está escrito en Python y utiliza la arquitectura push. No utiliza
ningún agente, utiliza ssh. La configuración está en jugadas (plays)
y libros de jugadas (playbooks) en YAML.

Es sencillo de aprender y la sintaxis es conocida ya que utiliza YAML.
Fácil de instalar (pypi), con una comunidad muy activa y a la hora de trabajar,
es más cercano a los administradores de sistemas.

## Demo de Ansible

### Instalación

Creamos un entorno virtual y con pip instalamos ansible.

```
manuel@debian:~/virtualenvs$ virtualenv ansible -p python3
Already using interpreter /usr/bin/python3
Using base prefix '/usr'
New python executable in /home/manuel/virtualenvs/ansible/bin/python3
Also creating executable in /home/manuel/virtualenvs/ansible/bin/python
Installing setuptools, pkg_resources, pip, wheel...done.
manuel@debian:~/virtualenvs$ source ~/virtualenvs/ansible/bin/activate
(ansible) manuel@debian:~/virtualenvs$ python -m pip install ansible
Collecting ansible
  Downloading ansible-2.10.5.tar.gz (29.1 MB)
     |████████████████████████████████| 29.1 MB 1.0 MB/s 
Collecting ansible-base<2.11,>=2.10.4
  Downloading ansible-base-2.10.5.tar.gz (5.7 MB)
     |████████████████████████████████| 5.7 MB 927 kB/s 
Collecting cryptography
  Downloading cryptography-3.3.1-cp36-abi3-manylinux2010_x86_64.whl (2.6 MB)
     |████████████████████████████████| 2.6 MB 2.6 MB/s 
Collecting cffi>=1.12
  Downloading cffi-1.14.4-cp37-cp37m-manylinux1_x86_64.whl (402 kB)
     |████████████████████████████████| 402 kB 5.7 MB/s 
Collecting six>=1.4.1
  Using cached six-1.15.0-py2.py3-none-any.whl (10 kB)
Collecting jinja2
  Using cached Jinja2-2.11.2-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe>=0.23
  Using cached MarkupSafe-1.1.1-cp37-cp37m-manylinux1_x86_64.whl (27 kB)
Collecting packaging
  Downloading packaging-20.8-py2.py3-none-any.whl (39 kB)
Collecting pyparsing>=2.0.2
  Using cached pyparsing-2.4.7-py2.py3-none-any.whl (67 kB)
Collecting pycparser
  Using cached pycparser-2.20-py2.py3-none-any.whl (112 kB)
Collecting PyYAML
  Downloading PyYAML-5.4-cp37-cp37m-manylinux1_x86_64.whl (636 kB)
     |████████████████████████████████| 636 kB 6.4 MB/s 
Building wheels for collected packages: ansible, ansible-base
  Building wheel for ansible (setup.py) ... done
  Created wheel for ansible: filename=ansible-2.10.5-py3-none-any.whl size=47721391 sha256=f22759ae41a50441ac59a3569e1e8d66f9ef8d06dd59c60b095ce6a9e735e7e4
  Stored in directory: /home/manuel/.cache/pip/wheels/c8/ad/7a/ceabf821958d2a6afd624c59ded590b1b2dee5d704b06e47b0
  Building wheel for ansible-base (setup.py) ... done
  Created wheel for ansible-base: filename=ansible_base-2.10.5-py3-none-any.whl size=1870023 sha256=eccb3794f5ac7cb246960636815197bd754f4846661d35113963b149d3492bc9
  Stored in directory: /home/manuel/.cache/pip/wheels/15/35/1e/aed68a68d11bc538e1962939b077cc21150946eb34460819f2
Successfully built ansible ansible-base
Installing collected packages: pycparser, six, pyparsing, MarkupSafe, cffi, PyYAML, packaging, jinja2, cryptography, ansible-base, ansible
Successfully installed MarkupSafe-1.1.1 PyYAML-5.4 ansible-2.10.5 ansible-base-2.10.5 cffi-1.14.4 cryptography-3.3.1 jinja2-2.11.2 packaging-20.8 pycparser-2.20 pyparsing-2.4.7 six-1.15.0
```

### Configuración

Puede definirse en diferentes ubicaciones:

* ansible.cfg (directorio actual) --> RECOMENDABLE

Ejemplo:

```
[defaults]
inventory = ansible_inventory.ini
remote_user = debian
private_key_file = /home/user/.ssh/private_key
host_key_checking = False
```

Ansible se puede ejecutar directamente:

```
ansible controller -m user -a "name=alberto group=adm" -b
```

Pero lo recomendable es configurarlo en libros de jugadas (playbooks).
Cada jugada contiene una o varias tareas que a su vez utilizan módulos. Estos
se ejecutan secuencialmente y están escritos en YAML.

Si no existe el módulo que implemente una aplicación, podemos usar el módulo
command, que permite la utilización de bash.

## Ejercicio

Para el ejercicio, hemos hecho un fork del repositorio de github y lo hemos
clonado en nuestra máquina. A su vez, hemos creado una máquina en openstack
con la IP 172.22.201.0.

Primero, vamos a modificar el fichero hosts, el parámetro 
_ansible_ssh_host=172.22.201.0.

```
(ansible) manuel@debian:/media/manuel/Datos/automatizacion_iaw$ ansible nodo1 -m apt -a "pkg=python3-apt" -b
[WARNING]: Updating cache and auto-installing missing dependency: python3-apt
nodo1 | SUCCESS => {
    "cache_update_time": 1611148027,
    "cache_updated": false,
    "changed": false
}
```

```

```
