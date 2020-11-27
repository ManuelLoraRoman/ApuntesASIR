# Práctica juvenil: Ejercicio 2

Diseña un procedimiento al que pasemos como parámetro de entrada el nombre de uno de los módulos existentes en la BD y visualice el nombre de los alumnos que lo han cursado junto a su nota.

Al final del listado debe aparecer el nº de suspensos, aprobados, notables y sobresalientes.

Asimismo, deben aparecer al final los nombres y notas de los alumnos que tengan la nota más alta y la más baja.

Debes comprobar que las tablas tengan almacenada información y que exista el módulo cuyo nombre pasamos como parámetro al procedimiento.


## Ejercicio 2

```
CREATE OR REPLACE PROCEDURE listadoalumnos(p_NOMBRE ASIGNATURAS.NOMBRE%TYPE)
IS
          cont_sus NUMBER:=0;
          cont_apr NUMBER:=0;
          cont_not NUMBER:=0;
          cont_sob NUMBER:=0;
          v_nombre_mejor ALUMNOS.APENOM%TYPE;
          v_nombre_peor ALUMNOS.APENOM%TYPE;
          v_nota_mejor NOTAS.NOTA%TYPE:=-1;
          v_nota_peor NOTAS.NOTA%TYPE:=11;;

          cursor c_notas
          IS
              SELECT DNI, NOTA
              FROM NOTAS
              WHERE COD = (SELECT COD
                           FROM ASIGNATURAS
                           WHERE NOMBRE = p_NOMBRE);
BEGIN

  for v_notas in c_notas loop    

      Mostrar_nota_alumno(v_nota.dni, v_notas.nota);

      Contar_notas(v_notas.nota, cont_sus, cont_apr, cont_not, cont_sob);

      Comprobación_mejor_nota(v_notas.dni, v_notas.nota, v_nombre_mejor, v_nota_mejor);

      Comprobación_peor_nota(v_notas.dni, v_notas.nota, v_nombre_peor, v_nota_peor);

  end loop;

      Mostrar_por_calificación(cont_sus, cont_apr, cont_not, cont_sob);

      Peor_mejor_nota(v_nombre_mejor, v_nota_mejor, v_nombre_peor, v_nota_peor);

END listadoalumnos;
```
### Mostrar_nota_alumno

```
CREATE OR REPLACE PROCEDURE Mostrar_nota_alumno(p_DNI ALUMNOS.DNI%TYPE, p_NOTA NOTAS.NOTA%TYPE)
IS
        v_nombre ALUMNOS.APENOM%TYPE;
BEGIN
        SELECT APENOM INTO v_nombre
        FROM ALUMNOS
        WHERE DNI = p_DNI;

        dbms_output.put_line(rpad(v_nombre,40) || p_NOTA);

END Mostrar_nota_alumno;
```

### Contar_notas

```
CREATE OR REPLACE PROCEDURE Contar_notas(p_NOTA NOTAS.NOTA%TYPE, p_SUS IN OUT number, p_APR IN OUT number, p_NOT IN OUT number, p_SOB IN OUT number)
IS
BEGIN
        CASE
            WHEN (p_NOTA <5) THEN
              p_SUS:=p_SUS + 1;
            WHEN (p_NOTA >= 5 AND p_NOTA < 7) THEN
              p_APR:=p_APR + 1;
            WHEN (p_NOTA >= 7 AND p_NOTA < 9) THEN
              p_NOT:=p_NOT + 1;
            WHEN (p_NOTA >= 9) THEN
              p_SOB:=p_SOB + 1;
        END CASE;
END Contar_notas;
```

### Comprobación_mejor_nota

```
CREATE OR REPLACE PROCEDURE Comprobación_mejor_nota(p_DNI NOTAS.DNI%TYPE, p_NOTA NOTAS.NOTA%TYPE, p_NOMBRE IN OUT ALUMNOS.APENOM%TYPE, p_NOTAMAX IN OUT NOTAS.NOTA%TYPE)
IS
BEGIN
      IF(p_NOTA > p_NOTAMAX) THEN
        SELECT APENOM INTO p_NOMBRE
        FROM ALUMNOS
        WHERE DNI = p_DNI;
        p_NOTAMAX:=p_NOTA;
      END IF;
END Comprobación_mejor_nota;
```

### Comprobación_peor_nota

```
CREATE OR REPLACE PROCEDURE Comprobación_peor_nota(p_DNI NOTAS.DNI%TYPE, p_NOTA NOTAS.NOTA%TYPE, p_NOMBRE IN OUT ALUMNOS.APENOM%TYPE, p_NOTAMIN IN OUT NOTAS.NOTA%TYPE)
IS
BEGIN
      IF(p_NOTA > p_NOTAMIN) THEN
        SELECT APENOM INTO p_NOMBRE
        FROM ALUMNOS
        WHERE DNI = p_DNI;
        p_NOTAMIN:=p_NOTA;
      END IF;
END Comprobación_peor_nota;
```

### Mostrar_por_calificación

```
CREATE OR REPLACE PROCEDURE Mostrar_por_calificación(p_SUS NUMBER, p_APR NUMBER, p_NOT NUMBER, p_SOB NUMBER)
IS
BEGIN
      dbms_output.put_line('CALIFICACIÓN:');
      dbms_output.put_line('_________________');
      dbms_output.put_line('Suspensos: ' || p_SUS);
      dbms_output.put_line('Aprobados: ' || p_APR);
      dbms_output.put_line('Notables: ' || p_NOT);
      dbms_output.put_line('sobresalientes: ' || p_SOB);
END Mostrar_por_calificación;
```

### Peor_mejor_nota

```
CREATE OR REPLACE PROCEDURE Peor_mejor_nota(p_NOMBRE_MEJOR ALUMNOS.APENOM%TYPE, p_NOTA_MEJOR NOTAS.NOTA%TYPE, p_NOMBRE_PEOR ALUMNOS.APENOM%TYPE, p_NOTA_PEOR NOTAS.NOTA%TYPE)
IS
BEGIN
      dbms_output.put_line('La mejor nota es ' || p_NOTA_MEJOR || ', por ' || p_NOMBRE_MEJOR);
      dbms_output.put_line('La peor nota es ' || p_NOTA_PEOR || ', por ' || p_NOMBRE_PEOR);
END Peor_mejor_nota;
```
