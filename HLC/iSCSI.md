# iSCSI

Proporciona acceso a dispositivos de bloques sobre TCP/IP. Este se utiliza
fundamentalmente en redes de almacenamiento. 

Es una alternativa económica a Fibre Channel. Utilizado típicamente en redes
de cobre de 1 Gbps o 10 Gbps.

Elementos de iSCSI:

* Una unidad lógica (dispositivo de bloques) a compartir por el servidor iSCSI.

* Un recurso a compartir desde el servidor llamado Target. Incluye uno o varias
unidades lógicas.

* Initiator --> cliente iSCSI

* Multipath --> si hay más de una ruta entre el Target y el initiator, 
garantiza la conexión por una ruta sí o sí.

* IQN es el formato para la descripción de los recursos.

* iSNS es el protocolo que permite gestionar recursos iSCSI como si fueran
Fibre Channel.

iSCSI tiene soporte en la mayoría de SO. En Linux usamos _open-iscsi_ como
initiator. Tenemos varias opciones:

* Linux-IO

* tgt

* scst


