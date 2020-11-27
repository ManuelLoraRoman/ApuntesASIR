
1. Realiza una función ComprobarPago que reciba como parámetros un código de cliente y un código de actividad y devuelva un TRUE si el cliente ha pagado la última actividad con ese código que ha realizado y un FALSE en caso contrario. Debes controlar las siguientes excepciones: Cliente inexistente, Actividad Inexistente, Actividad realizada en régimen de Todo Incluido y El cliente nunca ha realizado esa actividad.

```
# Procedimiento para ver si el cliente exite o no.
CREATE OR REPLACE PROCEDURE ClienteInexistente (p_codcliente personas.nif%TYPE)
IS
      v_cuentaclientes NUMBER:=0;
BEGIN
      SELECT COUNT(nifcliente) INTO v_cuentaclientes
      FROM estancias
      WHERE p_codcliente = nifcliente;
      IF v_cuentaclientes = 0 THEN
            RAISE_APPLICATION_ERROR (-20001, 'Cliente Inexistente');
      END IF;
END ClienteInexistente;
/

# Procedimiento para ver si la actividad existe o no.
CREATE OR REPLACE PROCEDURE ActividadInexistente (p_codactividad actividades.codigo%TYPE)
IS
      v_cuentaactividades NUMBER:=0;
BEGIN
      SELECT COUNT(codigo) INTO v_cuentaactividades
      FROM actividades
      WHERE p_codactividad = codigo;
      IF v_cuentaactividades = 0 THEN
            RAISE_APPLICATION_ERROR (-20002, 'Actividad Inexistente');
      END IF;
END ActividadInexistente;
/

# Procedimiento para ver si está en Régimen de Todo Incluido.
CREATE OR REPLACE PROCEDURE TodoIncluido (p_codactividad actividades.codigo%TYPE)
IS
      v_cuentaregimen NUMBER:=0;
BEGIN
      SELECT COUNT(codigo) INTO v_cuentaregimen
      FROM estancias
      WHERE codigoregimen = 'TI' AND codigo = (SELECT codigoestancia
                                               FROM actividadesrealizadas
                                               WHERE codigoactividad = p_codactividad);
      IF v_cuentaregimen = 1 THEN
            RAISE_APPLICATION_ERROR (-20003, 'Actividad incluida en régimen todo incluido');
      END IF;
END TodoIncluido;
/

# Procedimiento para comprobar si un cliente ha realizado dicha actividad.
CREATE OR REPLACE PROCEDURE NoActividad (p_codcliente personas.nif%TYPE , p_codactividad actividades.codigo%TYPE)
IS
      v_cuentanoregistrado NUMBER:=0;
BEGIN
      SELECT COUNT(codigo) INTO v_cuentanoregistrado
      FROM estancias
      WHERE nifcliente = p_codcliente AND codigo = (SELECT codigoestancia
                                                    FROM actividadesrealizadas
                                                    WHERE codigoactividad =
                                                    p_codactividad);
      IF v_cuentanoregistrado = 0 THEN
            RAISE_APPLICATION_ERROR (-20004, 'El cliente no ha realizado dicha actividad');
      END IF;
END NoActividad;
/

# Procedimiento para gestionar todas las excepciones anteriores.
CREATE OR REPLACE PROCEDURE GestionExcepciones (p_codcliente personas.nif%TYPE , p_codactividad actividades.codigo%TYPE)
IS
BEGIN
        ClienteInexistente(p_codcliente);
        ActividadInexistente(p_codactividad);
        TodoIncluido(p_codactividad);
        NoActividad(p_codcliente personas.nif%TYPE , p_codactividad actividades.codigo%TYPE);
END GestionExcepciones;
/

# Función que permite comprobar si el pago ha sido abonado o no.
CREATE OR REPLACE FUNCTION ComprobarPago (p_codcliente personas.nif%TYPE , p_codactividad actividades.codigo%TYPE)
RETURN NUMBER
IS
        v_abonado NUMBER(6,2):=0;
        CURSOR c_act IS
          SELECT abonado
          FROM actividadesrealizadas
          WHERE codigoactividad = p_codactividad AND
          codigoestancia = (SELECT codigo
                           FROM estancias
                           WHERE nifcliente = p_codcliente)
          ORDER BY fecha DESC;
BEGIN
        GestionExcepciones(p_codcliente, p_codactividad);
        OPEN c_act;
        FETCH c_act INTO v_abonado;
        IF v_abonado = 0 THEN
          RETURN 0;
        ELSE
          RETURN 1;
        END IF;
        CLOSE c_act;
END ComprobarPago;
/
```

2. Realiza un procedimiento llamado ImprimirFactura que reciba un código de estancia e imprima la factura vinculada a la misma. Debes tener en cuenta que la factura tendrá el siguiente formato:

Notas: Si la estancia se ha hecho en régimen de Todo Incluido no se imprimirán los apartados de Gastos Extra o Actividades Realizadas. Del mismo modo, si en la estancia no se ha efectuado ninguna Actividad o Gasto Extra, no aparecerán en la factura.
Si una Actividad ha sido abonada in situ tampoco aparecerá en la factura.
Debes tener cuidado de facturar bien las estancias que abarcan varias temporadas.

```
# Procedimiento para comprobar si una estancias existe o no.
CREATE OR REPLACE PROCEDURE ExcepcionesFacturas (p_codestancia estancias.codigo%TYPE)
IS
      v_cuentaestancias NUMBER:=0;
BEGIN
      SELECT COUNT(codigo) INTO v_cuentaestancias
      FROM estancias
      WHERE p_codestancia = codigo;
      IF v_cuentaestancias = 0 THEN
            RAISE_APPLICATION_ERROR (-20002, 'Estancia Inexistente');
      END IF;
END ExcepcionesFacturas;
/

# Función que comprueba si una estancia está en régimen de Todo Incluido.
CREATE OR REPLACE FUNCTION ComprobarSiTI (p_codestancia estancias.codigo%TYPE)
RETURN NUMBER
AS
    CURSOR c_regimenes IS
      SELECT codigo, codigoregimen
      FROM estancias;
BEGIN
    FOR cod IN c_regimenes LOOP
      IF p_codestancia = elem.codigo AND codigoregimen = 'TI' THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    END LOOP;
END ComprobarSiTI;
/

# Función que permite calcular los días en los que permanece un cliente en una estancia.
CREATE OR REPLACE FUNCTION Calculardias (p_codestancia estancias.codigo%TYPE)
RETURN NUMBER
IS
      v_numdias NUMBER(3);
BEGIN
      SELECT (TO_CHAR(fecha_fin,'DD') - TO_CHAR(fecha_inicio,'DD')) INTO v_numdias
      FROM estancias
      WHERE p_codestancia = codigo;

      RETURN v_numdias;
END Calculardias;
/

# Función que permite averiguar la temporada en la que está una estancia.
CREATE OR REPLACE FUNCTION HallarTemp (p_codestancia estancias.codigo%TYPE)
RETURN VARCHAR2
IS
      v_fechaI DATE;
      v_fechaF DATE;
BEGIN
      SELECT fecha_inicio, fecha_fin INTO v_fechaI, v_fechaF
      FROM estancias
      WHERE p_codestancia = codigo;

      IF (TO_CHAR(v_fechaI,'MM-DD') BETWEEN '11-1' AND '12-31') OR (TO_CHAR(v_fechaI,'MM-DD') BETWEEN '1-1' AND '03-31') OR (TO_CHAR(v_fechaI,'MM-DD') BETWEEN '06-22' AND '08-31') THEN
        RETURN '02';
      ELSIF (TO_CHAR(v_fechaF,'MM-DD') BETWEEN '04-01' AND '06-21') OR (TO_CHAR(v_fechaF,'MM-DD') BETWEEN '09-01' AND '10-31') THEN
        RETURN '01';
      ELSE
        RETURN '03';
      END IF;
END HallarTemp;
/

# Función que calcula el importe de una estancia.
CREATE OR REPLACE FUNCTION CalcularImporte (p_codestancia estancias.codigo%TYPE)
RETURN NUMBER
IS
      v_preciopordia NUMBER(6,2);
      v_temp VARCHAR2(9);
BEGIN
      v_temp := HallarTemp(p_codestancia);
      SELECT preciopordia INTO v_preciopordia
      FROM tarifas
      WHERE v_temp = codigotemporada AND codigoregimen = (SELECT codigoregimen
                                                          FROM estancias
                                                          WHERE p_codestancia = codigo) AND codigotipohabitacion = (SELECT codigo
                                                                                                                    FROM habitaciones
                                                                                                                    WHERE numero = (SELECT numerohabitacion
                                                                                                                                    FROM estancias
                                                                                                                                    WHERE p_codestancia = codigo));
      RETURN v_preciopordia;
END CalcularImporte;
/

# Función que permite saber si una estancia está abonada o no.
CREATE OR REPLACE FUNCTION EstaAbonado (p_codestancia estancias.codigo%TYPE)
RETURN NUMBER
IS
    v_abonado NUMBER(6,2):=0;
    CURSOR c_act IS
      SELECT abonado
      FROM actividadesrealizadas
      WHERE p_codestancia = codigoestancia;
      ORDER BY fecha DESC;
BEGIN
    OPEN c_act;
    FETCH c_act INTO v_abonado;
    IF v_abonado = 0 THEN
      RETURN 0;
    ELSE
      RETURN 1;
    END IF;
    CLOSE c_act;
END EstaAbonado;
/

# Procedimiento que permite saber la parte referente a la información del cliente.
CREATE OR REPLACE PROCEDURE InfoCliente (p_codestancia estancias.codigo%TYPE)
IS
      v_nomcliente  personas.nombre%TYPE;
      v_apecliente  personas.apellidos%TYPE;
BEGIN
      SELECT nombre, apellidos INTO v_nomcliente, v_apecliente
      FROM personas
      WHERE nif = (SELECT nifcliente
                   FROM estancias
                   WHERE codigo = p_codestancia);
      dbms_output.put_line("Cliente: " || v_nomcliente || " " || v_apecliente);
END InfoCliente;
/

CREATE OR REPLACE PROCEDURE InfoHabitación (p_codestancia estancias.codigo%TYPE)
# Procedimiento que permite saber la parte referente a la información de la habitación.
IS
      v_numhab  estancias.numerohabitacion%TYPE;
      v_inicio  estancias.fecha_inicio%TYPE;
      v_fin     estancias.fecha_fin%TYPE;
      v_regimen estancias.codigoregimen%TYPE;
BEGIN
      SELECT numerohabitacion, fecha_inicio, fecha_fin, codigoregimen INTO v_numhab, v_inicio, v_fin, v_regimen
      FROM estancias
      WHERE p_codestancia = codigo;
      dbms_output.put_line("Número Habitación: " || v_numhab || "     " || "Fecha Inicio: " || v_inicio || "     " || "Fecha Salida: " || v_fin);
      dbms_output.put_line("Régimen de Alojamiento: " || v_regimen);
END InfoHabitación;
/

# Procedimiento que permite saber la parte referente a la información del Alojamiento.
CREATE OR REPLACE PROCEDURE InfoAlojamiento (p_codestancia estancias.codigo%TYPE)
IS
        v_temp VARCHAR2(9);
        v_numdias NUMBER(3);
        v_importe NUMBER(6,2);
BEGIN
        v_numdias := Calculardias(p_codestancia);
        v_temp := HallarTemp(p_codestancia);
        v_importe := CalcularImporte(p_codestancia);
        dbms_output.put_line("Alojamiento");
        dbms_output.put_line("------------");
        dbms_output.put_line("Temporada" || v_temp || "             Dias: " || v_numdias || "             Importe: " || v_importe * v_numdias);
        dbms_output.put_line("Importe total Alojamiento: " || v_importe * v_numdias)
END InfoAlojamiento;
/

# Procedimiento que permite saber la parte referente a la información de los gastos extras de la estancia.
CREATE OR REPLACE PROCEDURE InfoGastos (p_codestancia estancias.codigo%TYPE)
IS
        v_ti NUMBER(3);
        v_cuantiatotal NUMBER(6,2):=0;
        CURSOR c_gastos IS
          SELECT fecha, concepto, cuantia
          FROM gastos_extra
          WHERE p_codestancia = codigoestancia;
BEGIN
        v_ti := ComprobarSiTI(p_codestancia);

        IF v_ti = 1 THEN
          dbms_output.put_line("Régimen Todo Incluido. No hay gastos extras que mostrar.")
        ELSE
          dbms_output.put_line("Gastos Extra");
          dbms_output.put_line("---------------");
          FOR v_gastos IN c_gastos LOOP
            dbms_output.put_line("Fecha: " || v_gastos.fecha || "       Concepto: " || v_gastos.concepto || "         Cuantia: " || v_gastos.cuantia);
            v_cuantiatotal := v_cuantiatotal + v_gastos.cuantia;
          END LOOP;
          dbms_output.put_line("Importe total gastos: " || v_cuantiatotal);

END InfoGastos;
/

# Procedimiento que permite saber la parte referente a la información de las actividades Realizadas.
CREATE OR REPLACE PROCEDURE InfoActividades (p_codestancia estancias.codigo%TYPE)
IS
        v_ti NUMBER(3);
        v_importetotal NUMBER(6,2);
        v_abonado NUMBER(3);
        CURSOR c_actividades IS
          SELECT ar.fecha, a.nombre, ar.numpersonas, a.costepersonaparahotel
          FROM actividades a, actividadesrealizadas ar
          WHERE p_codestancia = ar.codigoestancia AND ar.codigoactividad = a.codigo;
BEGIN
        v_ti := ComprobarSiTI(p_codestancia);
        v_abonado := EstaAbonado(p_codestancia);

        IF v_ti = 1 OR v_abonado = 1 THEN
          dbms_output.put_line("Régimen Todo Incluido. No hay actividades que mostrar.")
        ELSE
          dbms_output.put_line("Actividades Realizadas");
          dbms_output.put_line("------------------------");
          FOR v_act IN c_actividades LOOP
            dbms_output.put_line("Fecha: " || v_act.fecha || "       Actividad: " || v_act.nombre || "           NumPersonas: " || v_act.numpersonas || "        Importe: " v_act.numpersonas * v_act.costepersonaparahotel);
            v_importetotal:=v_importetotal + (v_act.numpersonas * v_act.costepersonaparahotel);
          END LOOP;
          dbms_output.put_line("Importe total actividades realizadas: " || v_importetotal);
END InfoActividades;
/

# Procedimiento que muestra la factura de la estancia.
CREATE OR REPLACE PROCEDURE ImprimirFactura (p_codestancia estancias.codigo%TYPE)
IS
BEGIN
      ExcepcionesFacturas(p_codestancia);

      dbms_output.put_line("Complejo Rural La Fuente");
      dbms_output.put_line("Candelario (Salamanca)");
      dbms_output.put_line("Código Estancia: " || p_codestancia);

      InfoCliente(p_codestancia);
      InfoHabitación(p_codestancia);
      InfoAlojamiento(p_codestancia);
      InfoGastos(p_codestancia);
      InfoActividades(p_codestancia);
END ImprimirFactura;
/
```

3. Realiza un trigger que impida que haga que cuando
se inserte la realización de una actividad
asociada a una estancia en regimen TI el
campo Abonado solo puede valer -1.

```
# Procedimiento que comprueba que el campo abonado sea -1 si la estancia está en régimen de Todo Incluido.
CREATE OR REPLACE PROCEDURE Comprobación(p_abonadoantes NUMBER(1), p_abonadodespues NUMBER(1), p_codestanciaantes VARCHAR2(9), p_codestanciadespues VARCHAR2(9))
IS
      v_codregimenantes   VARCHAR2(9);
      v_codregimendespues VARCHAR2(9);
BEGIN
      SELECT codigoregimen INTO v_codregimen
      FROM estancias
      WHERE p_codestanciaantes = codigo;

      SELECT codigoregimen INTO v_codregimendespues
      FROM estancias
      WHERE p_codestanciadespues = codigo;

      IF v_codregimenantes = 'TI' AND p_abonadodespues != -1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El campo Abonado debe valer -1');
      ELSIF p_codregimendespues = 'TI' AND p_abonadoantes != -1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El tipo de regimen es incorrecto');
      ELSIF p_codregimendespues = 'TI' AND p_abonadodespues != -1 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El tipo de regimen y el del campo abonado incorrectos')
      END IF;
END Comprobación;
/

# Trigger que impide que se inserte los datos.
CREATE OR REPLACE TRIGGER ActividadTI
BEFORE INSERT OR UPDATE OF codigoestancia, abonado ON actividadesrealizadas
FOR EACH ROW
DECLARE
BEGIN
        Comprobación(:old.abonado, :new.abonado, :old.codigoestancia, :new.codigoestancia);
END ActividadTI;
/
```

4. Añade un campo email a los clientes y rellénalo para algunos de ellos. Realiza un trigger que cuando se rellene el campo Fecha de la Factura envíe por correo electrónico un resumen de la factura al cliente, incluyendo los datos fundamentales de la estancia, el importe de cada apartado y el importe total.

```
ALTER TABLE personas
ADD email VARCHAR2(30);

UPDATE personas
SET email = 'alvarodriguezeuqram@hotmail.com'
WHERE nombre = 'Alvaro' AND apellidos = 'Rodriguez Marquez';

UPDATE personas
SET email = 'leondelgado@gmail.com'
WHERE nombre = 'Aitor' AND apellidos = 'Leon Delgado';

UPDATE personas
SET email = 'adriangarcia96@hotmail.com'
WHERE nombre = 'Adrian' AND apellidos = 'Garcia Guerra';

# Función que averigua el email del usuario.
CREATE ORE REPLACE FUNCTION ObtenerCorreo (p_nombre personas.nombre%TYPE)
IS
      v_correo VARCHAR2(30);
BEGIN
      SELECT email INTO v_correo
      FROM personas
      WHERE nombre = p_nombre;

      RETURN v_correo;
END ObtenerCorreo;
/

# Procedimiento que envia un correo.
CREATE OR REPLACE PROCEDURE EnviarCorreo (p_codestancia estancias.codigo%TYPE, p_usuario personas.nombre%TYPE)
AS conexion UTL.SMTP.connection;
BEGIN
      conexion := UTL_SMTP.open_connection('smtp.gmail.com', 587);

        UTL_SMTP.helo(conexion, 'smtp.gmail.com');
        UTL_SMTP.mail(conexion, 'serviciofacturas@gmail.com');
        UTL_SMTP.rcpt(conexion, ObtenerCorreo(p_usuario));
        UTL_SMTP.data(conexion, ImprimirFactura(p_codestancia)|| UTL_TCP.crlf || UTL_TCP.crlf);
        UTL_SMTP.quit(conexion);
END EnviarCorreo;
/

# Trigger que envia un correo después de inserta el parámetro fecha en la tabla facturas.
CREATE OR REPLACE TRIGGER CorreoFecha
AFTER INSERT OF fecha ON facturas
FOR EACH ROW
BEGIN
      EnviarCorreo(:new.codigoestancia);
END;
/
```

5. Añade a la tabla Actividades una columna llamada BalanceHotel. La columna contendrá la cantidad que debe pagar el hotel a la empresa (en cuyo caso tendrá signo positivo) o la empresa al hotel (en cuyo caso tendrá signo negativo) a causa de las Actividades Realizadas por los clientes.

Realiza un procedimiento que rellene dicha columna y un trigger que la mantenga actualizada cada vez que la tabla ActividadesRealizadas sufra cualquier cambio.

Te recuerdo que cada vez que un cliente realiza una actividad, hay dos posibilidades: Si el cliente está en TI el hotel paga a la empresa el coste de la actividad. Si no está en TI, el hotel recibe un porcentaje de comisión del importe que paga el cliente por realizar la actividad.

```
ALTER TABLE actividades
ADD BalanceHotel NUMBER(6,2);

# Función que permite hallar el régimen de una estancia.
CREATE OR REPLACE FUNCTION HallarRegimen (p_codestancia estancias.codigo%TYPE)
RETURN VARCHAR2(9)
AS
      v_regimen VARCHAR2(9)
BEGIN
      SELECT codigoregimen INTO v_regimen
      FROM estancias
      WHERE codigo = p_codestancia;

      RETURN v_regimen;
END HallarRegimen;
/

# Procedimiento que permite rellenar el parámetro BalanceHotel con los datos de la tabla.
CREATE OR REPLACE PROCEDURE RellenarDatos (p_codestancia estancias.codigo%TYPE)
IS
      v_regimen VARCHAR2(9);
      CURSOR c_act IS
        SELECT ar.codigoestancia, a.BalanceHotel
        FROM actividades a, actividadesrealizadas ar
        GROUP BY ar.codigoestancia;
BEGIN
      v_regimen := HallarRegimen(p_codestancia);
      FOR v_act IN c_act LOOP
        UPDATE Actividades
          IF v_regimen = 'TI' THEN
            SET BalanceHotel = v_act.costepersonaparahotel * v_act.numpersonas * (-1)
            WHERE p_codestancia = v_act.codigoestancia;
          ELSE
            SET BalanceHotel = v_act.comisionhotel * (v_act.numpersonas * v_act.costepersonaparahotel)
            WHERE p_codestancia = v_act.codigoestancia;
          END IF;
      END LOOP;
END RellenarDatos;
/

# Trigger que actualiza los datos de la tabla actividades
CREATE OR REPLACE TRIGGER ActualizarTabla
AFTER INSERT OR UPDATE ON actividadesrealizadas
FOR EACH ROW
BEGIN
      IF INSERTING THEN
        UPDATE Actividades
          SET Bala
          WHERE BalanceHotel = new.BalanceHotel;
      ELSIF UPDATING THEN
        UPDATE actividades
          SET
          WHERE ;
      END IF;
END;
/
```

6. Realiza los módulos de programación necesarios para que una actividad no sea realizada en una fecha concreta por más de 10 personas.

```
# Creación de la tabla que recoja el codigo de la actividad realizada junto al numpersonas que la realizan.
CREATE OR REPLACE PACKAGE PkgActRealizada
AS
        TYPE tActRealiz IS RECORD
        (
            COD_ACTIVIDAD actividades.codigo%TYPE,
            FECHA_ACTIVIDAD actividadesrealizadas.fecha%TYPE,
            NUMPERSONAS_ACTIVIDAD NUMBER(6,2)
        );
        TYPE tActividadReal IS TABLE OF tActRealiz
        index by BINARY_INTEGER;

        v_ActReal tActividadReal;
END;
/

# Creamos el trigger que recoja información en un cursor.
CREATE OR REPLACE TRIGGER RellenarActividad
BEFORE INSERT ON actividadesrealizadas
DECLARE
        CURSOR c_act IS
          SELECT codigoactividad, fecha, numpersonas
          FROM actividadesrealizadas;

          i NUMBER :=0;
BEGIN
        FOR v_act IN c_act LOOP
            PkgActRealizada.v_ActReal(i).COD_ACTIVIDAD:=v_act.codigoactividad;
            PkgActRealizada.v_ActReal(i).FECHA_ACTIVIDAD:=v_act.fecha;
            PkgActRealizada.v_ActReal(i).NUMPERSONAS_ACTIVIDAD=v_act.numpersonas;
            i:=i+1;
        END LOOP;
END;
/

# Comprobación de que hay 10 personas en una actividad
CREATE OR REPLACE FUNCTION Hay10personas(p_codactividad actividades.codigo%TYPE, p_fecha actividadesrealizadas.fecha%TYPE ,p_numpersonas actividadesrealizadas.numpersonas%TYPE)
RETURN NUMBER
IS
BEGIN
        FOR i IN PkgActRealizada.v_ActReal.FIRST..PkgActRealizada.v_ActReal.LAST LOOP
          IF p_codactividad = PkgActRealizada.v_ActReal(i).COD_ACTIVIDAD AND p_fecha = PkgActRealizada.v_ActReal(i).FECHA_ACTIVIDAD AND (p_numpersonas = PkgActRealizada.v_ActReal(i).NUMPERSONAS_ACTIVIDAD AND p_numpersonas > 10)
              RETURN 1;
          ELSE
              RETURN 0;
          END IF;
        END LOOP;
END;
/

# Procedimiento para introducir una nueva fila.
CREATE OR REPLACE PROCEDURE CrearFilaNueva(p_codactividad actividades.codigo%TYPE, p_fecha actividadesrealizadas.fecha%TYPE ,p_numpersonas actividadesrealizadas.numpersonas%TYPE)
IS
BEGIN
        PkgActRealizada.v_ActReal(PkgActRealizada.v_ActReal.LAST+1).COD_ACTIVIDAD := p_codactividad;
        PkgActRealizada.v_ActReal(PkgActRealizada.v_ActReal.LAST+1).FECHA_ACTIVIDAD := p_fecha;
        PkgActRealizada.v_ActReal(PkgActRealizada.v_ActReal.LAST+1).NUMPERSONAS_ACTIVIDAD := p_numpersonas;
END CrearFilaNueva;
/

# Trigger que comprueba todo lo anterior.
CREATE OR REPLACE TRIGGER Comprobación
BEFORE INSERT ON actividadesrealizadas
FOR EACH ROW
DECLARE
          v_hay10personas NUMBER:=0;
BEGIN
          v_hay10personas := Hay10personas(:new.codigoactividad,:new.fecha,:new.numpersonas);
          IF v_hay10personas = 1 THEN
                RAISE_APPLICATION_ERROR(-20006, 'Hay más de 10 personas realizando dicha actividad');
          ELSE
                CrearFilaNueva(:new.codigoactividad,:new.fecha,:new.numpersonas);
          END IF;
END;
/
```

7. Realiza los módulos de programación necesarios para que los precios de un mismo tipo de habitación en una misma temporada crezca en función de los servicios ofrecidos de esta forma: Precio TI > Precio PC > Precio MP > Precio AD.

```


```

8. Realiza los módulos de programación necesarios para que un cliente no pueda realizar dos estancias que se solapen en fechas entre ellas, esto es, un cliente no puede comenzar una estancia hasta que no haya terminado la anterior.

```

```
