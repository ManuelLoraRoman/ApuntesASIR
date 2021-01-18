# Instalación y configuración básica de VMWare ESXi

Utiliza el servidor físico que se te haya asignado e instala la versión 
adecuada del sistema de virtualización VMWare ESXi (ten en cuenta que recibe 
diferentes denominaciones comerciales, pero nos referimos al sistema de 
virtualización de VMWare que proporciona virtualización de alto rendimiento 
mediante la técnica de la paravirtualización).

Realiza la configuración del servicio que permita su gestión remota desde un 
equipo cliente e instala en tu equipo la aplicación cliente que permita 
gestionar remotamente el hipervisor.

Instala una máquina virtual que tenga acceso a Internet. La corrección 
consistirá en comprobar el funcionamiento de dicha máquina virtual.

En primer lugar, procedemos a la configuración de la BIOS para cambiar la IP.

![alt text](../Imágenes/vmw3.jpg)

![alt text](../Imágenes/vmw4.jpg)

![alt text](../Imágenes/vmw5.jpg)

La última foto representa el cambio de la IP estática a la 172.22.221.053 pero
realmente se volvió a cambiar y tenemos actualmente la IP 172.22.221.67.

Reiniciamos el sistema para guardar los cambios en la BIOS e introducimos la
unidad extraíble con la correspondiente versión de VMWare.

![alt text](../Imágenes/vmw7.jpg)

![alt text](../Imágenes/vmw8.jpg)

Y pasará a la instalación de VMWare:

![alt text](../Imágenes/vmw10.jpg)

Seleccionamos un disco para la instalación:

![alt text](../Imágenes/vmw12.jpg)

Y elegimos la opción de instalar la versión de VMWare ESXi y sobreescribir el 
almacén de datos.

![alt text](../Imágenes/vmw14.jpg)

Seleccionamos el diseño del teclado (Spanish) y continuamos:

![alt text](../Imágenes/vmw16.jpg)

Introducimos la contraseña del root y dejamos que continue con la instalación:

![alt text](../Imágenes/vmw18.jpg)

![alt text](../Imágenes/vmw19.jpg)

Nos pedirá que confirmemos la instalación y dejamos que instale:

![alt text](../Imágenes/vmw20.jpg)

![alt text](../Imágenes/vmw21.jpg)

![alt text](../Imágenes/vmw22.jpg)

Y reiniciamos:

![alt text](../Imágenes/vmw23.jpg)

![alt text](../Imágenes/vmw25.jpg)

![alt text](../Imágenes/vmw26.jpg)

Una vez estemos aquí, pulsamos F2 para cambiar la IP estática:

![alt text](../Imágenes/vmw27.jpg)

![alt text](../Imágenes/vmw28.jpg)

Y guardamos los cambios. (Como hemos dicho anteriormente, la IP actual es la
172.22.221.67)

Ahora que ya tenemos configurado VMWare, podremos acceder remotamente para
configurar la máquina virtual.

Nos metemos en el navegador web e introducimos la IP que hemos configurado
anteriormente:

![alt text](../Imágenes/vmware1.png)

Nos pedirá iniciar sesión:

![alt text](../Imágenes/vmware2.png)

Y una vez dentro, nos dirigimos a _Crear/Registrar máquina virtual_. Nos 
aparecerá la siguiente ventana y seleccionamos la opción de crear una máquina
virtual.

![alt text](../Imágenes/vmware3.png)

![alt text](../Imágenes/vmware4.png)

Introducimos los datos correspondientes al nombre de la máquina virtual, 
y el sistema que queremos instalar. A continuación, nos aparecerá la
configuración la cual podemos editar a nuestro gusto. En nuestro caso, como 
vamos a instalar un Debian 10 sin entorno gráfico, dejaremos las opciones
que vienen de manera predeterminada exceptuando la opción de unidad de CD,
el cual elegiremos la opción de _Archivo ISO del almacén de datos_ y 
elegimos la iso de Debian 10 que nos hemos descargado previamente.

![alt text](../Imágenes/vmware5.png)

Y ya estaría:

![alt text](../Imágenes/vmware6.png)

Acto seguido, se procederá a la instalación de Debian 10 en esa máquina virtual,
pero nos encontramos con el problema que necesitamos una consola para acceder
remotamente a dicha máquina virtual. Para ello nos descargamos el siguiente
archivo de la paǵina de VMWare:

![alt text](../Imágenes/vmware8.png)

Y nos descargamos la versión para Linux. Después ejecutamos la siguiente
instrucción:

```
sh VMWare-Remote-Console-12.0.0-17287072.x86_64.bundle
```

Y nos aparecerá la siguiente ventana de instalación:

![alt text](../Imágenes/vmware9.png)

![alt text](../Imágenes/vmware10.png)

![alt text](../Imágenes/vmware11.png)

Y una vez configurado, ya estaría listo para instalar:

![alt text](../Imágenes/vmware12.png)

![alt text](../Imágenes/vmware13.png)

Y una vez ya está instalado, accedemos mediante dicha herramienta a la máquina
para su instalación.

La comprobación de la máquina funcionando remotamente en VMWare:

![alt text](../Imágenes/vmware14.png)
