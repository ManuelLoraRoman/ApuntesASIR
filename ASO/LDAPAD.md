# Configurar LDAP en alta disponibilidad

Vamos a instalar un servidor LDAP en sancho que va a actuar como servidor 
secundario o de respaldo del servidor LDAP instalado en frestón, para ello 
habrá que seleccionar un modo de funcionamiento y configurar la sincronización 
entre ambos directorios, para que los cambios que se realicen en uno de ellos 
se reflejen en el otro.

* Selecciona el método más adecuado para configurar un servidor LDAP 
secundario, viendo y/o probando las opciones posibles.

El método que usaremos será el _MirrorMode_, ya que nos permitirá la
escritura de directorio con total seguridad mientras el LDAP master 
(Freston) este operativo.
   
* Explica claramente las características, ventajas y limitaciones del método 
seleccionado.

Una característica es que los nodos maestros se replican entre si para que 
estén siempre actualizados y así poder estar listos para hacerse cargo de 
cualquier tipo de carga de información o consulta de la misma.

Algunas de las ventajas son : siempre se tiene un proveedor operativo, las
escrituras se pueden hacer de forma segura y siempre están actualizados los
nodos. Por otro lado, permiten que los nodos proveedores se vuelvan a 
sincronizar después de cualquier tiempo de inactividad.

La desventajas serían: no es una solución Multi-master (método de replicación
de base de datos donde se habilitan los datos para ser distribuidos en un
grupo, actualizado por cualquier miembro del mismo), ya que las escrituras
solo pueden ir a un nodo al mismo tiempo. Por esto mismo, se requiere de un
servidor externo (slapd en modo proxy) o un dispositivo (hardware load 
balancer) para administrar que proveedor está activo actualmente.
  
* Realiza las configuraciones adecuadas en el directorio cn=config.
   
* Como prueba de funcionamiento, prepara un pequeño fichero ldif, que se 
insertará en el directorio en la corrección y se verificará que se ha 
sincronizado.


