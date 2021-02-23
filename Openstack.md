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

* [Página de kolla-ansible](https://docs.openstack.org/kolla-ansible/latest/user/quickstart.html)

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

A continuación, nos conectaremos por ssh a las diferentes máquinas y
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
       valid_lft 84681sec preferred_lft 84681sec
    inet6 fe80::a4:4aff:feb3:a736/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:41:09:80 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.27/24 brd 192.168.0.255 scope global dynamic enp0s8
       valid_lft 84682sec preferred_lft 84682sec
    inet6 fe80::a00:27ff:fe41:980/64 scope link 
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:92:51:6e brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.2/24 brd 10.0.1.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe92:516e/64 scope link 
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
       valid_lft 84844sec preferred_lft 84844sec
    inet6 fe80::a4:4aff:feb3:a736/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:04:bd:09 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.32/24 brd 192.168.0.255 scope global dynamic enp0s8
       valid_lft 84845sec preferred_lft 84845sec
    inet6 fe80::a00:27ff:fe04:bd09/64 scope link 
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:b6:a1:a8 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.3/24 brd 10.0.1.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feb6:a1a8/64 scope link 
       valid_lft forever preferred_lft forever
5: enp0s10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:9c:ba:c3 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.31/24 brd 192.168.0.255 scope global dynamic enp0s10
       valid_lft 84845sec preferred_lft 84845sec
    inet6 fe80::a00:27ff:fe9c:bac3/64 scope link 
       valid_lft forever preferred_lft forever
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
       valid_lft 84740sec preferred_lft 84740sec
    inet6 fe80::a4:4aff:feb3:a736/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:9c:32:71 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.33/24 brd 192.168.0.255 scope global dynamic enp0s8
       valid_lft 84741sec preferred_lft 84741sec
    inet6 fe80::a00:27ff:fe9c:3271/64 scope link 
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:45:b2:02 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.4/24 brd 10.0.1.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe45:b202/64 scope link 
       valid_lft forever preferred_lft forever
```

Instalaremos en las máquinas el paquete _python_dev_ y nos pasaremos en primer
lugar a la configuración de la máquina _installer_.

En la máquina _installer_ creamos un entorno virtual. Acto seguido, nos 
instalaremos los paquetes necesarios y el paquete _Ansible_.

```
vagrant@installer:~$ virtualenv openstack -p python3
Already using interpreter /usr/bin/python3
Using base prefix '/usr'
New python executable in /home/vagrant/openstack/bin/python3
Also creating executable in /home/vagrant/openstack/bin/python
Installing setuptools, pkg_resources, pip, wheel...done.
vagrant@installer:~$ source openstack/bin/activate
(openstack) vagrant@installer:~$ pip install -U pip
Requirement already satisfied: pip in ./openstack/lib/python3.6/site-packages (21.0.1)
(openstack) vagrant@installer:~$ pip install -U ansible
Collecting ansible
  Downloading ansible-3.0.0.tar.gz (30.8 MB)
     |████████████████████████████████| 30.8 MB 880 kB/s 
Collecting ansible-base<2.11,>=2.10.5
  Downloading ansible-base-2.10.6.tar.gz (5.7 MB)
     |████████████████████████████████| 5.7 MB 11.4 MB/s 
Collecting jinja2
  Downloading Jinja2-2.11.3-py2.py3-none-any.whl (125 kB)
     |████████████████████████████████| 125 kB 9.9 MB/s 
Collecting PyYAML
  Downloading PyYAML-5.4.1-cp36-cp36m-manylinux1_x86_64.whl (640 kB)
     |████████████████████████████████| 640 kB 21.2 MB/s 
Collecting cryptography
  Downloading cryptography-3.4.6-cp36-abi3-manylinux2014_x86_64.whl (3.2 MB)
     |████████████████████████████████| 3.2 MB 6.2 MB/s 
Collecting packaging
  Downloading packaging-20.9-py2.py3-none-any.whl (40 kB)
     |████████████████████████████████| 40 kB 1.1 MB/s 
Collecting cffi>=1.12
  Downloading cffi-1.14.5-cp36-cp36m-manylinux1_x86_64.whl (401 kB)
     |████████████████████████████████| 401 kB 834 kB/s 
Collecting pycparser
  Downloading pycparser-2.20-py2.py3-none-any.whl (112 kB)
     |████████████████████████████████| 112 kB 3.8 MB/s 
Collecting MarkupSafe>=0.23
  Downloading MarkupSafe-1.1.1-cp36-cp36m-manylinux2010_x86_64.whl (32 kB)
Collecting pyparsing>=2.0.2
  Downloading pyparsing-2.4.7-py2.py3-none-any.whl (67 kB)
     |████████████████████████████████| 67 kB 8.5 MB/s 
Building wheels for collected packages: ansible, ansible-base
  Building wheel for ansible (setup.py) ... done
  Created wheel for ansible: filename=ansible-3.0.0-py3-none-any.whl size=51827971 sha256=b04220be77dbf3201f9faf81bb468cb8df3ac994bdb98ba2080ea967f055a01c
  Stored in directory: /home/vagrant/.cache/pip/wheels/8c/87/4b/bb8d3756f8b3724b827014847d4603288679c75658423e6394
  Building wheel for ansible-base (setup.py) ... done
  Created wheel for ansible-base: filename=ansible_base-2.10.6-py3-none-any.whl size=1871043 sha256=acb800ce35ed2f530746dfd518051eebda3c432167368ed6ae260459a1d83163
  Stored in directory: /home/vagrant/.cache/pip/wheels/4a/00/92/ebc4564191629577c69a5e74ccee72abb71ff9cea7c2b78c3a
Successfully built ansible ansible-base
Installing collected packages: pycparser, pyparsing, MarkupSafe, cffi, PyYAML, packaging, jinja2, cryptography, ansible-base, ansible
Successfully installed MarkupSafe-1.1.1 PyYAML-5.4.1 ansible-3.0.0 ansible-base-2.10.6 cffi-1.14.5 cryptography-3.4.6 jinja2-2.11.3 packaging-20.9 pycparser-2.20 pyparsing-2.4.7
```

Después de instalar los paquetes comentados anteriormente, procedemos a instalar
el paquete _kolla-ansible_:

```
(openstack) vagrant@installer:~$ pip install -U kolla-ansible
Collecting kolla-ansible
  Downloading kolla_ansible-11.0.0-py3-none-any.whl (1.4 MB)
     |████████████████████████████████| 1.4 MB 2.5 MB/s 
Collecting jmespath>=0.9.3
  Downloading jmespath-0.10.0-py2.py3-none-any.whl (24 kB)
Collecting pbr!=2.1.0,>=2.0.0
  Downloading pbr-5.5.1-py2.py3-none-any.whl (106 kB)
     |████████████████████████████████| 106 kB 10.3 MB/s 
Collecting oslo.config>=5.2.0
  Downloading oslo.config-8.4.0-py3-none-any.whl (127 kB)
     |████████████████████████████████| 127 kB 4.6 MB/s 
Requirement already satisfied: cryptography>=2.1 in ./openstack/lib/python3.6/site-packages (from kolla-ansible) (3.4.6)
Requirement already satisfied: PyYAML>=3.12 in ./openstack/lib/python3.6/site-packages (from kolla-ansible) (5.4.1)
Requirement already satisfied: Jinja2>=2.10 in ./openstack/lib/python3.6/site-packages (from kolla-ansible) (2.11.3)
Collecting oslo.utils>=3.33.0
  Downloading oslo.utils-4.8.0-py3-none-any.whl (102 kB)
     |████████████████████████████████| 102 kB 11.5 MB/s 
Requirement already satisfied: cffi>=1.12 in ./openstack/lib/python3.6/site-packages (from cryptography>=2.1->kolla-ansible) (1.14.5)
Requirement already satisfied: pycparser in ./openstack/lib/python3.6/site-packages (from cffi>=1.12->cryptography>=2.1->kolla-ansible) (2.20)
Requirement already satisfied: MarkupSafe>=0.23 in ./openstack/lib/python3.6/site-packages (from Jinja2>=2.10->kolla-ansible) (1.1.1)
Collecting stevedore>=1.20.0
  Downloading stevedore-3.3.0-py3-none-any.whl (49 kB)
     |████████████████████████████████| 49 kB 6.6 MB/s 
Collecting rfc3986>=1.2.0
  Downloading rfc3986-1.4.0-py2.py3-none-any.whl (31 kB)
Collecting importlib-metadata>=1.7.0
  Downloading importlib_metadata-3.4.0-py3-none-any.whl (10 kB)
Collecting netaddr>=0.7.18
  Downloading netaddr-0.8.0-py2.py3-none-any.whl (1.9 MB)
     |████████████████████████████████| 1.9 MB 4.2 MB/s 
Collecting debtcollector>=1.2.0
  Downloading debtcollector-2.2.0-py3-none-any.whl (20 kB)
Collecting oslo.i18n>=3.15.3
  Downloading oslo.i18n-5.0.1-py3-none-any.whl (42 kB)
     |████████████████████████████████| 42 kB 1.2 MB/s 
Collecting requests>=2.18.0
  Downloading requests-2.25.1-py2.py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 8.6 MB/s 
Collecting six>=1.10.0
  Downloading six-1.15.0-py2.py3-none-any.whl (10 kB)
Collecting wrapt>=1.7.0
  Downloading wrapt-1.12.1.tar.gz (27 kB)
Collecting zipp>=0.5
  Downloading zipp-3.4.0-py3-none-any.whl (5.2 kB)
Collecting typing-extensions>=3.6.4
  Downloading typing_extensions-3.7.4.3-py3-none-any.whl (22 kB)
Collecting importlib-resources
  Downloading importlib_resources-5.1.0-py3-none-any.whl (24 kB)
Requirement already satisfied: packaging>=20.4 in ./openstack/lib/python3.6/site-packages (from oslo.utils>=3.33.0->kolla-ansible) (20.9)
Collecting netifaces>=0.10.4
  Downloading netifaces-0.10.9-cp36-cp36m-manylinux1_x86_64.whl (32 kB)
Collecting iso8601>=0.1.11
  Downloading iso8601-0.1.14-py2.py3-none-any.whl (9.5 kB)
Requirement already satisfied: pyparsing>=2.1.0 in ./openstack/lib/python3.6/site-packages (from oslo.utils>=3.33.0->kolla-ansible) (2.4.7)
Collecting pytz>=2013.6
  Downloading pytz-2021.1-py2.py3-none-any.whl (510 kB)
     |████████████████████████████████| 510 kB 7.6 MB/s 
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.3-py2.py3-none-any.whl (137 kB)
     |████████████████████████████████| 137 kB 10.6 MB/s 
Collecting certifi>=2017.4.17
  Downloading certifi-2020.12.5-py2.py3-none-any.whl (147 kB)
     |████████████████████████████████| 147 kB 10.0 MB/s 
Collecting chardet<5,>=3.0.2
  Downloading chardet-4.0.0-py2.py3-none-any.whl (178 kB)
     |████████████████████████████████| 178 kB 9.1 MB/s 
Collecting idna<3,>=2.5
  Downloading idna-2.10-py2.py3-none-any.whl (58 kB)
     |████████████████████████████████| 58 kB 4.2 MB/s 
Building wheels for collected packages: wrapt
  Building wheel for wrapt (setup.py) ... done
  Created wheel for wrapt: filename=wrapt-1.12.1-py3-none-any.whl size=19553 sha256=31ee9cb641154119d16a1300707fe31a03f0ebed165d5cd196bc822ab549a8b2
  Stored in directory: /home/vagrant/.cache/pip/wheels/32/42/7f/23cae9ff6ef66798d00dc5d659088e57dbba01566f6c60db63
Successfully built wrapt
Installing collected packages: zipp, typing-extensions, wrapt, urllib3, six, pbr, importlib-resources, importlib-metadata, idna, chardet, certifi, stevedore, rfc3986, requests, pytz, oslo.i18n, netifaces, netaddr, iso8601, debtcollector, oslo.utils, oslo.config, jmespath, kolla-ansible
Successfully installed certifi-2020.12.5 chardet-4.0.0 debtcollector-2.2.0 idna-2.10 importlib-metadata-3.4.0 importlib-resources-5.1.0 iso8601-0.1.14 jmespath-0.10.0 kolla-ansible-11.0.0 netaddr-0.8.0 netifaces-0.10.9 oslo.config-8.4.0 oslo.i18n-5.0.1 oslo.utils-4.8.0 pbr-5.5.1 pytz-2021.1 requests-2.25.1 rfc3986-1.4.0 six-1.15.0 stevedore-3.3.0 typing-extensions-3.7.4.3 urllib3-1.26.3 wrapt-1.12.1 zipp-3.4.0
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

(openstack) vagrant@installer:~$ sudo chown -R $USER:$USER /etc/ansible/
```

A continuación, vamos al fichero _multinode_ y vamos a modificar las 
siguientes líneas:

```
[control]
master ansible_user=root ansible_password=password

[network]
master

[compute]
compute ansible_user=root ansible_password=password

[monitoring]
master

[storage]
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
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host localhost should use 
/usr/bin/python3, but is using /usr/bin/python for backward compatibility with 
prior Ansible releases. A future Ansible release will default to using the 
discovered platform python for this host. See https://docs.ansible.com/ansible/
2.10/reference_appendices/interpreter_discovery.html for more information. This
 feature will be removed in version 2.12. Deprecation warnings can be disabled 
by setting deprecation_warnings=False in ansible.cfg.
localhost | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host compute should use 
/usr/bin/python3, but is using /usr/bin/python for backward compatibility with 
prior Ansible releases. A future Ansible release will default to using the 
discovered platform python for this host. See https://docs.ansible.com/ansible/
2.10/reference_appendices/interpreter_discovery.html for more information. This
 feature will be removed in version 2.12. Deprecation warnings can be disabled 
by setting deprecation_warnings=False in ansible.cfg.
compute | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host master should use 
/usr/bin/python3, but is using /usr/bin/python for backward compatibility with 
prior Ansible releases. A future Ansible release will default to using the 
discovered platform python for this host. See https://docs.ansible.com/ansible/
2.10/reference_appendices/interpreter_discovery.html for more information. This
 feature will be removed in version 2.12. Deprecation warnings can be disabled 
by setting deprecation_warnings=False in ansible.cfg.
master | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
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

kolla_internal_vip_address: "10.10.1.254"

kolla_external_vip_address: "192.168.0.27"

##############################
# Neutron - Networking Options
##############################

network_interface: "enp0s9"

kolla_external_vip_interface: "enp0s10"

neutron_external_interface: "enp0s10"

###################
# OpenStack options
###################

enable_cinder: "yes"
enable_cinder_backup: "yes"
enable_cinder_backend_hnas_nfs: "yes"
enable_cinder_backend_nfs: "yes"

########################
# Nova - Compute Options
########################

nova_compute_virt_type: "qemu"

```

Configurado este fichero, vamos a preparar el _deployment_. Primero de todo, 
vamos a preparar las dependencias de los nodos:

```

