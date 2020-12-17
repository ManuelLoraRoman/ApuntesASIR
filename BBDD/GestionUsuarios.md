# Gestión de Usuarios en Oracle

Un esquema es un conjunto de objetos que es propiedad de un usuario concreto.
Dichos objetos pueden ser tablas, vistas, índices, funciones, etc.

Es un planteamiento diferente al de MySQL, ya que para dicho gestor, un esquema
es prácticamente una base de datos, nada más.

La sintaxis completa para crear usuarios es:

```
CREATE USER ...
IDENTIFIED BY ...
[DEFAULT TABLESPACE nombre_ts]
[TEMPORARY TABLESPACE nombre_ts_temp]
[QUOTA {num {K | M} | UNLIMITED } ON nombre_ts]
[PROFILE perfil];
```

Para modificar usamos ```ALTER USER ...;````y para borrar ```DROP USER ...;```.

Los usuarios creados se guardan en el diccionario de datos DBA_USERS.
Las cuotas de tablespaces de los usuarios se guardan en DBA_TS_QUOTAS.

## Asignación y revocación de privilegios

Hay dos tipos de privilegios distintos: de sistema o de objeto.

La sintaxis que se sigue es:

```
GRANT privilegio ON propietario.objeto TO [usuario | rol | PUBLIC]
[WITH GRANT OPTION];
```

Los privilegios son: SELECT, INSERT, UPDATE, DELETE, ALTER, EXECUTE, INDEX,
REFERENCES y ALL.

Estos eran privilegios de Objeto. Ahora, pasando a los de sistema, se caracterizan
porque permiten realizar una determinada operación o ejecutar comandos concretos.
Algunos son:

* CREATE, ALTER y DROP.

* CREATE ANY, ALTER ANY y DROP ANY.

* SELECT, INSERT, UPDATE o DELETE ANY TABLE.

```
GRANT privilegio TO [usuario | rol | PUBLIC][WITH ADMIN OPTION];
```

Y para revocar privilegios:

```
REVOKE privilegio FROM [usuario | rol];
```

Los privilegios de sistema concedidos a usuarios se guardan en DBA_SYS_PRIVS.
Los privilegios sobre objetos concedidos a usuarios se guardan en DBA_TAB_PRIVS.
Los privilegios sobre columnas en DBA_COL_PRIVS.

## Gestión de roles

Un rol es un conjunto de privilegios.

Los roles más importantes son CONNECT, RESOURCE y DBA.

Podemos crear nuevos roles, y posteriormente añadir privilegios.

Con los perfiles se puede limitar: 

* SESSIONS_PER_USER: nº maximo de sesiones concurrentes,

* CONNECT_TIME: duración máxima.

* IDLE_TIME: tiempo máximo de inactividad.

* CPU_PER_SESSION: tiempo máximo de uso de la CPU por sesión.

* CPU_PER_CALL: tiempo máximo de uso de CPU por llamada.

* LOGICAL_READS_PER_SESSION: máximo de nº de bloques de datos leídos por sesión.

* LOGICAL_READS_PER_CALL: máximo de nº de bloques de datos leídos por llamada.

* PRIVATE_SGA: cantidad de memoria para la sesión.


Y para las contraseñas:

* FAILED_LOGIN_ATTEMPTS: máximo de intentos fallidos.

* PASSWORD_LIFE_TIME: dias de vida de la contraseña.

* PASSWORD_REUSE_TIME: dias que deben pasar para reutilizar una contraseña.

* PASSWORD_REUSE_MAX: número de veces que se debe cambiar una contraseña
antes de reutilizarla.

* PASSWORD_LOCK_TIME: número de dias que la cuenta queda bloqueada.

* PASSWORD_GRACE_TIME: periodo de gracia de contraseñas caducadas.

* PASSWORD_VERIFY_FUNCTION: dar visto bueno a las contraseñas.

Ejemplo:

```
ALTER USER ___ PROFILE perfil;

ALTER PROFILE perfil {parametrorecurso | parametrocontraseña} [valor [K|M] | UNLIMITED;

DROP PROFILE perfil;

Diccionarios de datos:

* DBA_PROFILES --> muestra los perfiles existentes con sus limites.

* DBA_USERS --> muestra los perfiles de los usuarios.
