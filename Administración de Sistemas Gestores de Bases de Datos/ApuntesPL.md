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

## Restricciones

* No se pueden ejecutar DDL.

* No se puede hacer COMMIT, ROLLBACK, etc.

* Por sentencia --> no se puede usar :new ni :old.

* Por fila --> no se puede hacer SELECT de la tabla que ha disparado el trigger.

