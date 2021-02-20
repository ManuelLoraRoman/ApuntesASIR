# Práctica Almacenamiento

## Oracle

1. Establece que los objetos que se creen en el TS1 (creado por tí) tengan un 
tamaño inicial de 200K, y que cada extensión sea del doble del tamaño que la 
anterior. El número máximo de extensiones debe ser de 3.

Creamos primero el tablespace TS1:

```
SQL> CREATE TABLESPACE TS1
  2  DATAFILE '/u02/oradata/CDB1/ts1.dbf'                 
  3  SIZE 200K
  4  AUTOEXTEND ON
  5  DEFAULT STORAGE (
  6  INITIAL 200K
  7  NEXT 200K
  8  MAXEXTENTS 3
  9  PCTINCREASE 100);

Tablespace creado.
```
       
2. Crea dos tablas en el tablespace recién creado e inserta un registro en 
cada una de ellas. Comprueba el espacio libre existente en el tablespace. 
Borra una de las tablas y comprueba si ha aumentado el espacio disponible en 
el tablespace. Explica la razón.

Crearemos dos tablas que son las siguientes:

```
SQL> CREATE TABLE TEMPORADAS
  2  (
  3  CODIGO VARCHAR2(9),
  4  NOMBRE VARCHAR2(35),
  5  CONSTRAINT PK_TEMPORADAS PRIMARY KEY (CODIGO))
  6  TABLESPACE TS1;

Tabla creada.

SQL> CREATE TABLE REGIMENES
  2  (
  3  CODIGO VARCHAR2(9),
  4  NOMBRE VARCHAR2(35),
  5  CONSTRAINT PK_REGIMENES PRIMARY KEY (CODIGO))
  6  TABLESPACE TS1;

Tabla creada.

SQL> INSERT INTO TEMPORADAS VALUES ('03','Especial');

1 fila creada.

SQL> INSERT INTO TEMPORADAS VALUES ('01','Baja');

1 fila creada.

SQL> INSERT INTO REGIMENES VALUES ('AD','Alojamiento y desayuno');

1 fila creada.

SQL> INSERT INTO REGIMENES VALUES ('MP','Media Pensión');

1 fila creada.

SQL> SELECT TABLESPACE_NAME,TO_CHAR(SUM(NVL(BYTES,0))/1024/1024, '99,999,990.99') AS "FREE SPACE(IN MB)" 
  2  FROM USER_FREE_SPACE 
  3  GROUP BY TABLESPACE_NAME;

TABLESPACE_NAME 	       FREE SPACE(IN
------------------------------ --------------
SYSTEM					 1.56
SYSAUX					34.56
UNDOTBS1			       197.75
TS1					 0.94
USERS					 2.31
```

Ahora borramos una de las tablas y volvemos a comprobar el espacio:

```
SQL> DROP TABLE TEMPORADAS;

Tabla borrada.

SQL> SELECT TABLESPACE_NAME,TO_CHAR(SUM(NVL(BYTES,0))/1024/1024, '99,999,990.99') AS "FREE SPACE(IN MB)" 
  2  FROM USER_FREE_SPACE 
  3  GROUP BY TABLESPACE_NAME;

TABLESPACE_NAME 	       FREE SPACE(IN
------------------------------ --------------
SYSTEM					 1.56
SYSAUX					34.56
UNDOTBS1			       197.75
TS1					 1.06
USERS					 2.31

```

Esto se debe a que dichas tablas y sus registros son guardados en el 
tablespace TS1, y por ello, al eliminarlos aumenta el espacio libre.
       
3. Convierte a TS1 en un tablespace de sólo lectura. Intenta insertar 
registros en la tabla existente. ¿Qué ocurre?. Intenta ahora borrar la tabla. 
¿Qué ocurre? ¿Porqué crees que pasa eso?
       
```
SQL> ALTER TABLESPACE TS1 READ ONLY;

Tablespace modificado.

SQL> INSERT INTO REGIMENES VALUES ('PC','Pension completa');
INSERT INTO REGIMENES VALUES ('PC','Pension completa')
            *
ERROR en linea 1:
ORA-00372: el archivo 15 no se puede modificar en este momento
ORA-01110: archivo de datos 15: '/u02/oradata/CDB1/ts1.dbf'
```

No nos dejaría introducir ningún registro.

```
SQL> DROP TABLE REGIMENES;

Tabla borrada.

```

Esto se debe a que las tablas están en el diccionario de datos y el 
tablespace TS1 es gestionado por un usuario (SYS que tiene permisos del
Diccionario de datos).

4. Crea un espacio de tablas TS2 con dos ficheros en rutas diferentes de 1M 
cada uno no autoextensibles. Crea en el citado tablespace una tabla con la 
clausula de almacenamiento que quieras. Inserta registros hasta que se llene 
el tablespace. ¿Qué ocurre?

Creamos el tablespace nuevo:

```
SQL> CREATE TABLESPACE TS2
  2  DATAFILE '/u02/oradata/CDB1/ts2.dbf' SIZE 1M, '/u02/oradata/ts2.dbf' SIZE 1M
  3  AUTOEXTEND OFF;

Tablespace creado.

SQL> CREATE TABLE TIPO_DE_HABITACION
  2  (
  3  CODIGO VARCHAR2(9),
  4  NOMBRE VARCHAR2(35),
  5  CONSTRAINT PK_TIPOHABIT PRIMARY KEY (CODIGO))
  6  TABLESPACE TS2;

Tabla creada.
```

Al insertar los registros, nos dará el siguiente error:

```
SQL> INSERT INTO TIPO_DE_HABITACION VALUES ('127','Habitacion doble');
INSERT INTO TIPO_DE_HABITACION VALUES ('127','Habitacion doble');
*
ERROR en lÝnea 1:
ORA-01653: no se ha podido ampliar la tabla SYS.TIPO_DE_HABITACION con 128 en el
tablespace TS2
```

5. Realiza una consulta al diccionario de datos que muestre qué índices 
existen para objetos pertenecientes al esquema de SCOTT y sobre qué columnas 
están definidos. Averigua en qué fichero o ficheros de datos se encuentran 
las extensiones de sus segmentos correspondientes.

```
SQL> SELECT INDEX_NAME FROM DBA_INDEXES WHERE TABLE_NAME = 'EMP';

INDEX_NAME
--------------------------------------------------------------------------------
PK_EMP

SQL> SELECT INDEX_NAME FROM DBA_INDEXES WHERE TABLE_NAME = 'DEPT';

INDEX_NAME
--------------------------------------------------------------------------------
PK_DEPT

SQL> SELECT COLUMN_NAME FROM DBA_IND_COLUMNS WHERE TABLE_NAME='EMP';

COLUMN_NAME
--------------------------------------------------------------------------------
EMPNO

SQL> SELECT COLUMN_NAME FROM DBA_IND_COLUMNS WHERE TABLE_NAME='DEPT';

COLUMN_NAME
--------------------------------------------------------------------------------
DEPTNO
```

Y para los segmentos:

```
SQL> SELECT SEGMENT_NAME, INITIAL_EXTENT FROM DBA_ROLLBACK_SEGS;

SEGMENT_NAME		       INITIAL_EXTENT
------------------------------ --------------
SYSTEM				       114688
_SYSSMU1_1261223759$		       131072
_SYSSMU2_27624015$		       131072
_SYSSMU3_2421748942$		       131072
_SYSSMU4_625702278$		       131072
_SYSSMU5_2101348960$		       131072
_SYSSMU6_813816332$		       131072
_SYSSMU7_2329891355$		       131072
_SYSSMU8_399776867$		       131072
_SYSSMU9_1692468413$		       131072
_SYSSMU10_930580995$		       131072

11 filas seleccionadas.
```

6. Resuelve el siguiente caso práctico en ORACLE:

En nuestra empresa existen tres departamentos: Informática, Ventas y 
Producción. En Informática trabajan tres personas: Pepe, Juan y Clara. En 
Ventas trabajan Ana y Eva y en Producción Jaime y Lidia.

a) Pepe es el administrador de la base de datos.
Juan y Clara son los programadores de la base de datos, que trabajan tanto en 
la aplicación que usa el departamento de Ventas como en la usada por el 
departamento de Producción. Ana y Eva tienen permisos para insertar, modificar 
y borrar registros en las tablas de la aplicación de Ventas que tienes que 
crear, y se llaman Productos y Ventas, siendo propiedad de Ana.
Jaime y Lidia pueden leer la información de esas tablas pero no pueden 
modificar la información. Crea los usuarios y dale los roles y permisos que 
creas conveniente.  

Primer vamos a crear al usuario _Pepe_, y el asignaremos los privilegios
_dba_. Después, crearemos al usuario _Juan_ y a _Ana_. A estos, le asignaremos 
los privilegios de _resource_. Creamos también a los usuarios _Eva y Ana_ y les
asignamos los privilegios correspondientes. También, crearemos a Jaime y a Lidia
con los privilegios pertinentes:

```
SQL> CREATE USER PEPE IDENTIFIED BY PEPE;

Usuario creado.
 
SQL> GRANT DBA TO PEPE;

Concesion terminada correctamente.

SQL> CREATE USER JUAN IDENTIFIED BY JUAN;

Usuario creado.

SQL> CREATE USER CLARA IDENTIFIED BY CLARA;

Usuario creado.

SQL> GRANT RESOURCE TO JUAN;

Concesion terminada correctamente.

SQL> GRANT RESOURCE TO CLARA;

Concesion terminada correctamente.

SQL> CREATE USER ANA IDENTIFIED BY ANA;

Usuario creado.

SQL> CREATE USER EVA IDENTIFIED BY EVA;

Usuario creado.

SQL> GRANT CREATE SESSION TO ANA;

Concesion terminada correctamente.

SQL> GRANT CREATE TABLE TO ANA;

Concesion terminada correctamente.

SQL> CONNECT ANA;
Introduzca la contrase?a: 
Conectado.
SQL> CREATE TABLE VENTAS(
  2  CODIGO VARCHAR2(10),
  3  DESCRIPCION VARCHAR2(100),
  4  IMPORTE NUMBER(7,2),
  5  CONSTRAINT PK_CODIGO PRIMARY KEY (CODIGO));

Tabla creada.

SQL> CREATE TABLE PRODUCTOS(
  2  CODIGO VARCHAR2(10),
  3  NOMBRE VARCHAR2(50),
  4  COSTE NUMBER(7,2),
  5  CONSTRAINT PK_CODPROD PRIMARY KEY (CODIGO));

Tabla creada.

SQL> GRANT SELECT ON ANA.VENTAS TO EVA;

Concesion terminada correctamente.

SQL> GRANT INSERT ON ANA.VENTAS TO EVA;

Concesion terminada correctamente.

SQL> GRANT UPDATE ON ANA.VENTAS TO EVA;

Concesion terminada correctamente.

SQL> GRANT DELETE ON ANA.VENTAS TO EVA;

Concesion terminada correctamente.

SQL> GRANT SELECT ON ANA.PRODUCTOS TO EVA;

Concesion terminada correctamente.

SQL> GRANT INSERT ON ANA.PRODUCTOS TO EVA;

Concesion terminada correctamente.

SQL> GRANT UPDATE ON ANA.PRODUCTOS TO EVA;

Concesion terminada correctamente.

SQL> GRANT DELETE ON ANA.PRODUCTOS TO EVA;

Concesion terminada correctamente.

SQL> CREATE USER JAIME IDENTIFIED BY JAIME;

Usuario creado.

SQL> CREATE USER LIDIA IDENTIFIED BY LIDIA;

Usuario creado.

SQL> GRANT SELECT ON ANA.VENTAS TO JAIME;

Concesion terminada correctamente.

SQL> GRANT SELECT ON ANA.VENTAS TO LIDIA;

Concesion terminada correctamente.

SQL> GRANT SELECT ON ANA.PRODUCTOS TO JAIME;

Concesion terminada correctamente.

SQL> GRANT SELECT ON ANA.PRODUCTOS TO LIDIA;

Concesion terminada correctamente.
```

Podemos crear también roles para una mejor gestión de los permisos y privilegios
de usuario:

* Rol para producción

```
SQL> CREATE ROLE PRODUCCION;

Rol creado.

SQL> GRANT SELECT ON ANA.VENTAS TO PRODUCCION;

Concesion terminada correctamente.

SQL> GRANT SELECT ON ANA.PRODUCTOS TO PRODUCCION;

Concesion terminada correctamente.
```

* Rol para Ventas

```
SQL> CREATE ROLE VENTAS;

Rol creado.

SQL> GRANT SELECT,INSERT,UPDATE,DELETE ON ANA.VENTAS TO VENTAS;

Concesion terminada correctamente.

SQL> GRANT SELECT,INSERT,UPDATE,DELETE ON ANA.PRODUCTOS TO VENTAS;

Concesion terminada correctamente.
```

b) Los espacios de tablas son System, Producción (ficheros prod1.dbf y prod2.dbf)
y Ventas (fichero vent.dbf). Los programadores del departamento de Informática 
pueden crear objetos en cualquier tablespace de la base de datos, excepto en 
System. Los demás usuarios solo podrán crear objetos en su tablespace 
correspondiente teniendo un límite de espacio de 30 M los del departamento de 
Ventas y 100K los del de Producción. Pepe tiene cuota ilimitada en todos los 
espacios, aunque el suyo por defecto es System.

Crearemos los tablespaces de system, produccion y ventas:

```
SQL> CREATE TABLESPACE TS_PRODUCCION
  2  DATAFILE 'prod1.dbf' SIZE 100M,
  3  'prod2.dbf' SIZE 100M AUTOEXTEND ON;

Tablespace creado.

SQL> CREATE TABLESPACE TS_VENTA
  2  DATAFILE 'vent.dbf'
  3  SIZE 100M AUTOEXTEND ON;

Tablespace creado.
```

Y les asignamos las cuotas a los usuarios Ana, Eva, Jaime y Lidia:

```
SQL> ALTER USER ANA QUOTA 30M ON TS_VENTA;

Usuario modificado.

SQL> ALTER USER EVA QUOTA 30M ON TS_VENTA;

Usuario modificado.

SQL> ALTER USER JAIME QUOTA 100K ON TS_PRODUCCION;

Usuario modificado.

SQL> ALTER USER LIDIA QUOTA 100K ON TS_PRODUCCION;

Usuario modificado.

```

A continuación, vamos a modificar el tablespace de Pepe (default)
a system:

```
SQL> ALTER USER PEPE DEFAULT TABLESPACE SYSTEM;

Usuario modificado.

SQL> GRANT UNLIMITED TABLESPACE TO PEPE;

Concesion terminada correctamente.
```

Ahora, revocaremos los privilegios sobre los usuarios Juan y Clara en
el tablespace System y para ello tenemos que asignarle un tamaño de
cuota 0:

```
SQL> GRANT UNLIMITED TABLESPACE TO JUAN;

Concesion terminada correctamente.

SQL> GRANT UNLIMITED TABLESPACE TO CLARA;

Concesion terminada correctamente.

SQL> ALTER USER JUAN QUOTA 0 ON SYSTEM;

Usuario modificado.

SQL> ALTER USER CLARA QUOTA 0 ON SYSTEM;

Usuario modificado.

```

c) Pepe quiere crear una tabla Prueba que ocupe inicialmente 256K en el 
tablespace Ventas.

```
SQL> CREATE TABLE PEPE.PRUEBA (
  2  CODIGO VARCHAR2(10),
  3  NOMBRE VARCHAR2(50),
  4  CONSTRAINT PK_CODIGO PRIMARY KEY(CODIGO))
  5  STORAGE(INITIAL 256K);

Tabla creada.

```

d) Pepe decide que los programadores tengan acceso a la tabla Prueba antes 
creada y puedan ceder ese derecho y el de conectarse a la base de datos a los 
usuarios que ellos quieran.

```
SQL> GRANT SELECT ON PEPE.PRUEBA TO JUAN WITH GRANT OPTION;

Concesion terminada correctamente.

SQL> GRANT SELECT ON PEPE.PRUEBA TO CLARA WITH GRANT OPTION;

Concesion terminada correctamente.

SQL> GRANT CONNECT TO CLARA WITH ADMIN OPTION;

Concesion terminada correctamente.

SQL> GRANT CONNECT TO JUAN WITH ADMIN OPTION;

Concesion terminada correctamente.
```

	
e) Lidia y Jaime dejan la empresa, borra los usuarios y el espacio de tablas 
correspondiente, detalla los pasos necesarios para que no quede rastro del 
espacio de tablas.
       
```
SQL> DROP USER LIDIA CASCADE;

Usuario borrado.

SQL> DROP USER JAIME CASCADE;

Usuario borrado.

SQL> DROP TABLESPACE TS_PRODUCCION INCLUDING CONTENTS AND DATAFILES;

Tablespace borrado.

```

## POSTGRES

7. Averigua si existe el concepto de segmento y el de extensión en Postgres, 
en qué consiste y las diferencias con los conceptos correspondientes de ORACLE.

En Postgresql, un segmento son los ficheros que se crean junto con el 
tablespace en su contrapartida a Oracle, el cual es un grupo de bloques de 
disco.

Cuando en Postgresql se crea un segmento, se crea un archivo de datos dentro
del directorio asignado al tablespace. A este archivo no se le puede indicar
el tamaño ni el nombre directamente, y no es compartido por otras tablas.
Es decir, en una tablespace donde existan por ejemplo 4 tablas, deberían
existir como mínimo 4 archivos.

Las extensiones como tal en Postgresql  son librerías que se agregan a
Postgresql para agregar funcionalidades específicas.

## MySQL

8. Averigua si existe el concepto de espacio de tablas en MySQL y las 
diferencias con los tablespaces de ORACLE.

MySQL utiliza el sistema de almacenamiento mediante tablespaces. Algunos
motores de almacenamiento serán InnoDB o NDB. Estos respecto a Oracle, tienen
más limitaciones en cuanto a la gestión de almacenamiento.

Esta sería la sintaxis de ambos motores a la hora de crear tablespaces:

* InnoDB

```
CREATE TABLESPACE tablespace_name [ADD DATAFILE 'file_name']
[FILE_BLOCK_SIZE = value]
[ENCRYPTION [=] {'Y' | 'N'}] [ENGINE [=] InnoDB];
```

* NDB

```
CREATE LOGFILE GROUP logfile_group;

CREATE TABLESPACE tablespace_name [ADD DATAFILE 'file_name']
USE LOGFILE GROUP logfile_group
[EXTENT_SIZE [=] extent_size] [INITIAL_SIZE [=] initial_size]
[AUTOEXTEND_SIZE [=] autoextend_size] [MAX_SIZE [=] max_size]
[NODEGROUP [=] nodegroup_id] [WAIT]
[COMMENT [=] 'string'] [ENGINE [=] NDB];
```

La principal diferencia que se puede encontrar con Oracle es a la hora
de asignarle una cuota de almacenamiento, ya que con InnoDB, no es posible.

Tampoco contamos con todas las cláusulas de almacenamiento que tenemos en 
Oracle.

## MongoDB

9. Averigua si existe la posibilidad en MongoDB de decidir en qué archivo se 
almacena una colección.

Lo único que he encontrado es lo siguiente.

Existe la siguiente instrucción ```db.collection.save()```. Tiene la siguiente 
estructura:

```
db.collection.save(
   <document>,
   {
     writeConcern: <document> (OPCIONAL)
   }
)
```

El parámetro _document_ es el documento a guardar la colleción. El parámetro 
_WriteConcern_ es opcional y describe el nivel de reconocimiento pedido por
MongoDB para escribir operaciones en mongod.

The _save()_ devuelve un objeto que contiene el status de la operación.

