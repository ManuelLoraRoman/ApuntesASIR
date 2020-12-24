# Práctica Usuarios

## Oracle

1. Crea un rol ROLPRACTICA1 con los privilegios necesarios para conectarse a 
la base de datos, crear tablas y vistas e insertar datos en la tabla EMP de 
SCOTT.

2. Crea un usuario USRPRACTICA1 con el tablespace USERS por defecto y 
averigua que cuota se le ha asignado por defecto en el mismo. Sustitúyela por 
una cuota de 1M.

3. Modifica el usuario USRPRACTICA1 para que tenga cuota 0 en el tablespace 
SYSTEM.

4. Concede a USRPRACTICA1 el ROLPRACTICA1.

5. Concede a USRPRACTICA1 el privilegio de crear tablas e insertar datos en el esquema de cualquier usuario. Prueba el privilegio. Comprueba si puede 
modificar la estructura o eliminar las tablas creadas.

6. Concede a USRPRACTICA1 el privilegio de leer la tabla DEPT de SCOTT con la 
posibilidad de que lo pase a su vez a terceros usuarios.

7. Comprueba que USRPRACTICA1 puede realizar todas las operaciones previstas 
en el rol.

8. Quita a USRPRACTICA1 el privilegio de crear vistas. Comprueba que ya no 
puede hacerlo.

9. Crea un perfil NOPARESDECURRAR que limita a dos el número de minutos de 
inactividad permitidos en una sesión.

10. Activa el uso de perfiles en ORACLE.

11. Asigna el perfil creado a USRPRACTICA1 y comprueba su correcto 
funcionamiento.

12. Crea un perfil CONTRASEÑASEGURA especificando que la contraseña caduca mensualmente y sólo se permiten tres intentos fallidos para acceder a la 
cuenta. En caso de superarse, la cuenta debe quedar bloqueada indefinidamente.

13. Asigna el perfil creado a USRPRACTICA1 y comprueba su funcionamiento. 
Desbloquea posteriormente al usuario.

14. Consulta qué usuarios existen en tu base de datos.

15. Elige un usuario concreto y consulta qué cuota tiene sobre cada uno de 
los tablespaces.

16. Elige un usuario concreto y muestra qué privilegios de sistema tiene 
asignados.

17. Elige un usuario concreto y muestra qué privilegios sobre objetos tiene 
asignados.

18. Consulta qué roles existen en tu base de datos.

19. Elige un rol concreto y consulta qué usuarios lo tienen asignado.

20. Elige un rol concreto y averigua si está compuesto por otros roles o no.

21. Consulta qué perfiles existen en tu base de datos.

22. Elige un perfil y consulta qué límites se establecen en el mismo.

23. Muestra los nombres de los usuarios que tienen limitado el número de 
sesiones concurrentes.

24. Realiza un procedimiento que reciba un nombre de usuario y un privilegio de sistema y nos muestre el mensaje 'SI, DIRECTO' si el usuario tiene ese privilegio concedido directamente, 'SI, POR ROL' si el usuario tiene ese privilegio en alguno de los roles que tiene concedidos y un 'NO' si el usuario no tiene dicho privilegio.

25. Realiza un procedimiento llamado MostrarNumSesiones que reciba un nombre 
de usuario y muestre el número de sesiones concurrentes que puede tener abiertas
como máximo y las que tiene abiertas realmente.

26. (ORACLE, Postgres) Realiza un procedimiento que reciba dos nombres de 
usuario y genere un script que asigne al primero los privilegios de inserción 
y modificación sobre todas las tablas del segundo, así como el de ejecución 
de cualquier procedimiento que tenga el segundo usuario.

## Postgres

27. Averigua que privilegios de sistema hay en Postgres y como se asignan a 
un usuario.

28. Averigua cual es la forma de asignar y revocar privilegios sobre una 
tabla concreta en Postgres.

29. Averigua si existe el concepto de rol en Postgres y señala las diferencias
con los roles de ORACLE.

30. Averigua si existe el concepto de perfil como conjunto de límites sobre 
el uso de recursos o sobre la contraseña en Postgres y señala las diferencias 
con los perfiles de ORACLE.

31. Realiza consultas al diccionario de datos de Postgres para averiguar 
todos los privilegios que tiene un usuario concreto.

32. Realiza consultas al diccionario de datos en Postgres para averiguar qué 
usuarios pueden consultar una tabla concreta.

