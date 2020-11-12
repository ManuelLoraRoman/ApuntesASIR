# Virsh

## Conexión al hipervisor

En caso de utilizar qemu-kvm podemos establecer una conexión no privilegiada
con cada usuario del sistema (qemu:///session) o una privilegiada (qemu:///system)


```
manuel@debian:~$ virsh -c qemu:///system
Welcome to virsh, the virtualization interactive terminal.

Type:  'help' for help with commands
       'quit' to quit

virsh # 
```

Podemos usar la orden _help_ para que nos dé información de los comandos que 
podemos utilizar.

## Configuración inicial

* ```virsh -c qemu:///session list --all``` --> lista las máquinas virtuales

* ```virsh -c qemu:///system net-create .xml```

* ```virsh -c qemu:///system net-start ...```
