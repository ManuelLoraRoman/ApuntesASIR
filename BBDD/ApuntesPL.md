# Apuntes de PL/SQL


## TRIGGERS

También llamadas disparadores, este es un bloque de código que se ejecutará
cuando cierto evento ocurra. Debido a esto, este bloque de código no se puede 
ejecutar con comandos de ningún tipo. En el código de un trigger puede
aparecer cualquier intrucción permitida en PL. 

Cuando un trigger termina con excepciones no tratadas, la sentencia que la
disparó hace un ROLLBACK automáticamente.

Ejemplo de trigger:

CREATE OR REPLACE TRIGGER ejemplo	<-- CREACIÓN DEL TRIGGER
BEFORE INSERT ON EMP			<-- ESPECIFICAR CUANDO SE PRODUCIRÁ
FOR EACH ROW
 BEGIN					<-- CÓDIGO
	IF (:new.sal) > 1500 THEN
	 RAISE.APPLICATION.ERROR (-20001, 'Ese gana demasiado');
	END IF;
 END;


## Creación de triggers

* **Momento** --> BEFORE - AFTER - INSTEAD OF

### Orden de ejecución

1. **BEFORE por sentencia**
1.1. **BEFORE por fila**
1.2. **AFTER por fila**
2. **AFTER por sentencia**

* **Evento** --> INSERT - UPDATE - DELETE - COMBINACIÓN DE AMBAS

* **Nombre Tabla** --> ON Nombre_Tabla

* **Tipo de Disparo** --> Por fiña (tiene acceso a :new y :old) - Por sentencia

* **Condición de Disparo** --> WHEN (solo triggers por fila)

* **Cuerpo del Trigger** --> DECLARE/BEGIN/END;

* **Predicados condicionales** --> cuando un trigger puede ser disparado por
varias operaciones distintas, hay una forma de saber dentro del código del
trigger, cual de ellas lo disparó.

1. _IF INSERTING THEN...
2. _IF UPDATING.....THEN....
3. _IF DELETING THEN..._


## Ejemplo de trigger:

* Trigger que impida insertar datos en la tabla emp fuera del horario normal.

   Momento --> BEFORE, ya que es comprobación/validación.  
   Tipo de disparo --> por sentencia, ya que el contenido de los datos no es  
   relevante.  

```
CREATE OR REPLACE TRIGGER SeguridadEmp
BEFORE INSERT ON emp
BEGIN
	IF (TO_CHAR(SYSDATE, 'DY') IN ('SAT', 'SUN') OR
	    TO_CHAR(SYSDATE, 'HH24') NOT BETWEEN '08' AND '15' THEN
		RAISE.APPLICATION.ERROR(-20100, 'No puedes insertar
		registros fuera del horario normal de oficina');
	END IF;
END;
/
```

## Restricciones

* No se pueden ejecutar DDL.

* No se puede hacer COMMIT, ROLLBACK, etc.

* Por sentencia --> no se puede usar :new ni :old.

* Por fila --> no se puede hacer SELECT de la tabla que ha disparado el trigger.


## Gestión de Triggers

* **ALTER TRIGGER [NombreTrigger] DISABLE;**

* **ALTER TRIGGER [NombreTrigger] ENABLE;**

* **ALTER TABLE [NombreTabla] ENABLE/DISABLE ALL TRIGGERS;**

* **DROP TRIGGER [NombreTrigger];**

## Trigger de Sistema

Pueden funcionar para un esquema concreto o para toda la base de datos.


### Ejemplo de Trigger de Sistema

```
CREATE OR REPLACE TRIGGER [NombreTrigger]
[BEFORE|AFTER]
[CREATE|ALTER|DROP] OR [CREATE|ALTER|DROP]...
ON [DATABASE|SCHEMA]

DECLARE
BEGIN
EXCEPTION
END;
```

Los [[BEFORE|AFTER][CREATE|ALTER|DROP]] o [eventosys] pueden ser uno de los
siguientes:

* AFTER SERVERERROR

* AFTER LOGON

* BEFORE LOGOFF

* AFTER STARTUP

* BEFORE SHUTDOWN


## Uso más frecuentes de los triggers

* **Seguridad** --> podemos hacer que ciertos valores de los datos solo puedan 
ser introducidos por ciertos usuarios.

* **Auditorías** --> permiten guardar información sobre los usuarios que
realizan determinadas operaciones en la base de datos, incluyendo los valores
introducios en dicha operación, cuando las realizan, etc...

* **Integridad de datos** --> restricciones en los valores de los datos que 
no se pueden implementar con un simple CHECK en la creación de la tabla.

* **Replicación de tablas** --> se usan para mantener copias remotas en tiempo 
real de ciertas tablas. En réplicas, realizar las mismas operaciones DML que se
van haciendo en las tablas maestras. 

* **Cálculo de datos derivados** --> es conveniente introducir cierto grado de 
redundancia en la base de datos. Es posible que sea un problema la 
inconsistencia de los datos. 

* **Control de Eventos** 


## Tipos de datos compuestos

Ya lo hemos usado cuando realizamos un _%ROWTYPE_ o cuando hacemos un cursor.

Estos son llamados registros, y permiten trabajar con múltiples datos en una 
sola variable.

* Sintaxis:

TYPE NombreTipoDatos IS RECORD
(
	NombreCampo TipoCampo [NOT NULL] [:=ValorInicial],
	NombreCampo TipoCampo [NOT NULL] [:=ValorInicial],
	.....
);

Y podremos crear una variable con el tipo que hemos creado.

* En TipoCampo se puede usar _%TYPE_.

## Arrays

Tablas usadas en tiempo de ejecución, ya que no se queda guardada.

En programación, se reserva el tamaño para crear una tabla, pero con estas,
no es necesario.

* Sintaxis:

Primero se declara el tipo de datos _Tabla_:

TYPE TipoTablaNombresEmpleados IS TABLE OF emp.ename%TYPE
INDEX BY BINARY_INTERGER;

Y ahora declaro la variable:

MiTabla TipoTablaNombresEmpleados;

* Para crear un elementos:

MiTabla(8):='SMITH';

Si intentamos acceder a un elementos de la tabla todavía no creado, pues
levantará una excepción _NO___DATA___FOUND_.

* Operaciones (métodos):

- EXISTS(n)

- COUNT

- FIRST

- LAST

- PRIOR

- NEXT

- DELETE

- DELETE(n)

* Ejemplo:

TYPE tEmpleados IS RECORD
 (
  NUMEMP	EMP.EMPNO%TYPE,
  NUMDEPT	EMP.DEPTNO%TYPE,
  PUESTO	EMP.JOB%TYPE,
  JEFE		EMP.MGR%TYPE
 );

TYPE tTablaEmpleados IS TABLE OF tEmpleados
INDEX BY BINARY_INTEGER;

 empleados tTablaEmpleados;

i NUMBER;

BEGIN
	rellenar_tabla(empleados);

	FOR i IN empleados.FIRST..empleados.LAST LOOP
		DBMS_OUTPUT.PUT_LINE(empleados(i).numemp||empleados(i).numdept);
	END LOOP;
END;


## Paquetes PL/SQL

Las variables que se declaran en la cabecera de un paquete mantienen su valor
durante toda la sesión, se llaman variables persistentes.

* Sintaxis:

CREATE OR REPLACE PACKAGE BODY NombrePaquete AS

	Declaraciones de tipo y variables privados
	Declaraciones de cursore y excepciones privados
	....
[BEGIN instrucciones de inicialización]
END;

## Pasos a dar para resolver problemas

* Leer bien los requisitos del problema e identificar la información de la 
tabla que debo guardar en variables persistentes.

* Crear el paquete declarando los tipos de datos y las variables necesarias 
para guardar dicha información.

* Hacer un trigger before por sentencia que rellene dichas variables 
consultando la tabla mutante.

* Hacer un trigger before por fila que compruebe si el registro que se está 
manejando cumple la condición especificada consultando las variables 
persistentes.

* En muchas ocasiones, el trigger por fila también tendrá que ir actualizando 
la información que está en las variables

## Resolución paso a paso

```
CREATE OR REPLACE PACKAGE ControlSUeldos
AS
	SueldoPresi NUMBER;

TYPE tRegistroTablaSueldos IS RECORD
(
	DEPTNO		EMP.DEPTNO%TYPE,
	SAL_JEFE	EMP.SAL%TYPE
);

TYPE tTablaSueldosJefes IS TABLE OF tRegistroTablaSueldos
INDEX BY BINARY_INTEGER;

SueldosJefes tTablasSueldosJefes;

END ControlSueldos;
/
```

