# Compilación de un kérnel linux a medida


Al ser linux un kérnel libre, es posible descargar el código fuente, 
configurarlo y comprimirlo. Además, esta tarea a priori compleja, es más 
sencilla de lo que parece gracias a las herramientas disponibles.

En esta tarea debes tratar de compilar un kérnel completamente funcional que 
reconozca todo el hardware básico de tu equipo y que sea a la vez lo más 
pequeño posible, es decir que incluya un vmlinuz lo más pequeño posible y que 
incorpore sólo los módulos imprescindibles. Para ello utiliza el método 
explicado en clase y entrega finalmente el fichero deb con el kérnel 
compilado por ti.

El hardware básico incluye como mínimo el teclado, la interfaz de red y la 
consola gráfica (texto).

**Procedimiento a seguir:**

1. Instala el paquete linux-source correspondiente al núcleo que estés usando 
en tu máquina.

2. Crea un directorio de trabajo (p.ej. mkdir ~/Linux).

3. Descomprime el código fuente del kérnel dentro del directorio de trabajo:

```tar xf /usr/src/linux-source-... ~/Linux/```

4. Utiliza como punto de partida la configuración actual del núcleo:

```make oldconfig```

5. Cuenta el número de componentes que se han configurado para incluir en 
vmlinuz o como módulos.

6. Configura el núcleo en función de los módulos que está utilizando tu equipo 
(para no incluir en la compilación muchos controladores de dispositivos que 
no utiliza el equipo):

```make localmodconfig```

7. Vuelve a contar el número de componentes que se han configurado para incluir 
en vmlinuz o como módulos.

8. Realiza la primera compilación:

```make -j <número de hilos> bindeb-pkg```

9. Instala el núcleo resultando de la compilación, reinicia el equipo y 
comprueba que funciona adecuadamente.

10. Si ha funcionado adecuadamente, utilizamos la configuración del paso 
anterior como punto de partida y vamos a reducir el tamaño del mismo, para 
ello vamos a seleccionar elemento a elemento.

```
cp /boot/config-... .config
make clean
make xconfig
```
   
11. Vuelve a contar el número de componentes que se han configurado para 
incluir en vmlinuz o como módulos.

12. Vuelve a compilar:

```make -j <número de hilos> bindeb-pkg```

13. Si se produce un error en la compilación, vuelve al paso de configuración, 
si la compilación termina correctamente, instala el nuevo núcleo y comprueba 
el arranque.

14. Continuamos reiterando el proceso poco a poco hasta conseguir el núcleo lo 
más pequeño posible que pueda arrancar en nuestro equipo.

