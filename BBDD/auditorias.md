# Auditoria de Bases de Datos

Realiza y documenta adecuadamente las siguientes operaciones:

1. Activa desde SQL*Plus la auditoría de los intentos de acceso fallidos al 
sistema. Comprueba su funcionamiento. 

Para activar la auditoría de los intentos de acceso fallidos haremos lo
siguiente:

```
SQL> SHOW PARAMETER AUDIT

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
audit_file_dest 		     string	 /u01/app/oracle/admin/cdb1/adu
						 mp
audit_syslog_level		     string
audit_sys_operations		     boolean	 TRUE
audit_trail			     string	 DB
unified_audit_common_systemlog	     string
unified_audit_sga_queue_size	     integer	 1048576
unified_audit_systemlog 	     string
```
    
Esto nos permite ver los parámetros de auditoría. Activaremos audit_trail:

```
SQL> ALTER SYSTEM SET audit_trail=db scope=spfile;

Sistema modificado.

SQL> 
```

Para que se efectuen los cambios tenemos que reiniciar:

```
SQL> SHUTDOWN
Base de datos cerrada.
Base de datos desmontada.
Instancia ORACLE cerrada.
SQL> startup
Instancia ORACLE iniciada.

Total System Global Area 1207955552 bytes
Fixed Size		    9134176 bytes
Variable Size		  318767104 bytes
Database Buffers	  872415232 bytes
Redo Buffers		    7639040 bytes
Base de datos montada.
Base de datos abierta.
SQL> ALTER SESSION SET "_ORACLE_SCRIPT"=true;

Sesion modificada.

SQL> SHOW PARAMETER AUDIT

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
audit_file_dest 		     string	 /u01/app/oracle/admin/cdb1/adu
						 mp
audit_syslog_level		     string
audit_sys_operations		     boolean	 TRUE
audit_trail			     string	 DB
unified_audit_common_systemlog	     string
unified_audit_sga_queue_size	     integer	 1048576
unified_audit_systemlog 	     string
```

Y a continuación activamos la auditoria:

```
SQL> AUDIT CREATE SESSION WHENEVER NOT SUCCESSFUL;

Auditoria terminada correctamente.
```

Y comprobamos que está activo:

```
SQL> AUDIT CREATE SESSION BY manuel;

Auditoria terminada correctamente.

SQL> SELECT * FROM DBA_PRIV_AUDIT_OPTS;

USER_NAME
--------------------------------------------------------------------------------
PROXY_NAME
--------------------------------------------------------------------------------
PRIVILEGE				 SUCCESS    FAILURE
---------------------------------------- ---------- ----------


CREATE SESSION				 NOT SET    BY ACCESS

MANUEL

CREATE SESSION				 BY ACCESS  BY ACCESS

USER_NAME
--------------------------------------------------------------------------------
PROXY_NAME
--------------------------------------------------------------------------------
PRIVILEGE				 SUCCESS    FAILURE
---------------------------------------- ---------- ----------
```

Intentamos acceder a sqlplus:

```
[oracle@localhost ~]$ sqlplus

SQL*Plus: Release 19.0.0.0.0 - Production on Thu Feb 18 17:14:36 2021
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.

Enter user-name: manuel
Enter password: 
ERROR:
ORA-01017: nombre de usuario/contrase?a no validos; conexion denegada


Enter user-name: sys
Enter password: 
ERROR:
ORA-28009: la conexion como SYS debe ser como SYSDBA o SYSOPER


Enter user-name: sys
Enter password: 
ERROR:
ORA-28009: la conexion como SYS debe ser como SYSDBA o SYSOPER
```

Y ejecutamos la siguiente consulta para visualizar los accesos fallidos:

```
SQL> SELECT OS_USERNAME, USERNAME, EXTENDED_TIMESTAMP, ACTION_NAME, RETURNCODE
  2  FROM DBA_AUDIT_SESSION;

OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
EXTENDED_TIMESTAMP
---------------------------------------------------------------------------
ACTION_NAME		     RETURNCODE
---------------------------- ----------
oracle
MANUEL
18/02/21 17:07:01,410963 +01:00
LOGON				   1045


OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
EXTENDED_TIMESTAMP
---------------------------------------------------------------------------
ACTION_NAME		     RETURNCODE
---------------------------- ----------
oracle
MANUEL
18/02/21 17:14:42,884713 +01:00
LOGON				   1017

```

Después, podemos desactivar la auditoria de la siguiente manera:

```
SQL> NOAUDIT CREATE SESSION WHENEVER NOT SUCCESSFUL;

No auditoria terminada correctamente.
```


2. Realiza un procedimiento en PL/SQL que te muestre los accesos fallidos 
junto con el motivo de los mismos, transformando el código de error 
almacenado en un mensaje de texto comprensible.

   
```
SQL> CREATE OR REPLACE FUNCTION Accesosfallido(p_acceso NUMBER)
  2  RETURN VARCHAR2
  3  IS
  4  accesos VARCHAR2(25);
  5  BEGIN
  6  CASE p_acceso
  7  WHEN 1017 THEN
  8  accesos:='Contraseña incorrecta';
  9  WHEN 28000 THEN
 10  accesos:='Cuenta bloqueada';
 11  ELSE
 12  accesos:='Error';
 13  END CASE;
 14  RETURN accesos;
 15  END;
 16  /

Funcion creada.

SQL> CREATE OR REPLACE PROCEDURE MostrarAccesos
  2  IS
  3  CURSOR c_acceso
  4  IS
  5  SELECT USERNAME, RETURNCODE, TIMESTAMP
  6  FROM DBA_AUDIT_SESSION
  7  WHERE ACTION_NAME='LOGON'
  8  AND RETURNCODE != 0
  9  ORDER BY TIMESTAMP;
 10  v_motivo VARCHAR2(25);
 11  BEGIN
 12  FOR i IN c_acceso LOOP
 13  v_motivo:=Accesosfallido(i.RETURNCODE);
 14  dbms_output.put_line('Usuario: ' || i.USERNAME || CHR(9) || CHR(9) || ' Fecha: ' || i.TIMESTAMP || CHR(9) || '  Motivo: ' || v_motivo);
 15  END LOOP;
 16  END;
 17  /

Procedimiento creado.
```

3. Activa la auditoría de las operaciones DML realizadas por SCOTT. Comprueba 
su funcionamiento.

Para activar la auditoría de las operaciones DML tendremos que ejecutar
el siguiente comando:

```
SQL> AUDIT INSERT TABLE, UPDATE TABLE, DELETE TABLE BY SCOTT BY ACCESS;

Auditoria terminada correctamente.

```

A continuación, realizamos diferentes operaciones:

```
SQL> INSERT INTO DEPT VALUES(50,'Science','DOS HERMANAS');

1 fila creada.

SQL> UPDATE DEPT SET loc='SEVILLE' WHERE DEPTNO=20;

1 fila actualizada.

SQL> DELETE FROM DEPT WHERE DEPTNO=50;

1 fila suprimida.

SQL> COMMIT;

Confirmacion terminada.
```

Y a continuación, consultamos las modificaciones y acciones que acabamos de
hacer:

```
SQL> SELECT OS_USERNAME, USERNAME, ACTION_NAME, TIMESTAMP
  2  FROM DBA_AUDIT_OBJECT
  3  WHERE USERNAME='SCOTT';

OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAM
---------------------------- --------
oracle
SCOTT
INSERT			     18/02/21

oracle
SCOTT
INSERT			     18/02/21

OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAM
---------------------------- --------

oracle
SCOTT
INSERT			     18/02/21

oracle
SCOTT

OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAM
---------------------------- --------
INSERT			     18/02/21

oracle
SCOTT
INSERT			     18/02/21

oracle

OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAM
---------------------------- --------
SCOTT
INSERT			     18/02/21

oracle
SCOTT
INSERT			     18/02/21


OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAM
---------------------------- --------
oracle
SCOTT
INSERT			     18/02/21

oracle
SCOTT
INSERT			     18/02/21

OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAM
---------------------------- --------

oracle
SCOTT
UPDATE			     18/02/21

oracle
SCOTT

OS_USERNAME
--------------------------------------------------------------------------------
USERNAME
--------------------------------------------------------------------------------
ACTION_NAME		     TIMESTAM
---------------------------- --------
DELETE			     18/02/21

oracle
SCOTT
DELETE			     18/02/21


12 filas seleccionadas.

```
    
4. Realiza una auditoría de grano fino para almacenar información sobre la 
inserción de empleados del departamento 10 en la tabla emp de scott.

Vamos a crear un procedimiento para controlar la inserción de empleados:

```
SQL>

BEGIN
    DBMS_FGA.ADD_POLICY (
        object_schema      =>  'SCOTT',
        object_name        =>  'EMP',
        policy_name        =>  'policy1',
        audit_condition    =>  'DEPTNO = 10',
        statement_types    =>  'INSERT'
    );
END;
/
SQL> SQL>   2    3    4    5    6    7    8    9   10  
Procedimiento PL/SQL terminado correctamente.
```
    
Y visualizamos dicho procedimiento:

```
SQL> SELECT OBJECT_SCHEMA, OBJECT_NAME, POLICY_NAME, POLICY_TEXT
  2  FROM DBA_AUDIT_POLICIES;

OBJECT_SCHEMA
--------------------------------------------------------------------------------
OBJECT_NAME
--------------------------------------------------------------------------------
POLICY_NAME
--------------------------------------------------------------------------------
POLICY_TEXT
--------------------------------------------------------------------------------
SCOTT
EMP
POLICY1
DEPTNO = 10
```

5. Explica la diferencia entre auditar una operación by access o by session.

La opción de _By access_ registra un suceso de auditoría por cada INSERT,
pudiendo afectar al rendimiento. Sin embargo, la opción _By session_ solo
registrará un suceso de auditoría por sesión, aunque es menos exaustivo.
    
6. Documenta las diferencias entre los valores db y db, extended del parámetro 
audit_trail de ORACLE. Demuéstralas poniendo un ejemplo de la información 
sobre una operación concreta recopilada con cada uno de ellos.

El valor _db_ activa la auditoría y los datos se almacenarían en 
_SYS.AUD$_. Por otra parte, _db, extended_ además de almacenar los
datos en la misma tabla, escribirá valores en las columnas _SQLBIND_ y _SQLTEXT_.

Se activa con este comando:

```
SQL> SHOW PARAMETER AUDIT;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
audit_file_dest 		     string	 /u01/app/oracle/admin/cdb1/adu
						 mp
audit_syslog_level		     string
audit_sys_operations		     boolean	 TRUE
audit_trail			     string	 DB
unified_audit_common_systemlog	     string
unified_audit_sga_queue_size	     integer	 1048576
unified_audit_systemlog 	     string

SQL> ALTER SYSTEM SET audit_trail = DB, EXTENDED SCOPE=SPFILE;

Sistema modificado.
```

Y como en el primer ejercicio, debemos reiniciar la base de datos:

```
SQL> SHUTDOWN
Base de datos cerrada.
Base de datos desmontada.
Instancia ORACLE cerrada.
SQL> STARTUP
Instancia ORACLE iniciada.

Total System Global Area 1207955552 bytes
Fixed Size		    9134176 bytes
Variable Size		  318767104 bytes
Database Buffers	  872415232 bytes
Redo Buffers		    7639040 bytes
Base de datos montada.
Base de datos abierta.
SQL> SHOW PARAMETER AUDIT;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
audit_file_dest 		     string	 /u01/app/oracle/admin/cdb1/adu
						 mp
audit_syslog_level		     string
audit_sys_operations		     boolean	 TRUE
audit_trail			     string	 DB, EXTENDED
unified_audit_common_systemlog	     string
unified_audit_sga_queue_size	     integer	 1048576
unified_audit_systemlog 	     string
```

Y comprobamos que tenemos 

    
7. Localiza en Enterprise Manager las posibilidades para realizar una auditoría 
e intenta repetir con dicha herramienta los apartados 1, 3 y 4.



    
8. Averigua si en Postgres se pueden realizar los apartados 1, 3 y 4. Si es 
así, documenta el proceso adecuadamente.

Las auditorias en PostgreSQL no se pueden realizar de la misma manera
que en Oracle, ya que estas se hacen con funciones y procedimientos.

El proceso para realizar una tabla de históricos (auditoría) es el
siguiente:

* Creamos una tabla de auditoría.

* Realizamos una función que actualice los datos en la tabla de auditorias.
    
* Creamos un trigger que dispare la función anterior cuando se produzcan cambios
en la tabla original.

Información: http://www.varlena.com/GeneralBits/104.php

9. Averigua si en MySQL se pueden realizar los apartados 1, 3 y 4. Si es así, 
documenta el proceso adecuadamente.

En primer lugar, iniciamos mariadb y creamos una estructura basica:

```
root@debian:~# mariadb
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 63
Server version: 10.3.27-MariaDB-0+deb10u1 Debian 10

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> create database basico
    -> ;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> use basico;
Database changed
MariaDB [basico]> CREATE TABLE REGIMENES(
    -> CODIGO VARCHAR(9),
    -> NOMBRE VARCHAR(35),
    -> CONSTRAINT PK_CODIGO PRIMARY KEY (CODIGO));
Query OK, 0 rows affected, 1 warning (3.087 sec)
```

A continuación, creamos una base de datos para la auditoria y también creamos 
la tabla que nos sirva para la almacenar el resultado del trigger:

```
MariaDB [(none)]> create database auditorias;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> use auditorias;
Database changed
MariaDB [auditorias]> CREATE TABLE Accesos
    -> (
    -> CODIGO INT(11) NOT NULL AUTO_INCREMENT,
    -> USUARIO VARCHAR(100),
    -> FECHA DATETIME,
    -> PRIMARY KEY (`CODIGO`)
    -> )
    -> ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
Query OK, 0 rows affected (0.423 sec)
```

Ejecutamos el siguiente comando y creamos el TRIGGER:

```
MariaDB [auditorias]> delimiter $$
MariaDB [auditorias]> CREATE TRIGGER basico.manuel
    -> BEFORE INSERT ON basico.REGIMENES
    -> FOR EACH ROW
    -> BEGIN
    -> INSERT INTO auditorias.Accesos (USUARIO, FECHA)
    -> VALUES (CURRENT_USER(), NOW());
    -> END$$
Query OK, 0 rows affected (0.720 sec)

```

A continuación, vamos a entrar en la base de datos _basico_ y añadiremos un
registro nuevo:

```
MariaDB [(none)]> use basico;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [basico]> INSERT INTO REGIMENES
    -> VALUES ('AD','Alojamiento y Desayuno');
Query OK, 1 row affected (0.340 sec)

```

Comprobamos que efectivamente se ha registrado el acceso con el trigger:

```
MariaDB [basico]> use auditorias;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [auditorias]> SELECT * FROM Accesos;
+--------+----------------+---------------------+
| CODIGO | USUARIO        | FECHA               |
+--------+----------------+---------------------+
|      1 | root@localhost | 2021-02-20 11:32:46 |
+--------+----------------+---------------------+
1 row in set (0.000 sec)
```
    
10.  Averigua las posibilidades que ofrece MongoDB para auditar los cambios 
que va sufriendo un documento.

MongoDB permite el uso de auditorias para varias operaciones. Cuando está
habilitada, la herramienta de auditoria, de manera predeterminada, guarda 
todas las operaciones auditables. Para especificar que eventos queremos que
guarde, la herramienta de auditoria incluye la opción ```--auditFilter```.

* Filtrado para múltiples tipos de operaciones

```
{ atype: { $in: [ "createCollection", "dropCollection" ] } }
```

Si queremos especificar un filtro de auditoria usaremos comillas simples:

```
mongod --dbpath data/db --auditDestination file --auditFilter '{ atype: { $in: [ "createCollection", "dropCollection" ] } }' --auditFormat BSON --auditPath data/db/auditLog.bson
```
 
Se puede especificar un filtro de auditoria con un fichero _.yaml_.

La información está recogida [aquí](https://docs.mongodb.com/manual/tutorial/configure-audit-filters/).
   
11.  Averigua si en MongoDB se pueden auditar los accesos al sistema.

Siguiendo la información anterior, nos encontramos con el filtrado de 
las operaciones de autenticación. Para este tipo de operaciones, los 
mensajes de auditoria incluyen un campo _db_ en el parámetro documento.

Ahora pondremos un ejemplo de como solo audita las operaciones de 
autenticación:

```
{ atype: "authenticate", "param.db": "test" }
```

Como hemos visto anteriormente, se puede especificar un filtro de auditoria
con las comillas simples:

```
mongod --dbpath data/db --auth --auditDestination file --auditFilter '{ atype: "authenticate", "param.db": "test" }' --auditFormat BSON --auditPath data/db/auditLog.bson
```

