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

## Demo y comandos

Creación de dos máquinas y a una de ellas se le ha asignado 3 dispositivos de
bloques. Usaremos tgt para el server y open-iscsi para el cliente.

```
tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2020-01.es.tinaja:target1

tgtadm --lld iscsi --op delete --mode target --tid 1

tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b /dev/vdb
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 2 -b /dev/vdc
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 2 -b /dev/vdd

tgtadm --lld iscsi --op show --mode target

tgtadm --lld iscsi --op bind --mode target --tid 1 -I ALL

El initiator se encuentra _/etc/iscsi/initiatorname.iscsi_.

iscsiadm --mode discovery --type sendtargets --portal iscsi1

iscsiadm --mode node -T iqn.2020-01.es.tinaja:target1 --portal iscsi1 --login

Y cuando haces un lsblk tienes los tres dispositivos configurados anteriormente.
```


