# Métodos de virtualización


## Libvirt

Comandos importantes:

```virsh -c qemu:///session o virsh -c qemu:///system```

Para usar system sin necesidad de poner la contraseña, debemos añadir nuestro 
usuario en el grupo _libvirt_ con el comando _adduser_.

```
virsh -c qemu+ssh://root@io/system

virsh -c qemu+ssh://root@io/system list --all

virsh -c qemu:///system net-list --all

virsh -c qemu:///system net-undefine .....

virsh -c qemu:///system net-destroy .....

virsh -c qemu:///system net-info ......

virsh -c qemu:///system net-edit .......

virsh -c qemu:///system net-create .......

virsh -c qemu:///system net-dhcp-leases .......

```

