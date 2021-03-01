# Instalación y Configuración de Openstack

Selecciona un método de instalación de OpenStack entre los explicados en clase 
o alguna alternativa que encuentres e instala una nube privada que tenga al 
menos un nodo controlador y un nodo de computación y los siguientes componentes 
de OpenStack:
 
 - Keystone
 - Nova
 - Glance
 - Cinder
 - Neutron

La prueba de funcionamiento debe incluir el lanzamiento de una máquina, que 
esta máquina tenga acceso al exterior, que se pueda crear un volumen y 
asociarlo a la instancia.

Documentación recogida de : 

* [Página de kolla-ansible](https://docs.openstack.org/project-deploy-guide/kolla-ansible/victoria/quickstart.html)

La opción que hemos elegido para instalar Openstack es la utilización de
_Kolla Ansible_. Para proceder a la instalación, vamos a montar un escenario
en vagrant en el cual crearemos tres máquinas: uno donde instalaremos 
Openstack, otro que sirva como controlador y otro adicional.

El fichero vagrant tendrá la siguiente estructura:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :installer do |installer|
    installer.vm.box = "ubuntu/bionic64"
    installer.vm.hostname = "installer"
    installer.vm.network :public_network, :bridge=>"wlp2s0"
    installer.vm.network :private_network, ip: "10.0.1.2", virtualbox__intnet: "redinterna"
  end
  config.vm.define :master do |master|
    master.vm.box = "ubuntu/bionic64"
    master.vm.hostname = "master"
    master.vm.network :public_network, :bridge=>"wlp2s0"
    master.vm.network :private_network, ip: "10.0.1.3", virtualbox__intnet: "redinterna"
    master.vm.network :public_network, :bridge=>"wlp2s0"
    master.vm.provider "virtualbox" do |mv|
      mv.customize ["modifyvm", :id, "--memory", "6144"]
      mv.customize ["modifyvm", :id, "--nic2", "intnet"]
    end
  end
  config.vm.define :compute do |compute|
    compute.vm.box = "ubuntu/bionic64"
    compute.vm.hostname = "compute"
    compute.vm.network :public_network, :bridge=>"wlp2s0"
    compute.vm.network :private_network, ip: "10.0.1.4", virtualbox__intnet: "redinterna"
    compute.vm.provider "virtualbox" do |mv|
      mv.customize ["modifyvm", :id, "--memory", "3072"]
    end
  end
end
```

Y procedemos a la creación de las máquinas. Una vez haya acabado la creación,
tendríamos las siguientes máquinas:

![alt text](../Imágenes/vmopenstack.png)

A continuación, nos conectaremos por _vagrant ssh_ a las diferentes máquinas y
comprobamos las diferentes interfaces red que vamos a tener:

* Installer

```
vagrant@installer:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:a4:4a:b3:a7:36 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 78230sec preferred_lft 78230sec
    inet6 fe80::a4:4aff:feb3:a736/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a0:f7:c5 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.49/24 brd 192.168.0.255 scope global dynamic enp0s8
       valid_lft 78231sec preferred_lft 78231sec
    inet6 fe80::a00:27ff:fea0:f7c5/64 scope link 
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:fc:da:a1 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.2/24 brd 10.0.1.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fefc:daa1/64 scope link 
       valid_lft forever preferred_lft forever
```

* Master

```
vagrant@master:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:a4:4a:b3:a7:36 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 78246sec preferred_lft 78246sec
    inet6 fe80::a4:4aff:feb3:a736/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master ovs-system state UP group default qlen 1000
    link/ether 08:00:27:a6:29:f5 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::a00:27ff:fea6:29f5/64 scope link 
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:6d:bd:fd brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.3/24 brd 10.0.1.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet 10.0.1.254/32 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet 192.168.0.55/32 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe6d:bdfd/64 scope link 
       valid_lft forever preferred_lft forever
5: enp0s10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:22:56:ab brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.50/24 brd 192.168.0.255 scope global dynamic enp0s10
       valid_lft 78247sec preferred_lft 78247sec
    inet6 fe80::a00:27ff:fe22:56ab/64 scope link 
       valid_lft forever preferred_lft forever
6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:9f:ce:fc:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
7: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b6:f8:dc:ca:7b:d3 brd ff:ff:ff:ff:ff:ff
8: br-ex: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 08:00:27:a6:29:f5 brd ff:ff:ff:ff:ff:ff
9: br-int: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 6e:54:13:32:e1:46 brd ff:ff:ff:ff:ff:ff
10: br-tun: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether e2:69:d4:29:86:41 brd ff:ff:ff:ff:ff:ff
```

* Compute

```
vagrant@compute:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:a4:4a:b3:a7:36 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 78259sec preferred_lft 78259sec
    inet6 fe80::a4:4aff:feb3:a736/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:61:ba:b8 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.51/24 brd 192.168.0.255 scope global dynamic enp0s8
       valid_lft 78260sec preferred_lft 78260sec
    inet6 fe80::a00:27ff:fe61:bab8/64 scope link 
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:65:08:eb brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.4/24 brd 10.0.1.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe65:8eb/64 scope link 
       valid_lft forever preferred_lft forever
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:e8:14:17:5e brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
6: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 9e:7b:43:ff:e8:ef brd ff:ff:ff:ff:ff:ff
7: br-int: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 7e:eb:9a:4d:d0:46 brd ff:ff:ff:ff:ff:ff
8: br-tun: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 3e:8b:84:5d:6b:4e brd ff:ff:ff:ff:ff:ff
```

Actualizamos, haciendo ```apt update && apt upgrade``` las tres máquinas.
Hecho esto, en nuestra máquina _installer_ nos descargaremos los siguientes
paquetes y dependencias:

```
sudo apt-get install python3-dev libffi-dev gcc libssl-dev
```

En la máquina _installer_ creamos un entorno virtual. Para ello, vamos a
descargarnos el paquete _python3-venv_ y despúes procedemos a la
creación del entorno virtual:

```
sudo apt install python3-venv

vagrant@installer:~$ python3 -m venv openstack
vagrant@installer:~$ source openstack/bin/activate
(openstack) vagrant@installer:~$ 
```

Ahora instalaremos el paquete _pip_ y _ansible_ con el comando pip:

```
pip install -U pip

pip install 'ansible<2.10'
```

Después de instalar los paquetes comentados anteriormente, procedemos a instalar
el paquete _kolla-ansible_:

```
pip install kolla-ansible
```

Creamos los directorios pertinentes para los componentes de Kolla:

```
(openstack) vagrant@installer:~$ sudo mkdir -p /etc/kolla
(openstack) vagrant@installer:~$ sudo chown $USER:$USER /etc/kolla
```

Ahora copiaremos los ficheros del directorio de ejemplo hacia el nuevo
directorio:

```
(openstack) vagrant@installer:~$ cp -r openstack/share/kolla-ansible/etc_examples/kolla/* /etc/kolla/
```

También, copiaremos los ficheros del inventario para el multinodo:

```
(openstack) vagrant@installer:~$ cp openstack/share/kolla-ansible/ansible/inventory/* .
```

Y nos quedaría algo así:

```
(openstack) vagrant@installer:~$ ls
all-in-one  multinode  openstack
(openstack) vagrant@installer:~$ ls /etc/kolla/
globals.yml  passwords.yml
```

Para la configuración de _Ansible_ vamos a crear el directorio _/etc/ansible/_
y el fichero de configuración _ansible.cfg:

```
(openstack) vagrant@installer:~$ sudo mkdir /etc/ansible
(openstack) vagrant@installer:~$ sudo nano /etc/ansible/ansible.cfg

[defaults]
host_key_checking=False
pipelining=True
forks=100

(openstack) vagrant@installer:~$ sudo chown $USER:$USER /etc/ansible
```

A continuación, vamos al fichero _multinode_ y vamos a modificar las 
siguientes líneas:

```
[control]
master ansible_user=root ansible_password=1q2w3e4r5t

[network:children]
master

[compute]
compute ansible_user=root ansible_password=1q2w3e4r5t

[monitoring]
master

[storage:children]
master

[deployment]
localhost       ansible_connection=local
```

Y comprobamos que podemos hacerle ping a las diferentes máquinas de nuestro 
escenario:

```
(openstack) vagrant@installer:~$ ansible -i multinode all -m ping
[WARNING]: Invalid characters were found in group names but not replaced, use
-vvvv to see details
[WARNING]: Found both group and host with same name: compute
localhost | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
compute | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
master | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

Una vez hecho esto, para que kolla tenga las contraseñas, vamos a ejecutar
el siguiente comando:

```
(openstack) vagrant@installer:~$ kolla-genpwd
```

Dichas contraseñas se guardan en el directorio _/etc/kolla/passwords.yml_.
En dicho directorio también encontraremos el fichero _globals.yml_ el
cual debemos editar con la siguiente información:

```
###############
# Kolla options
###############

# Valid options are ['centos', 'debian', 'rhel', 'ubuntu']
kolla_base_distro: "ubuntu"

# Valid options are [ binary, source ]
kolla_install_type: "binary"

# Do not override this unless you know what you are doing.
openstack_release: "victoria"

kolla_internal_vip_address: "10.0.1.254"

kolla_external_vip_address: "192.168.0.55"

##############################
# Neutron - Networking Options
##############################

network_interface: "enp0s9"

neutron_external_interface: "enp0s8"

###################
# OpenStack options
###################

enable_cinder: "yes"
enable_cinder_backup: "yes"

########################
# Nova - Compute Options
########################

nova_compute_virt_type: "qemu"

```

Configurado este fichero, vamos a preparar el _deployment_. Para ello, vamos a
ejecutar el siguiente comando:

```
kolla-ansible -i multinode bootstrap-servers
```

Esto proporciona soporte para las siguientes tareas en los demás nodos:

* Customización del fichero _/etc/hosts_.

* Creación del usuario y grupo.

* Configuración del directorio Kolla.

* Instalación y borrado de paquetes.

* Instalación y configuración de Docker.

* Desactivar firewalld.

* Creación del entorno virtual de python.

* Configuración de AppArmor.

* Configuración de SELinux.

* Configuración del demonio NTP.


Cuando haya terminado, pasamos el siguiente check antes del _deployment_:

```
kolla-ansible -i multinode prechecks
```

Y si no ha habido ningún error en los pasos anteriores, pasaremos al 
deployment:

```
(openstack) vagrant@installer:~$ kolla-ansible -i multinode deploy
.
.
.
.
TASK [Deploy horizon container] ****************************************************************************************
changed: [master] => (item={'key': 'horizon', 'value': {'container_name': 'horizon', 'group': 'horizon', 'enabled': True, 'image': 'kolla/ubuntu-binary-horizon:victoria', 'environment': {'ENABLE_BLAZAR': 'no', 'ENABLE_CLOUDKITTY': 'no', 'ENABLE_DESIGNATE': 'no', 'ENABLE_FREEZER': 'no', 'ENABLE_HEAT': 'yes', 'ENABLE_IRONIC': 'no', 'ENABLE_KARBOR': 'no', 'ENABLE_MAGNUM': 'no', 'ENABLE_MANILA': 'no', 'ENABLE_MASAKARI': 'no', 'ENABLE_MISTRAL': 'no', 'ENABLE_MONASCA': 'no', 'ENABLE_MURANO': 'no', 'ENABLE_NEUTRON_VPNAAS': 'no', 'ENABLE_OCTAVIA': 'no', 'ENABLE_QINLING': 'no', 'ENABLE_SAHARA': 'no', 'ENABLE_SEARCHLIGHT': 'no', 'ENABLE_SENLIN': 'no', 'ENABLE_SOLUM': 'no', 'ENABLE_TACKER': 'no', 'ENABLE_TROVE': 'no', 'ENABLE_VITRAGE': 'no', 'ENABLE_WATCHER': 'no', 'ENABLE_ZUN': 'no', 'FORCE_GENERATE': 'no'}, 'volumes': ['/etc/kolla/horizon/:/var/lib/kolla/config_files/:ro', '', '', '', '/etc/localtime:/etc/localtime:ro', '/etc/timezone:/etc/timezone:ro', 'kolla_logs:/var/log/kolla/', '/tmp:/tmp'], 'dimensions': {}, 'healthcheck': {'interval': '30', 'retries': '3', 'start_period': '5', 'test': ['CMD-SHELL', 'healthcheck_curl http://10.0.1.3:80'], 'timeout': '30'}, 'haproxy': {'horizon': {'enabled': True, 'mode': 'http', 'external': False, 'port': '80', 'listen_port': '80', 'frontend_http_extra': ['use_backend acme_client_back if { path_reg ^/.well-known/acme-challenge/.+ }'], 'backend_http_extra': ['balance source'], 'tls_backend': 'no'}, 'horizon_redirect': {'enabled': False, 'mode': 'redirect', 'external': False, 'port': '80', 'listen_port': '80'}, 'horizon_external': {'enabled': True, 'mode': 'http', 'external': True, 'port': '80', 'listen_port': '80', 'frontend_http_extra': ['use_backend acme_client_back if { path_reg ^/.well-known/acme-challenge/.+ }'], 'backend_http_extra': ['balance source'], 'tls_backend': 'no'}, 'horizon_external_redirect': {'enabled': False, 'mode': 'redirect', 'external': True, 'port': '80', 'listen_port': '80'}, 'acme_client': {'enabled': True, 'with_frontend': False, 'custom_member_list': []}}}})TASK [horizon : include_tasks] *****************************************************************************************
skipping: [master]TASK [horizon : include_tasks] *****************************************************************************************
skipping: [master]RUNNING HANDLER [Restart horizon container] ****************************************************************************
changed: [master]
[WARNING]: Could not match supplied host pattern, ignoring: enable_murano_TruePLAY [Apply role murano] ***********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_solum_TruePLAY [Apply role solum] ************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_magnum_TruePLAY [Apply role magnum] ***********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_mistral_TruePLAY [Apply role mistral] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_qinling_TruePLAY [Apply role qinling] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_sahara_TruePLAY [Apply role sahara] ***********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_panko_TruePLAY [Apply role panko] ************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_manila_TruePLAY [Apply role manila] ***********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_gnocchi_TruePLAY [Apply role gnocchi] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_ceilometer_TruePLAY [Apply role ceilometer] *******************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_monasca_TruePLAY [Apply role monasca] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_aodh_TruePLAY [Apply role aodh] *************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_barbican_TruePLAY [Apply role barbican] *********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_cyborg_TruePLAY [Apply role cyborg] ***********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_tempest_TruePLAY [Apply role tempest] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_designate_TruePLAY [Apply role designate] ********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_rally_TruePLAY [Apply role rally] ************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_vmtp_TruePLAY [Apply role vmtp] *************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_trove_TruePLAY [Apply role trove] ************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_watcher_TruePLAY [Apply role watcher] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_grafana_TruePLAY [Apply role grafana] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_cloudkitty_TruePLAY [Apply role cloudkitty] *******************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_freezer_TruePLAY [Apply role freezer] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_senlin_TruePLAY [Apply role senlin] ***********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_searchlight_TruePLAY [Apply role searchlight] ******************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_tacker_TruePLAY [Apply role tacker] ***********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_octavia_TruePLAY [Apply role octavia] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_zun_TruePLAY [Apply role zun] **************************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_skydive_TruePLAY [Apply role skydive] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_vitrage_TruePLAY [Apply role vitrage] **********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_blazar_TruePLAY [Apply role blazar] ***********************************************************************************************
skipping: no hosts matched
[WARNING]: Could not match supplied host pattern, ignoring: enable_masakari_TruePLAY [Apply role masakari] *********************************************************************************************
skipping: no hosts matchedPLAY RECAP *************************************************************************************************************
compute                    : ok=69   changed=35   unreachable=0    failed=0    skipped=54   rescued=0    ignored=0
localhost                  : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
master                     : ok=282  changed=125  unreachable=0    failed=0    skipped=174  rescued=0    ignored=0
```

En mi caso, no ha ocurrido ningún error durante el proceso del _deployment_.
Por último, ejecutaremos los siguientes comandos:

```
(openstack) vagrant@installer:~$ kolla-ansible post-deploy
Post-Deploying Playbooks : ansible-playbook -i /home/vagrant/openstack/share/kolla-ansible/ansible/inventory/all-in-one -e @/etc/kolla/globals.yml  -e @/etc/kolla/passwords.yml -e CONFIG_DIR=/etc/kolla  /home/vagrant/openstack/share/kolla-ansible/ansible/post-deploy.yml
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details
PLAY [Creating admin openrc file on the deploy node] *******************************************************************
TASK [Gathering Facts] *************************************************************************************************
ok: [localhost]
TASK [Template out admin-openrc.sh] ************************************************************************************
[WARNING]: The value 1000 (type int) in a string field was converted to '1000' (type string). If this does not look
like what you expect, quote the entire value to ensure it does not change.
changed: [localhost]
TASK [Template out octavia-openrc.sh] **********************************************************************************
skipping: [localhost]
PLAY RECAP *************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

Y a continuación, ejecutamos lo siguiente:

```
(openstack) vagrant@installer:~$ . /etc/kolla/admin-openrc.sh
```

Esto copiará en dicha ubicación, los diferentes parámetros del usuario _admin_.

El contenido de mi fichero es el siguiente:

```
(openstack) vagrant@installer:~$ cat /etc/kolla/admin-openrc.sh
# Clear any old environment that may conflict.
for key in $( set | awk '{FS="="}  /^OS_/ {print $1}' ); do unset $key ; done
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=mix4hNUslfZpGDeSo2SmXhMKa9oa0rpH09P9ottb
export OS_AUTH_URL=http://10.0.1.254:35357/v3
export OS_INTERFACE=internal
export OS_ENDPOINT_TYPE=internalURL
export OS_IDENTITY_API_VERSION=3
export OS_REGION_NAME=RegionOne
export OS_AUTH_PLUGIN=password
```

Y con esto, podríamos acceder ya desde la IP incorporada en el parámetro del
fichero _/etc/kolla/globals.yml_:

```
kolla_external_vip_address: "192.168.0.55"
```

![alt text](../Imágenes/openstackubuntu.png)

![alt text](../Imágenes/openstackubuntu2.png)

Para realizar el lanzamiento de una máquina, vamos a descargarnos el paquete
de openstack-client y ejecutaremos la prueba que nos proporciona:

```
(openstack) vagrant@installer:~$ pip install openstackclient
Collecting openstackclient
  Downloading openstackclient-4.0.0-py2.py3-none-any.whl (7.0 kB)
Collecting python-openstackclient>=4.0.0
  Downloading python_openstackclient-5.4.0-py3-none-any.whl (886 kB)
     |████████████████████████████████| 886 kB 3.7 MB/s 
Collecting python-zaqarclient>=1.0.0
  Downloading python_zaqarclient-2.0.1-py3-none-any.whl (84 kB)
     |████████████████████████████████| 84 kB 6.0 MB/s 
Collecting python-ironicclient>=2.3.0
  Downloading python_ironicclient-4.6.0-py3-none-any.whl (241 kB)
     |████████████████████████████████| 241 kB 7.6 MB/s 
Collecting python-muranoclient>=0.8.2
  Downloading python_muranoclient-2.2.0-py3-none-any.whl (260 kB)
     |████████████████████████████████| 260 kB 7.2 MB/s 
Collecting python-troveclient>=2.2.0
  Downloading python_troveclient-7.0.0-py3-none-any.whl (236 kB)
     |████████████████████████████████| 236 kB 9.4 MB/s 
Collecting python-searchlightclient>=1.0.0
  Downloading python_searchlightclient-2.1.1-py3-none-any.whl (44 kB)
     |████████████████████████████████| 44 kB 2.6 MB/s 
Collecting python-zunclient>=3.4.0
  Downloading python_zunclient-4.1.1-py3-none-any.whl (151 kB)
     |████████████████████████████████| 151 kB 8.0 MB/s 
Collecting python-watcherclient>=1.1.0
  Downloading python_watcherclient-3.1.1-py3-none-any.whl (123 kB)
     |████████████████████████████████| 123 kB 5.9 MB/s 
Requirement already satisfied: pbr!=2.1.0,>=2.0.0 in ./openstack/lib/python3.6/site-packages (from openstackclient) (5.5.1)
Collecting python-congressclient<2000,>=1.3.0
  Downloading python_congressclient-2.0.1-py3-none-any.whl (40 kB)
     |████████████████████████████████| 40 kB 4.3 MB/s 
Collecting python-barbicanclient>=4.5.2
  Downloading python_barbicanclient-5.0.1-py3-none-any.whl (80 kB)
     |████████████████████████████████| 80 kB 6.8 MB/s 
Collecting python-designateclient>=2.7.0
  Downloading python_designateclient-4.2.0-py3-none-any.whl (84 kB)
     |████████████████████████████████| 84 kB 2.7 MB/s 
Collecting python-saharaclient>=1.4.0
  Downloading python_saharaclient-3.3.0-py3-none-any.whl (156 kB)
     |████████████████████████████████| 156 kB 2.2 MB/s 
Collecting gnocchiclient>=3.3.1
  Downloading gnocchiclient-7.0.7-py2.py3-none-any.whl (66 kB)
     |████████████████████████████████| 66 kB 5.2 MB/s 
Collecting python-ironic-inspector-client>=1.5.0
  Downloading python_ironic_inspector_client-4.4.0-py3-none-any.whl (34 kB)
Collecting python-neutronclient>=6.7.0
  Downloading python_neutronclient-7.3.0-py3-none-any.whl (436 kB)
     |████████████████████████████████| 436 kB 5.2 MB/s 
Collecting python-mistralclient!=3.2.0,>=3.1.0
  Downloading python_mistralclient-4.2.0-py3-none-any.whl (142 kB)
     |████████████████████████████████| 142 kB 7.0 MB/s 
Collecting python-senlinclient>=1.1.0
  Downloading python_senlinclient-2.2.0-py3-none-any.whl (108 kB)
     |████████████████████████████████| 108 kB 8.5 MB/s 
Collecting networkx>=2.3
  Downloading networkx-2.5-py3-none-any.whl (1.6 MB)
     |████████████████████████████████| 1.6 MB 6.1 MB/s 
Collecting python-octaviaclient>=1.3.0
  Downloading python_octaviaclient-2.2.0-py3-none-any.whl (103 kB)
     |████████████████████████████████| 103 kB 6.5 MB/s 
Collecting aodhclient>=0.9.0
  Downloading aodhclient-2.1.1-py3-none-any.whl (48 kB)
     |████████████████████████████████| 48 kB 2.0 MB/s 
Collecting python-vitrageclient>=1.3.0
  Downloading python_vitrageclient-4.2.0-py3-none-any.whl (50 kB)
     |████████████████████████████████| 50 kB 5.9 MB/s 
Collecting python-heatclient>=1.10.0
  Downloading python_heatclient-2.3.0-py3-none-any.whl (213 kB)
     |████████████████████████████████| 213 kB 6.4 MB/s 
Requirement already satisfied: oslo.utils>=2.0.0 in ./openstack/lib/python3.6/site-packages (from aodhclient>=0.9.0->openstackclient) (4.8.0)
Collecting oslo.serialization>=1.4.0
  Downloading oslo.serialization-4.1.0-py3-none-any.whl (25 kB)
Requirement already satisfied: oslo.i18n>=1.5.0 in ./openstack/lib/python3.6/site-packages (from aodhclient>=0.9.0->openstackclient) (5.0.1)
Requirement already satisfied: pyparsing in ./openstack/lib/python3.6/site-packages (from aodhclient>=0.9.0->openstackclient) (2.4.7)
Collecting keystoneauth1>=1.0.0
  Downloading keystoneauth1-4.3.1-py3-none-any.whl (314 kB)
     |████████████████████████████████| 314 kB 6.2 MB/s 
Collecting cliff!=1.16.0,>=1.14.0
  Downloading cliff-3.7.0-py3-none-any.whl (80 kB)
     |████████████████████████████████| 80 kB 5.2 MB/s 
Collecting osc-lib>=1.0.1
  Downloading osc_lib-2.3.1-py3-none-any.whl (88 kB)
     |████████████████████████████████| 88 kB 6.6 MB/s 
Requirement already satisfied: six in ./openstack/lib/python3.6/site-packages (from aodhclient>=0.9.0->openstackclient) (1.15.0)
Collecting osprofiler>=1.4.0
  Downloading osprofiler-3.4.0-py3-none-any.whl (85 kB)
     |████████████████████████████████| 85 kB 6.3 MB/s 
Collecting cmd2>=1.0.0
  Downloading cmd2-1.5.0-py3-none-any.whl (133 kB)
     |████████████████████████████████| 133 kB 6.8 MB/s 
Requirement already satisfied: PyYAML>=3.12 in ./openstack/lib/python3.6/site-packages (from cliff!=1.16.0,>=1.14.0->aodhclient>=0.9.0->openstackclient) (5.4.1)
Requirement already satisfied: stevedore>=2.0.1 in ./openstack/lib/python3.6/site-packages (from cliff!=1.16.0,>=1.14.0->aodhclient>=0.9.0->openstackclient) (3.3.0)
Collecting PrettyTable>=0.7.2
  Downloading prettytable-2.0.0-py3-none-any.whl (22 kB)
Collecting attrs>=16.3.0
  Downloading attrs-20.3.0-py2.py3-none-any.whl (49 kB)
     |████████████████████████████████| 49 kB 2.9 MB/s 
Requirement already satisfied: importlib-metadata>=1.6.0 in ./openstack/lib/python3.6/site-packages (from cmd2>=1.0.0->cliff!=1.16.0,>=1.14.0->aodhclient>=0.9.0->openstackclient) (3.7.0)
Collecting pyperclip>=1.6
  Downloading pyperclip-1.8.2.tar.gz (20 kB)
Collecting wcwidth>=0.1.7
  Downloading wcwidth-0.2.5-py2.py3-none-any.whl (30 kB)
Collecting colorama>=0.3.7
  Downloading colorama-0.4.4-py2.py3-none-any.whl (16 kB)
Collecting monotonic
  Downloading monotonic-1.5-py2.py3-none-any.whl (5.3 kB)
Collecting ujson
  Downloading ujson-4.0.2-cp36-cp36m-manylinux1_x86_64.whl (179 kB)
     |████████████████████████████████| 179 kB 6.9 MB/s 
Requirement already satisfied: debtcollector in ./openstack/lib/python3.6/site-packages (from gnocchiclient>=3.3.1->openstackclient) (2.2.0)
Collecting python-dateutil
  Downloading python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
     |████████████████████████████████| 227 kB 7.4 MB/s 
Requirement already satisfied: iso8601 in ./openstack/lib/python3.6/site-packages (from gnocchiclient>=3.3.1->openstackclient) (0.1.14)
Collecting futurist
  Downloading futurist-2.3.0-py3-none-any.whl (34 kB)
Requirement already satisfied: zipp>=0.5 in ./openstack/lib/python3.6/site-packages (from importlib-metadata>=1.6.0->cmd2>=1.0.0->cliff!=1.16.0,>=1.14.0->aodhclient>=0.9.0->openstackclient) (3.4.0)
Requirement already satisfied: typing-extensions>=3.6.4 in ./openstack/lib/python3.6/site-packages (from importlib-metadata>=1.6.0->cmd2>=1.0.0->cliff!=1.16.0,>=1.14.0->aodhclient>=0.9.0->openstackclient) (3.7.4.3)
Requirement already satisfied: requests>=2.14.2 in ./openstack/lib/python3.6/site-packages (from keystoneauth1>=1.0.0->aodhclient>=0.9.0->openstackclient) (2.25.1)
Collecting os-service-types>=1.2.0
  Downloading os_service_types-1.7.0-py2.py3-none-any.whl (24 kB)
Collecting decorator>=4.3.0
  Downloading decorator-4.4.2-py2.py3-none-any.whl (9.2 kB)
Collecting openstacksdk>=0.15.0
  Downloading openstacksdk-0.53.0-py3-none-any.whl (1.4 MB)
     |████████████████████████████████| 1.4 MB 8.9 MB/s 
Collecting simplejson>=3.5.1
  Downloading simplejson-3.17.2-cp36-cp36m-manylinux2010_x86_64.whl (127 kB)
     |████████████████████████████████| 127 kB 2.1 MB/s 
Requirement already satisfied: netifaces>=0.10.4 in ./openstack/lib/python3.6/site-packages (from openstacksdk>=0.15.0->osc-lib>=1.0.1->aodhclient>=0.9.0->openstackclient) (0.10.9)
Collecting appdirs>=1.3.0
  Downloading appdirs-1.4.4-py2.py3-none-any.whl (9.6 kB)
Requirement already satisfied: jmespath>=0.9.0 in ./openstack/lib/python3.6/site-packages (from openstacksdk>=0.15.0->osc-lib>=1.0.1->aodhclient>=0.9.0->openstackclient) (0.10.0)
Collecting jsonpatch!=1.20,>=1.16
  Downloading jsonpatch-1.28-py2.py3-none-any.whl (12 kB)
Collecting munch>=2.1.0
  Downloading munch-2.5.0-py2.py3-none-any.whl (10 kB)
Collecting requestsexceptions>=1.2.0
  Downloading requestsexceptions-1.4.0-py2.py3-none-any.whl (3.8 kB)
Collecting dogpile.cache>=0.6.5
  Downloading dogpile.cache-1.1.2-py3-none-any.whl (49 kB)
     |████████████████████████████████| 49 kB 2.0 MB/s 
Requirement already satisfied: cryptography>=2.7 in ./openstack/lib/python3.6/site-packages (from openstacksdk>=0.15.0->osc-lib>=1.0.1->aodhclient>=0.9.0->openstackclient) (3.4.6)
Requirement already satisfied: cffi>=1.12 in ./openstack/lib/python3.6/site-packages (from cryptography>=2.7->openstacksdk>=0.15.0->osc-lib>=1.0.1->aodhclient>=0.9.0->openstackclient) (1.14.5)
Requirement already satisfied: pycparser in ./openstack/lib/python3.6/site-packages (from cffi>=1.12->cryptography>=2.7->openstacksdk>=0.15.0->osc-lib>=1.0.1->aodhclient>=0.9.0->openstackclient) (2.20)
Collecting jsonpointer>=1.9
  Downloading jsonpointer-2.0-py2.py3-none-any.whl (7.6 kB)
Requirement already satisfied: pytz>=2013.6 in ./openstack/lib/python3.6/site-packages (from oslo.serialization>=1.4.0->aodhclient>=0.9.0->openstackclient) (2021.1)
Collecting msgpack>=0.5.2
  Downloading msgpack-1.0.2-cp36-cp36m-manylinux1_x86_64.whl (272 kB)
     |████████████████████████████████| 272 kB 7.5 MB/s 
Requirement already satisfied: netaddr>=0.7.18 in ./openstack/lib/python3.6/site-packages (from oslo.utils>=2.0.0->aodhclient>=0.9.0->openstackclient) (0.8.0)
Requirement already satisfied: packaging>=20.4 in ./openstack/lib/python3.6/site-packages (from oslo.utils>=2.0.0->aodhclient>=0.9.0->openstackclient) (20.9)
Requirement already satisfied: wrapt>=1.7.0 in ./openstack/lib/python3.6/site-packages (from debtcollector->gnocchiclient>=3.3.1->openstackclient) (1.12.1)
Requirement already satisfied: importlib-resources in ./openstack/lib/python3.6/site-packages (from netaddr>=0.7.18->oslo.utils>=2.0.0->aodhclient>=0.9.0->openstackclient) (5.1.1)
Collecting PrettyTable>=0.7.2
  Downloading prettytable-0.7.2.zip (28 kB)
Collecting WebOb>=1.7.1
  Downloading WebOb-1.8.7-py2.py3-none-any.whl (114 kB)
     |████████████████████████████████| 114 kB 8.0 MB/s 
Collecting oslo.concurrency>=3.26.0
  Downloading oslo.concurrency-4.4.0-py3-none-any.whl (47 kB)
     |████████████████████████████████| 47 kB 5.4 MB/s 
Requirement already satisfied: oslo.config>=5.2.0 in ./openstack/lib/python3.6/site-packages (from oslo.concurrency>=3.26.0->osprofiler>=1.4.0->aodhclient>=0.9.0->openstackclient) (8.4.0)
Collecting fasteners>=0.7.0
  Downloading fasteners-0.16-py2.py3-none-any.whl (28 kB)
Requirement already satisfied: rfc3986>=1.2.0 in ./openstack/lib/python3.6/site-packages (from oslo.config>=5.2.0->oslo.concurrency>=3.26.0->osprofiler>=1.4.0->aodhclient>=0.9.0->openstackclient) (1.4.0)
Collecting Babel!=2.4.0,>=2.3.4
  Downloading Babel-2.9.0-py2.py3-none-any.whl (8.8 MB)
     |████████████████████████████████| 8.8 MB 9.2 MB/s 
Collecting oslo.log>=3.36.0
  Downloading oslo.log-4.4.0-py3-none-any.whl (66 kB)
     |████████████████████████████████| 66 kB 2.2 MB/s 
Collecting oslo.context>=2.20.0
  Downloading oslo.context-3.1.1-py3-none-any.whl (16 kB)
Collecting pyinotify>=0.9.6
  Downloading pyinotify-0.9.6.tar.gz (60 kB)
     |████████████████████████████████| 60 kB 5.6 MB/s 
Collecting jsonschema>=2.6.0
  Downloading jsonschema-3.2.0-py2.py3-none-any.whl (56 kB)
     |████████████████████████████████| 56 kB 5.7 MB/s 
Collecting pyrsistent>=0.14.0
  Downloading pyrsistent-0.17.3.tar.gz (106 kB)
     |████████████████████████████████| 106 kB 10.8 MB/s 
Requirement already satisfied: setuptools in ./openstack/lib/python3.6/site-packages (from jsonschema>=2.6.0->python-designateclient>=2.7.0->openstackclient) (39.0.1)
Collecting python-swiftclient>=3.2.0
  Downloading python_swiftclient-3.11.0-py2.py3-none-any.whl (86 kB)
     |████████████████████████████████| 86 kB 6.3 MB/s 
Collecting python-keystoneclient>=3.8.0
  Downloading python_keystoneclient-4.2.0-py3-none-any.whl (397 kB)
     |████████████████████████████████| 397 kB 7.6 MB/s 
Collecting yaql>=1.1.3
  Downloading yaql-1.1.3.tar.gz (111 kB)
     |████████████████████████████████| 111 kB 8.7 MB/s 
Collecting murano-pkg-check>=0.3.0
  Downloading murano-pkg-check-0.3.0.tar.gz (39 kB)
Collecting pyOpenSSL>=17.1.0
  Downloading pyOpenSSL-20.0.1-py2.py3-none-any.whl (54 kB)
     |████████████████████████████████| 54 kB 4.2 MB/s 
Collecting python-glanceclient>=2.8.0
  Downloading python_glanceclient-3.2.2-py3-none-any.whl (189 kB)
     |████████████████████████████████| 189 kB 4.6 MB/s 
Collecting semantic-version>=2.3.1
  Downloading semantic_version-2.8.5-py2.py3-none-any.whl (15 kB)
Collecting warlock<2,>=1.2.0
  Downloading warlock-1.3.3.tar.gz (11 kB)
Collecting os-client-config>=1.28.0
  Downloading os_client_config-2.1.0-py3-none-any.whl (31 kB)
Collecting python-cinderclient>=3.3.0
  Downloading python_cinderclient-7.3.0-py3-none-any.whl (278 kB)
     |████████████████████████████████| 278 kB 5.6 MB/s 
Collecting python-novaclient>=15.1.0
  Downloading python_novaclient-17.3.0-py3-none-any.whl (331 kB)
     |████████████████████████████████| 331 kB 7.4 MB/s 
Collecting pydot>=1.4.1
  Downloading pydot-1.4.2-py2.py3-none-any.whl (21 kB)
Collecting websocket-client>=0.44.0
  Downloading websocket_client-0.57.0-py2.py3-none-any.whl (200 kB)
     |████████████████████████████████| 200 kB 6.4 MB/s 
Collecting docker>=2.4.2
  Downloading docker-4.4.4-py2.py3-none-any.whl (147 kB)
     |████████████████████████████████| 147 kB 7.2 MB/s 
Requirement already satisfied: urllib3<1.27,>=1.21.1 in ./openstack/lib/python3.6/site-packages (from requests>=2.14.2->keystoneauth1>=1.0.0->aodhclient>=0.9.0->openstackclient) (1.26.3)
Requirement already satisfied: certifi>=2017.4.17 in ./openstack/lib/python3.6/site-packages (from requests>=2.14.2->keystoneauth1>=1.0.0->aodhclient>=0.9.0->openstackclient) (2020.12.5)
Requirement already satisfied: idna<3,>=2.5 in ./openstack/lib/python3.6/site-packages (from requests>=2.14.2->keystoneauth1>=1.0.0->aodhclient>=0.9.0->openstackclient) (2.10)
Requirement already satisfied: chardet<5,>=3.0.2 in ./openstack/lib/python3.6/site-packages (from requests>=2.14.2->keystoneauth1>=1.0.0->aodhclient>=0.9.0->openstackclient) (4.0.0)
Collecting ply
  Downloading ply-3.11-py2.py3-none-any.whl (49 kB)
     |████████████████████████████████| 49 kB 5.2 MB/s 
Using legacy 'setup.py install' for PrettyTable, since package 'wheel' is not installed.
Using legacy 'setup.py install' for pyperclip, since package 'wheel' is not installed.
Using legacy 'setup.py install' for pyinotify, since package 'wheel' is not installed.
Using legacy 'setup.py install' for pyrsistent, since package 'wheel' is not installed.
Using legacy 'setup.py install' for murano-pkg-check, since package 'wheel' is not installed.
Using legacy 'setup.py install' for warlock, since package 'wheel' is not installed.
Using legacy 'setup.py install' for yaql, since package 'wheel' is not installed.
Installing collected packages: wcwidth, pyperclip, os-service-types, jsonpointer, decorator, colorama, attrs, requestsexceptions, pyrsistent, PrettyTable, munch, msgpack, keystoneauth1, jsonpatch, dogpile.cache, cmd2, appdirs, simplejson, python-dateutil, pyinotify, ply, oslo.serialization, oslo.context, openstacksdk, jsonschema, fasteners, cliff, Babel, yaql, websocket-client, WebOb, warlock, semantic-version, python-swiftclient, python-novaclient, python-keystoneclient, python-cinderclient, pyOpenSSL, oslo.log, oslo.concurrency, osc-lib, os-client-config, ujson, python-openstackclient, python-neutronclient, python-mistralclient, python-heatclient, python-glanceclient, pydot, osprofiler, networkx, murano-pkg-check, monotonic, futurist, docker, python-zunclient, python-zaqarclient, python-watcherclient, python-vitrageclient, python-troveclient, python-senlinclient, python-searchlightclient, python-saharaclient, python-octaviaclient, python-muranoclient, python-ironicclient, python-ironic-inspector-client, python-designateclient, python-congressclient, python-barbicanclient, gnocchiclient, aodhclient, openstackclient
    Running setup.py install for pyperclip ... done
    Running setup.py install for pyrsistent ... done
    Running setup.py install for PrettyTable ... done
    Running setup.py install for pyinotify ... done
    Running setup.py install for yaql ... done
    Running setup.py install for warlock ... done
    Running setup.py install for murano-pkg-check ... done
Successfully installed Babel-2.9.0 PrettyTable-0.7.2 WebOb-1.8.7 aodhclient-2.1.1 appdirs-1.4.4 attrs-20.3.0 cliff-3.7.0 cmd2-1.5.0 colorama-0.4.4 decorator-4.4.2 docker-4.4.4 dogpile.cache-1.1.2 fasteners-0.16 futurist-2.3.0 gnocchiclient-7.0.7 jsonpatch-1.28 jsonpointer-2.0 jsonschema-3.2.0 keystoneauth1-4.3.1 monotonic-1.5 msgpack-1.0.2 munch-2.5.0 murano-pkg-check-0.3.0 networkx-2.5 openstackclient-4.0.0 openstacksdk-0.53.0 os-client-config-2.1.0 os-service-types-1.7.0 osc-lib-2.3.1 oslo.concurrency-4.4.0 oslo.context-3.1.1 oslo.log-4.4.0 oslo.serialization-4.1.0 osprofiler-3.4.0 ply-3.11 pyOpenSSL-20.0.1 pydot-1.4.2 pyinotify-0.9.6 pyperclip-1.8.2 pyrsistent-0.17.3 python-barbicanclient-5.0.1 python-cinderclient-7.3.0 python-congressclient-2.0.1 python-dateutil-2.8.1 python-designateclient-4.2.0 python-glanceclient-3.2.2 python-heatclient-2.3.0 python-ironic-inspector-client-4.4.0 python-ironicclient-4.6.0 python-keystoneclient-4.2.0 python-mistralclient-4.2.0 python-muranoclient-2.2.0 python-neutronclient-7.3.0 python-novaclient-17.3.0 python-octaviaclient-2.2.0 python-openstackclient-5.4.0 python-saharaclient-3.3.0 python-searchlightclient-2.1.1 python-senlinclient-2.2.0 python-swiftclient-3.11.0 python-troveclient-7.0.0 python-vitrageclient-4.2.0 python-watcherclient-3.1.1 python-zaqarclient-2.0.1 python-zunclient-4.1.1 requestsexceptions-1.4.0 semantic-version-2.8.5 simplejson-3.17.2 ujson-4.0.2 warlock-1.3.3 wcwidth-0.2.5 websocket-client-0.57.0 yaql-1.1.3
```

Y ejecutaremos la prueba:

```
(openstack) vagrant@installer:~$ source /etc/kolla/admin-openrc.sh
(openstack) vagrant@installer:~$ openstack/share/kolla-ansible/init-runonce 
Checking for locally available cirros image.
None found, downloading cirros image.
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   636  100   636    0     0    880      0 --:--:-- --:--:-- --:--:--   879
100 15.5M  100 15.5M    0     0  1607k      0  0:00:09  0:00:09 --:--:-- 2639k
Creating glance image.
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field            | Value                                                                                                                                                       |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------+
| container_format | bare                                                                                                                                                        |
| created_at       | 2021-03-01T18:47:05Z                                                                                                                                        |
| disk_format      | qcow2                                                                                                                                                       |
| file             | /v2/images/f513ff5d-198c-451e-8cd0-94372bcceb28/file                                                                                                        |
| id               | f513ff5d-198c-451e-8cd0-94372bcceb28                                                                                                                        |
| min_disk         | 0                                                                                                                                                           |
| min_ram          | 0                                                                                                                                                           |
| name             | cirros                                                                                                                                                      |
| owner            | bd172b220dea4e5f8f130a0f6e7f95eb                                                                                                                            |
| properties       | os_hidden='False', os_type='linux', owner_specified.openstack.md5='', owner_specified.openstack.object='images/cirros', owner_specified.openstack.sha256='' |
| protected        | False                                                                                                                                                       |
| schema           | /v2/schemas/image                                                                                                                                           |
| status           | queued                                                                                                                                                      |
| tags             |                                                                                                                                                             |
| updated_at       | 2021-03-01T18:47:05Z                                                                                                                                        |
| visibility       | public                                                                                                                                                      |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------+
Configuring neutron.
+-------------------------+--------------------------------------+
| Field                   | Value                                |
+-------------------------+--------------------------------------+
| admin_state_up          | UP                                   |
| availability_zone_hints |                                      |
| availability_zones      |                                      |
| created_at              | 2021-03-01T18:47:07Z                 |
| description             |                                      |
| distributed             | False                                |
| external_gateway_info   | null                                 |
| flavor_id               | None                                 |
| ha                      | False                                |
| id                      | ecf536ee-a3aa-4484-8bd4-972f986b768c |
| name                    | demo-router                          |
| project_id              | bd172b220dea4e5f8f130a0f6e7f95eb     |
| revision_number         | 1                                    |
| routes                  |                                      |
| status                  | ACTIVE                               |
| tags                    |                                      |
| updated_at              | 2021-03-01T18:47:07Z                 |
+-------------------------+--------------------------------------+
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
| admin_state_up            | UP                                   |
| availability_zone_hints   |                                      |
| availability_zones        |                                      |
| created_at                | 2021-03-01T18:47:09Z                 |
| description               |                                      |
| dns_domain                | None                                 |
| id                        | 1e5a0bc7-a9e3-4b04-a80f-40fc52ed9e9a |
| ipv4_address_scope        | None                                 |
| ipv6_address_scope        | None                                 |
| is_default                | False                                |
| is_vlan_transparent       | None                                 |
| mtu                       | 1450                                 |
| name                      | demo-net                             |
| port_security_enabled     | True                                 |
| project_id                | bd172b220dea4e5f8f130a0f6e7f95eb     |
| provider:network_type     | vxlan                                |
| provider:physical_network | None                                 |
| provider:segmentation_id  | 1                                    |
| qos_policy_id             | None                                 |
| revision_number           | 1                                    |
| router:external           | Internal                             |
| segments                  | None                                 |
| shared                    | False                                |
| status                    | ACTIVE                               |
| subnets                   |                                      |
| tags                      |                                      |
| updated_at                | 2021-03-01T18:47:09Z                 |
+---------------------------+--------------------------------------+
+----------------------+--------------------------------------+
| Field                | Value                                |
+----------------------+--------------------------------------+
| allocation_pools     | 10.0.0.2-10.0.0.254                  |
| cidr                 | 10.0.0.0/24                          |
| created_at           | 2021-03-01T18:47:11Z                 |
| description          |                                      |
| dns_nameservers      | 8.8.8.8                              |
| dns_publish_fixed_ip | None                                 |
| enable_dhcp          | True                                 |
| gateway_ip           | 10.0.0.1                             |
| host_routes          |                                      |
| id                   | 84b635de-9d4b-4131-a8e4-6e7eb5a8e1ba |
| ip_version           | 4                                    |
| ipv6_address_mode    | None                                 |
| ipv6_ra_mode         | None                                 |
| name                 | demo-subnet                          |
| network_id           | 1e5a0bc7-a9e3-4b04-a80f-40fc52ed9e9a |
| prefix_length        | None                                 |
| project_id           | bd172b220dea4e5f8f130a0f6e7f95eb     |
| revision_number      | 0                                    |
| segment_id           | None                                 |
| service_types        |                                      |
| subnetpool_id        | None                                 |
| tags                 |                                      |
| updated_at           | 2021-03-01T18:47:11Z                 |
+----------------------+--------------------------------------+
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
| admin_state_up            | UP                                   |
| availability_zone_hints   |                                      |
| availability_zones        |                                      |
| created_at                | 2021-03-01T18:47:17Z                 |
| description               |                                      |
| dns_domain                | None                                 |
| id                        | 262064bb-e138-40da-991c-41cfa51dc9f1 |
| ipv4_address_scope        | None                                 |
| ipv6_address_scope        | None                                 |
| is_default                | False                                |
| is_vlan_transparent       | None                                 |
| mtu                       | 1500                                 |
| name                      | public1                              |
| port_security_enabled     | True                                 |
| project_id                | bd172b220dea4e5f8f130a0f6e7f95eb     |
| provider:network_type     | flat                                 |
| provider:physical_network | physnet1                             |
| provider:segmentation_id  | None                                 |
| qos_policy_id             | None                                 |
| revision_number           | 1                                    |
| router:external           | External                             |
| segments                  | None                                 |
| shared                    | False                                |
| status                    | ACTIVE                               |
| subnets                   |                                      |
| tags                      |                                      |
| updated_at                | 2021-03-01T18:47:17Z                 |
+---------------------------+--------------------------------------+
+----------------------+--------------------------------------+
| Field                | Value                                |
+----------------------+--------------------------------------+
| allocation_pools     | 10.0.2.150-10.0.2.199                |
| cidr                 | 10.0.2.0/24                          |
| created_at           | 2021-03-01T18:47:19Z                 |
| description          |                                      |
| dns_nameservers      |                                      |
| dns_publish_fixed_ip | None                                 |
| enable_dhcp          | False                                |
| gateway_ip           | 10.0.2.1                             |
| host_routes          |                                      |
| id                   | 5bc1f341-e299-4539-beb2-09f81854f89b |
| ip_version           | 4                                    |
| ipv6_address_mode    | None                                 |
| ipv6_ra_mode         | None                                 |
| name                 | public1-subnet                       |
| network_id           | 262064bb-e138-40da-991c-41cfa51dc9f1 |
| prefix_length        | None                                 |
| project_id           | bd172b220dea4e5f8f130a0f6e7f95eb     |
| revision_number      | 0                                    |
| segment_id           | None                                 |
| service_types        |                                      |
| subnetpool_id        | None                                 |
| tags                 |                                      |
| updated_at           | 2021-03-01T18:47:19Z                 |
+----------------------+--------------------------------------+
+-------------------------+--------------------------------------+
| Field                   | Value                                |
+-------------------------+--------------------------------------+
| created_at              | 2021-03-01T18:47:33Z                 |
| description             |                                      |
| direction               | ingress                              |
| ether_type              | IPv4                                 |
| id                      | 2054dfe8-7be5-433d-a9b6-5af4064525bf |
| name                    | None                                 |
| port_range_max          | None                                 |
| port_range_min          | None                                 |
| project_id              | bd172b220dea4e5f8f130a0f6e7f95eb     |
| protocol                | icmp                                 |
| remote_address_group_id | None                                 |
| remote_group_id         | None                                 |
| remote_ip_prefix        | 0.0.0.0/0                            |
| revision_number         | 0                                    |
| security_group_id       | b1c1b37b-6ad4-4da2-898a-61c3c20e204b |
| tags                    | []                                   |
| updated_at              | 2021-03-01T18:47:33Z                 |
+-------------------------+--------------------------------------+
+-------------------------+--------------------------------------+
| Field                   | Value                                |
+-------------------------+--------------------------------------+
| created_at              | 2021-03-01T18:47:34Z                 |
| description             |                                      |
| direction               | ingress                              |
| ether_type              | IPv4                                 |
| id                      | 1a7d4472-6094-447a-a224-e0ec3c951f82 |
| name                    | None                                 |
| port_range_max          | 22                                   |
| port_range_min          | 22                                   |
| project_id              | bd172b220dea4e5f8f130a0f6e7f95eb     |
| protocol                | tcp                                  |
| remote_address_group_id | None                                 |
| remote_group_id         | None                                 |
| remote_ip_prefix        | 0.0.0.0/0                            |
| revision_number         | 0                                    |
| security_group_id       | b1c1b37b-6ad4-4da2-898a-61c3c20e204b |
| tags                    | []                                   |
| updated_at              | 2021-03-01T18:47:34Z                 |
+-------------------------+--------------------------------------+
+-------------------------+--------------------------------------+
| Field                   | Value                                |
+-------------------------+--------------------------------------+
| created_at              | 2021-03-01T18:47:36Z                 |
| description             |                                      |
| direction               | ingress                              |
| ether_type              | IPv4                                 |
| id                      | 6d7e84b8-3bc5-4656-ad05-1ac52e5de4fa |
| name                    | None                                 |
| port_range_max          | 8000                                 |
| port_range_min          | 8000                                 |
| project_id              | bd172b220dea4e5f8f130a0f6e7f95eb     |
| protocol                | tcp                                  |
| remote_address_group_id | None                                 |
| remote_group_id         | None                                 |
| remote_ip_prefix        | 0.0.0.0/0                            |
| revision_number         | 0                                    |
| security_group_id       | b1c1b37b-6ad4-4da2-898a-61c3c20e204b |
| tags                    | []                                   |
| updated_at              | 2021-03-01T18:47:36Z                 |
+-------------------------+--------------------------------------+
+-------------------------+--------------------------------------+
| Field                   | Value                                |
+-------------------------+--------------------------------------+
| created_at              | 2021-03-01T18:47:38Z                 |
| description             |                                      |
| direction               | ingress                              |
| ether_type              | IPv4                                 |
| id                      | e3373da9-159d-4aba-a19a-2d84a1d16afa |
| name                    | None                                 |
| port_range_max          | 8080                                 |
| port_range_min          | 8080                                 |
| project_id              | bd172b220dea4e5f8f130a0f6e7f95eb     |
| protocol                | tcp                                  |
| remote_address_group_id | None                                 |
| remote_group_id         | None                                 |
| remote_ip_prefix        | 0.0.0.0/0                            |
| revision_number         | 0                                    |
| security_group_id       | b1c1b37b-6ad4-4da2-898a-61c3c20e204b |
| tags                    | []                                   |
| updated_at              | 2021-03-01T18:47:38Z                 |
+-------------------------+--------------------------------------+
Generating ssh key.
Generating public/private rsa key pair.
Your identification has been saved in /home/vagrant/.ssh/id_rsa.
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:g91gGx/R3T4HCgXDm/I4rr+Hnbh2YxM0VMtdz/sITe0 vagrant@installer
The key's randomart image is:
+---[RSA 2048]----+
|         .+=o. ..|
|          ++.oo+o|
|        +..+o.oo+|
|       +.*=..o o+|
|      . S=o.. ..E|
|        o.o  . ..|
|       . = o  . .|
|        = O      |
|      .++* o     |
+----[SHA256]-----+
Configuring nova public key and quotas.
+-------------+-------------------------------------------------+
| Field       | Value                                           |
+-------------+-------------------------------------------------+
| fingerprint | 14:aa:93:2e:21:a4:e4:93:64:eb:bd:59:d9:66:6e:4e |
| name        | mykey                                           |
| user_id     | ff10c0dff14d4e61b417beec6bffd448                |
+-------------+-------------------------------------------------+
+----------------------------+---------+
| Field                      | Value   |
+----------------------------+---------+
| OS-FLV-DISABLED:disabled   | False   |
| OS-FLV-EXT-DATA:ephemeral  | 0       |
| disk                       | 1       |
| id                         | 1       |
| name                       | m1.tiny |
| os-flavor-access:is_public | True    |
| properties                 |         |
| ram                        | 512     |
| rxtx_factor                | 1.0     |
| swap                       |         |
| vcpus                      | 1       |
+----------------------------+---------+
+----------------------------+----------+
| Field                      | Value    |
+----------------------------+----------+
| OS-FLV-DISABLED:disabled   | False    |
| OS-FLV-EXT-DATA:ephemeral  | 0        |
| disk                       | 20       |
| id                         | 2        |
| name                       | m1.small |
| os-flavor-access:is_public | True     |
| properties                 |          |
| ram                        | 2048     |
| rxtx_factor                | 1.0      |
| swap                       |          |
| vcpus                      | 1        |
+----------------------------+----------+
+----------------------------+-----------+
| Field                      | Value     |
+----------------------------+-----------+
| OS-FLV-DISABLED:disabled   | False     |
| OS-FLV-EXT-DATA:ephemeral  | 0         |
| disk                       | 40        |
| id                         | 3         |
| name                       | m1.medium |
| os-flavor-access:is_public | True      |
| properties                 |           |
| ram                        | 4096      |
| rxtx_factor                | 1.0       |
| swap                       |           |
| vcpus                      | 2         |
+----------------------------+-----------+
+----------------------------+----------+
| Field                      | Value    |
+----------------------------+----------+
| OS-FLV-DISABLED:disabled   | False    |
| OS-FLV-EXT-DATA:ephemeral  | 0        |
| disk                       | 80       |
| id                         | 4        |
| name                       | m1.large |
| os-flavor-access:is_public | True     |
| properties                 |          |
| ram                        | 8192     |
| rxtx_factor                | 1.0      |
| swap                       |          |
| vcpus                      | 4        |
+----------------------------+----------+
+----------------------------+-----------+
| Field                      | Value     |
+----------------------------+-----------+
| OS-FLV-DISABLED:disabled   | False     |
| OS-FLV-EXT-DATA:ephemeral  | 0         |
| disk                       | 160       |
| id                         | 5         |
| name                       | m1.xlarge |
| os-flavor-access:is_public | True      |
| properties                 |           |
| ram                        | 16384     |
| rxtx_factor                | 1.0       |
| swap                       |           |
| vcpus                      | 8         |
+----------------------------+-----------+

Done.

To deploy a demo instance, run:

openstack server create \
    --image cirros \
    --flavor m1.tiny \
    --key-name mykey \
    --network demo-net \
    demo1
```

Y por último, ejecutamos el comando que nos ponen al final:

```
(openstack) vagrant@installer:~$ openstack server create \
>     --image cirros \
>     --flavor m1.tiny \
>     --key-name mykey \
>     --network demo-net \
>     demo1

+-------------------------------------+-----------------------------------------------+
| Field                               | Value                                         |
+-------------------------------------+-----------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                        |
| OS-EXT-AZ:availability_zone         |                                               |
| OS-EXT-SRV-ATTR:host                | None                                          |
| OS-EXT-SRV-ATTR:hypervisor_hostname | None                                          |
| OS-EXT-SRV-ATTR:instance_name       |                                               |
| OS-EXT-STS:power_state              | NOSTATE                                       |
| OS-EXT-STS:task_state               | scheduling                                    |
| OS-EXT-STS:vm_state                 | building                                      |
| OS-SRV-USG:launched_at              | None                                          |
| OS-SRV-USG:terminated_at            | None                                          |
| accessIPv4                          |                                               |
| accessIPv6                          |                                               |
| addresses                           |                                               |
| adminPass                           | svTMSX3ercc9                                  |
| config_drive                        |                                               |
| created                             | 2021-03-01T18:49:55Z                          |
| flavor                              | m1.tiny (1)                                   |
| hostId                              |                                               |
| id                                  | a85a1ed2-d634-4749-bd5c-15f53492d767          |
| image                               | cirros (f513ff5d-198c-451e-8cd0-94372bcceb28) |
| key_name                            | mykey                                         |
| name                                | demo1                                         |
| progress                            | 0                                             |
| project_id                          | bd172b220dea4e5f8f130a0f6e7f95eb              |
| properties                          |                                               |
| security_groups                     | name='default'                                |
| status                              | BUILD                                         |
| updated                             | 2021-03-01T18:49:55Z                          |
| user_id                             | ff10c0dff14d4e61b417beec6bffd448              |
| volumes_attached                    |                                               |
+-------------------------------------+-----------------------------------------------+
```

Y nos aparecerá de la siguiente manera:

![alt text](../Imágenes/openstackubuntu3.png)

Podemos acceder a la consola de manera normal:

![alt text](../Imágenes/openstackubuntu4.png)

![alt text](../Imágenes/openstackubuntu5.png)

Para probar el funcionamiento de los volúmenes, vamos a crear uno manualmente.
En primer lugar, vamos a comprobar nuestra zona disponible y las imágenes:

```
(openstack) vagrant@installer:~$ openstack availability zone list
+-----------+-------------+
| Zone Name | Zone Status |
+-----------+-------------+
| internal  | available   |
| nova      | available   |
| nova      | available   |
| nova      | available   |
+-----------+-------------+
(openstack) vagrant@installer:~$ openstack image list
+--------------------------------------+--------+--------+
| ID                                   | Name   | Status |
+--------------------------------------+--------+--------+
| f513ff5d-198c-451e-8cd0-94372bcceb28 | cirros | active |
+--------------------------------------+--------+--------+
```

Teniendo esta información, vamos a crear dicho volumen de la siguiente manera:

```
(openstack) vagrant@installer:~$ openstack volume create --image f513ff5d-198c-451e-8cd0-94372bcceb28 --size 2 --availability-zone nova Volumen_prueba
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| attachments         | []                                   |
| availability_zone   | nova                                 |
| bootable            | false                                |
| consistencygroup_id | None                                 |
| created_at          | 2021-03-01T19:05:51.000000           |
| description         | None                                 |
| encrypted           | False                                |
| id                  | 8b342d0c-36b7-4b16-a6b1-915f041e59c4 |
| migration_status    | None                                 |
| multiattach         | False                                |
| name                | Volumen_prueba                       |
| properties          |                                      |
| replication_status  | None                                 |
| size                | 2                                    |
| snapshot_id         | None                                 |
| source_volid        | None                                 |
| status              | creating                             |
| type                | __DEFAULT__                          |
| updated_at          | None                                 |
| user_id             | ff10c0dff14d4e61b417beec6bffd448     |
+---------------------+--------------------------------------+
```

Para comprobar que se ha creado correctamente:

```
(openstack) vagrant@installer:~$ openstack volume list
+--------------------------------------+----------------+--------+------+-------------+
| ID                                   | Name           | Status | Size | Attached to |
+--------------------------------------+----------------+--------+------+-------------+
| 8b342d0c-36b7-4b16-a6b1-915f041e59c4 | Volumen_prueba | error  |    2 |             |
+--------------------------------------+----------------+--------+------+-------------+
```

En nuestro caso, nos da error debido a que hemos superado nuestra quota. Dicho
volumen ya sería totalmente usable por las máquinas.


