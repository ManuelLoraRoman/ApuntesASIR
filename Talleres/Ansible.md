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



## Ejercicio
