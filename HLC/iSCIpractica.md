# Práctica iSCSI

Configura un escenario con vagrant o similar que incluya varias máquinas que 
permita realizar la configuración de un servidor iSCSI y dos clientes 
(uno linux y otro windows). Explica de forma detallada en la tarea los 
pasos realizados.

   
* Crea un target con una LUN y conéctala a un cliente GNU/Linux. Explica cómo 
escaneas desde el cliente buscando los targets disponibles y utiliza la 
unidad lógica proporcionada, formateándola si es necesario y montándola.
   
* Utiliza systemd mount para que el target se monte automáticamente al 
arrancar el cliente
   
* Crea un target con 2 LUN y autenticación por CHAP y conéctala a un cliente 
windows. Explica cómo se escanea la red en windows y cómo se utilizan las 
unidades nuevas (formateándolas con NTFS)

Nota: Es posible realizar esta tarea en un entorno virtual y corregirlo en 
clase o alternativamente montar un playbook con ansible que configure todo 
el escenario de forma automática y permita corregirlo a distancia montándolo 
desde cero.

