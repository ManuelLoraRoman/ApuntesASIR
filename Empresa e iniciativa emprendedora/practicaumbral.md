# Práctica Umbral de Rentabilidad

En esta práctica se propone hacer una estimación de los costes de la empresa 
para calcular el umbral de rentabilidad.  En este sentido, entendemos que es 
un ejercicio práctico y en la realidad estos datos están sujetos a muchas 
más variables ya que los datos son siempre dinámicos.

En esta práctica se trata pues de recoger los siguientes datos:

* Costes Fijos

* Costes Variables

* Costes Totales

* Coste Marginal

* Umbral de rentabilidad

 
Tras el cálculo de rentabilidad, debemos responder a la pregunta: 

¿Con qué nivel de producción la empresa produce beneficios? ¿Y pérdidas? 


No vamos a contabilizar las inversiones en el coste fijo, ya que es un
coste inicial, por lo tanto cogemos solamente los gastos:

* Costes fijos = Gastos (Alquiler, gestoria, publicidad, recibos respectivamente)

```
Costes Fijos = 600 + 300 + 500 + 180 = 1580 €
```

Para calcular los costes variables, necesitamos saber la cantidad vendida del
servicio y lo que cuesta realizar dicho servicio.

Como nuestra empresa se encarga de ofrecer un servicio, vamos a seleccionar
el coste de realizar el trabajo que son unos 9,25 €/hora. Adicionalmente,
habría que multiplicar los costes variables por las respectivas horas 
trabajadas:

```
CV(0) = 9,25 * 0 = 0 €
CV(1) = 9,25 * 1 = 9,25 €
CV(2) = 9,25 * 2 = 18,5 €
CV(5) = 9,25 * 5 = 46,25 €
CV(10) = 9,25 * 10 = 92,5 €
CV(20) = 9,25 * 20 = 185 €
CV(25) = 9,25 * 25 = 231,25 €
```

* Costes totales = CF + CV

```
CT(0) = 1580 + 0 = 1580 €
CT(1) = 1580 + 9,25 = 1589,25 €
CT(2) = 1580 + 18,5 = 1598,5 €
CT(5) = 1580 + 46,25 = 1626,25 €
CT(10) = 1580 + 92,5 = 1672,5 €
CT(20) = 1580 + 185 = 1765 €
CT(25) = 1580 + 231,25 = 1811,25 €
```

* Coste Marginal = Incremento CT / Incremento de la cantidad

```
CMg(0) = 1580 - 0 = 1580 €
CMg(1) = 1589,25 - 1580 = 9,25 €
CMg(2) = 1598,25 - 1589,25 = 9,25 €
.
.
.
CMg(25) = 1811,25 - (CT(24) = 1580 + 222 = 1802) = 9,25 €
```

* Umbral de rentabilidad

Para el precio de venta cogeremos el _plan básico de gestión_ como ejemplo
y este tiene un precio estimado de 2000 €.

Ingresos totales = Precio de venta * Q

```
IT(0) = 2000 * 0 = 0 €
IT(1) = 2000 * 1 = 2000 €
IT(2) = 2000 * 2 = 4000 €
IT(5) = 2000 * 5 = 10000 €
IT(10) = 2000 * 10 = 20000 €
IT(20) = 2000 * 20 = 40000 €
IT(25) = 2000 * 25 = 50000 €
```

Beneficio = IT - CT (Costes totales)

```
B(0) = 0 - 1580 = -1580 €
B(1) = 2000 - 1589,25 = 410,75 €
B(2) = 4000 - 1598,5 = 2401,5 €
B(5) = 10000 - 1626,25 = 8373,75 €
B(10) = 20000 - 1672,5 = 18327,5 €
B(20) = 40000 - 1765 = 38235 €
B(25) = 50000 - 1811,25 = 48188,75 € 
```

Empezaremos a obtener beneficio técnicamente a partir del primer cliente
dependiendo de las horas trabajadas en dicho cliente.
