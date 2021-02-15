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

Debido a que _linux-source_ es un metapaquete, simplemente con ejecutar el 
siguiente comando ya lo tendríamos:

```sudo apt-get install linux-source```

2. Crea un directorio de trabajo (p.ej. mkdir ~/Linux).

Hemos creado un directorio llamado _/home/manuel/KernelLinux_.

3. Descomprime el código fuente del kérnel dentro del directorio de trabajo:

```tar xf /usr/src/linux-source-... ~/Linux/```

```
manuel@debian:~/KernelLinux$ tar xf linux-source-4.19.tar.xz 
manuel@debian:~/KernelLinux$ ls
linux-source-4.19  linux-source-4.19.tar.xz
manuel@debian:~/KernelLinux$ 
```

4. Utiliza como punto de partida la configuración actual del núcleo:

```make oldconfig```

Realizando este script, se lee el fichero _.config_ existente y le pasa unas 
reglas de ficheros Kconfig y produce un _.config_ que es adecuado con las 
reglas Kconfig. Si hay algun valor CONFIG que falta, el script preguntará por
ellos. 

```
manuel@debian:~/KernelLinux/linux-source-4.19$ make oldconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  YACC    scripts/kconfig/zconf.tab.c
  LEX     scripts/kconfig/zconf.lex.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf  --oldconfig Kconfig
#
# using defaults found in /boot/config-4.19.0-11-amd64
#
#
# configuration written to .config
#
```

5. Cuenta el número de componentes que se han configurado para incluir en 
vmlinuz o como módulos.

```
manuel@debian:~/KernelLinux/linux-source-4.19$ grep 'm' .config | wc -l
3474
```

6. Configura el núcleo en función de los módulos que está utilizando tu equipo 
(para no incluir en la compilación muchos controladores de dispositivos que 
no utiliza el equipo):

```
manuel@debian:~/KernelLinux/linux-source-4.19$ make localmodconfig
using config: '.config'
nvidia config not found!!
vboxdrv config not found!!
vboxnetadp config not found!!
nvidia_drm config not found!!
nvidia_modeset config not found!!
vboxnetflt config not found!!
System keyring enabled but keys "debian/certs/debian-uefi-certs.pem" not found. Resetting keys to default value.
*
* Restart config...
*
*
* PCI GPIO expanders
*
AMD 8111 GPIO driver (GPIO_AMD8111) [N/m/y/?] n
BT8XX GPIO abuser (GPIO_BT8XX) [N/m/y/?] (NEW) y
OKI SEMICONDUCTOR ML7213 IOH GPIO support (GPIO_ML_IOH) [N/m/y/?] n
ACCES PCI-IDIO-16 GPIO support (GPIO_PCI_IDIO_16) [N/m/y/?] n
ACCES PCIe-IDIO-24 GPIO support (GPIO_PCIE_IDIO_24) [N/m/y/?] n
RDC R-321x GPIO support (GPIO_RDC321X) [N/m/y/?] n
*
* PCI sound devices
*
PCI sound devices (SND_PCI) [Y/n/?] y
  Analog Devices AD1889 (SND_AD1889) [N/m/?] n
  Avance Logic ALS300/ALS300+ (SND_ALS300) [N/m/?] n
  Avance Logic ALS4000 (SND_ALS4000) [N/m/?] n
  ALi M5451 PCI Audio Controller (SND_ALI5451) [N/m/?] n
  AudioScience ASIxxxx (SND_ASIHPI) [N/m/?] n
  ATI IXP AC97 Controller (SND_ATIIXP) [N/m/?] n
  ATI IXP Modem (SND_ATIIXP_MODEM) [N/m/?] n
  Aureal Advantage (SND_AU8810) [N/m/?] n
  Aureal Vortex (SND_AU8820) [N/m/?] n
  Aureal Vortex 2 (SND_AU8830) [N/m/?] n
  Emagic Audiowerk 2 (SND_AW2) [N/m/?] n
  Aztech AZF3328 / PCI168 (SND_AZT3328) [N/m/?] n
  Bt87x Audio Capture (SND_BT87X) [N/m/?] n
  SB Audigy LS / Live 24bit (SND_CA0106) [N/m/?] n
  C-Media 8338, 8738, 8768, 8770 (SND_CMIPCI) [N/m/?] n
  C-Media 8786, 8787, 8788 (Oxygen) (SND_OXYGEN) [N/m/?] n
  Cirrus Logic (Sound Fusion) CS4281 (SND_CS4281) [N/m/?] n
  Cirrus Logic (Sound Fusion) CS4280/CS461x/CS462x/CS463x (SND_CS46XX) [N/m/?] n
  Creative Sound Blaster X-Fi (SND_CTXFI) [N/m/?] n
  (Echoaudio) Darla20 (SND_DARLA20) [N/m/?] n
  (Echoaudio) Gina20 (SND_GINA20) [N/m/?] n
  (Echoaudio) Layla20 (SND_LAYLA20) [N/m/?] n
  (Echoaudio) Darla24 (SND_DARLA24) [N/m/?] n
  (Echoaudio) Gina24 (SND_GINA24) [N/m/?] n
  (Echoaudio) Layla24 (SND_LAYLA24) [N/m/?] n
  (Echoaudio) Mona (SND_MONA) [N/m/?] n
  (Echoaudio) Mia (SND_MIA) [N/m/?] n
  (Echoaudio) 3G cards (SND_ECHO3G) [N/m/?] n
  (Echoaudio) Indigo (SND_INDIGO) [N/m/?] n
  (Echoaudio) Indigo IO (SND_INDIGOIO) [N/m/?] n
  (Echoaudio) Indigo DJ (SND_INDIGODJ) [N/m/?] n
  (Echoaudio) Indigo IOx (SND_INDIGOIOX) [N/m/?] n
  (Echoaudio) Indigo DJx (SND_INDIGODJX) [N/m/?] n
  Emu10k1 (SB Live!, Audigy, E-mu APS) (SND_EMU10K1) [N/m/?] n
  Emu10k1X (Dell OEM Version) (SND_EMU10K1X) [N/m/?] n
  (Creative) Ensoniq AudioPCI 1370 (SND_ENS1370) [N/m/?] n
  (Creative) Ensoniq AudioPCI 1371/1373 (SND_ENS1371) [N/m/?] n
  ESS ES1938/1946/1969 (Solo-1) (SND_ES1938) [N/m/?] n
  ESS ES1968/1978 (Maestro-1/2/2E) (SND_ES1968) [N/m/?] n
  ForteMedia FM801 (SND_FM801) [N/m/?] n
  RME Hammerfall DSP Audio (SND_HDSP) [N/m/?] n
  RME Hammerfall DSP MADI/RayDAT/AIO (SND_HDSPM) [N/m/?] n
  ICEnsemble ICE1712 (Envy24) (SND_ICE1712) [N/m/?] n
  ICE/VT1724/1720 (Envy24HT/PT) (SND_ICE1724) [N/m/?] n
  Intel/SiS/nVidia/AMD/ALi AC97 Controller (SND_INTEL8X0) [N/m/?] n
  Intel/SiS/nVidia/AMD MC97 Modem (SND_INTEL8X0M) [N/m/?] n
  Korg 1212 IO (SND_KORG1212) [N/m/?] n
  Digigram Lola (SND_LOLA) [N/m/?] n
  Digigram LX6464ES (SND_LX6464ES) [N/m/?] n
  ESS Allegro/Maestro3 (SND_MAESTRO3) [N/m/?] n
  Digigram miXart (SND_MIXART) [N/m/?] n
  NeoMagic NM256AV/ZX (SND_NM256) [N/m/?] n
  Digigram PCXHR (SND_PCXHR) [N/m/?] n
  Conexant Riptide (SND_RIPTIDE) [N/m/?] n
  RME Digi32, 32/8, 32 PRO (SND_RME32) [N/m/?] n
  RME Digi96, 96/8, 96/8 PRO (SND_RME96) [N/m/?] n
  RME Digi9652 (Hammerfall) (SND_RME9652) [N/m/?] n
  Studio Evolution SE6X (SND_SE6X) [N/m/?] (NEW) m
  S3 SonicVibes (SND_SONICVIBES) [N/m/?] n
  Trident 4D-Wave DX/NX; SiS 7018 (SND_TRIDENT) [N/m/?] n
  VIA 82C686A/B, 8233/8235 AC97 Controller (SND_VIA82XX) [N/m/?] n
  VIA 82C686A/B, 8233 based Modems (SND_VIA82XX_MODEM) [N/m/?] n
  Asus Virtuoso 66/100/200 (Xonar) (SND_VIRTUOSO) [N/m/?] n
  Digigram VX222 (SND_VX222) [N/m/?] n
  Yamaha YMF724/740/744/754 (SND_YMFPCI) [N/m/?] n
#
# configuration written to .config
#
```

7. Vuelve a contar el número de componentes que se han configurado para incluir 
en vmlinuz o como módulos.

```
manuel@debian:~/KernelLinux/linux-source-4.19$ grep 'm' .config | wc -l
269
```

8. Realiza la primera compilación:

```make -j <número de hilos> bindeb-pkg```

Haremos un ```lscpu``` y veremos las CPU's que tenemos y el número de hilos. 

```
manuel@debian:~/KernelLinux/linux-source-4.19$ lscpu
Arquitectura:                        x86_64
modo(s) de operación de las CPUs:    32-bit, 64-bit
Orden de los bytes:                  Little Endian
Tamaños de las direcciones:          39 bits physical, 48 bits virtual
CPU(s):                              8
Lista de la(s) CPU(s) en línea:      0-7
Hilo(s) de procesamiento por núcleo: 2
Núcleo(s) por «socket»:              4
«Socket(s)»                          1
Modo(s) NUMA:                        1
ID de fabricante:                    GenuineIntel
Familia de CPU:                      6
Modelo:                              158
Nombre del modelo:                   Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
Revisión:                            9
CPU MHz:                             800.262
CPU MHz máx.:                        3800,0000
CPU MHz mín.:                        800,0000
BogoMIPS:                            5616.00
Virtualización:                      VT-x
Caché L1d:                           32K
Caché L1i:                           32K
Caché L2:                            256K
Caché L3:                            6144K
CPU(s) del nodo NUMA 0:              0-7
Indicadores:                         fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp flush_l1d
```

Viendo nuestras características, vamos a escoger 4 hilos.

```
manuel@debian:~/KernelLinux/linux-source-4.19$ make -j 4 bindeb-pkg
scripts/kconfig/conf  --syncconfig Kconfig
  UPD     include/config/kernel.release
/bin/bash ./scripts/package/mkdebian
dpkg-buildpackage -r"fakeroot -u" -a$(cat debian/arch) -b -nc -uc
dpkg-buildpackage: información: paquete fuente linux-4.19.152
dpkg-buildpackage: información: versión de las fuentes 4.19.152-1
dpkg-buildpackage: información: distribución de las fuentes buster
dpkg-buildpackage: información: fuentes modificadas por manuel <manuel@debian>
dpkg-buildpackage: información: arquitectura del sistema amd64
dpkg-buildpackage: aviso: «debian/rules» no es un fichero ejecutable, reparando
 dpkg-source --before-build .
 debian/rules build
make KERNELRELEASE=4.19.152 ARCH=x86	KBUILD_BUILD_VERSION=1 KBUILD_SRC=
  SYSTBL  arch/x86/include/generated/asm/syscalls_32.h
  WRAP    arch/x86/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/x86/include/generated/uapi/asm/poll.h
  SYSHDR  arch/x86/include/generated/asm/unistd_32_ia32.h
  UPD     include/generated/uapi/linux/version.h
  UPD     include/generated/package.h
error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel
make[3]: *** [Makefile:1144: prepare-objtool] Error 1
make[3]: *** Se espera a que terminen otras tareas....
  SYSHDR  arch/x86/include/generated/asm/unistd_64_x32.h
  SYSTBL  arch/x86/include/generated/asm/syscalls_64.h
  HYPERCALLS arch/x86/include/generated/asm/xen-hypercalls.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_x32.h
make[2]: *** [debian/rules:4: build] Error 2
dpkg-buildpackage: fallo: debian/rules build subprocess returned exit status 2
make[1]: *** [scripts/package/Makefile:80: bindeb-pkg] Error 2
make: *** [Makefile:1408: bindeb-pkg] Error 2
```

Nos aparece el siguiente error. En principio nos dice que no tenemos instalado
uno de los paquetes _libelf-dev_, _libelf-devel_ o _elfutils-libelf-devel_.

Instalaremos el paquete _libelf-dev_ y procederemos a ejecutar el comando de
nuevo. Después de un tiempo compilando, nos dejará los siguientes archivos:

```
manuel@debian:~/KernelLinux$ ls
linux-4.19.152_4.19.152-1_amd64.buildinfo
linux-4.19.152_4.19.152-1_amd64.changes
linux-headers-4.19.152_4.19.152-1_amd64.deb
linux-image-4.19.152_4.19.152-1_amd64.deb
linux-image-4.19.152-dbg_4.19.152-1_amd64.deb
linux-libc-dev_4.19.152-1_amd64.deb
linux-source-4.19
linux-source-4.19.tar.xz
```

9. Instala el núcleo resultando de la compilación, reinicia el equipo y 
comprueba que funciona adecuadamente.

Como cualquier paquete, lo instalaremos con el siguiente comando:

```
sudo dpkg -i linux-image-4.19.152_4.19.152-1_amd64.deb
```

Y reiniciamos la máquina. Tras instalarlo, como esta nueva configuración del
kernel es igual a la que ya teníamos, todo sigue funcionando adecuadamente.

10. Si ha funcionado adecuadamente, utilizamos la configuración del paso 
anterior como punto de partida y vamos a reducir el tamaño del mismo, para 
ello vamos a seleccionar elemento a elemento.

```
manuel@debian:~/KernelLinux/linux-source-4.19$ cp /boot/config-4.19.0-11-amd64 ../linux-source-4.19/.config
manuel@debian:~/KernelLinux/linux-source-4.19$ make clean
  CLEAN   .
  CLEAN   arch/x86/entry/vdso
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/purgatory
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/lib
  CLEAN   certs
  CLEAN   drivers/firmware/efi/libstub
  CLEAN   drivers/scsi
  CLEAN   drivers/tty/vt
  CLEAN   kernel
  CLEAN   lib/raid6
  CLEAN   lib
  CLEAN   net/wireless
  CLEAN   security/apparmor
  CLEAN   security/selinux
  CLEAN   security/tomoyo
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
```
   
Y procedemos con la ejecución del comando ```make xconfig```.

Ahora vamos a pasar a describir el ejercicio al final de los enunciados. (*)
11. Vuelve a contar el número de componentes que se han configurado para 
incluir en vmlinuz o como módulos.

12. Vuelve a compilar:

```make -j <número de hilos> bindeb-pkg```

13. Si se produce un error en la compilación, vuelve al paso de configuración, 
si la compilación termina correctamente, instala el nuevo núcleo y comprueba 
el arranque.

14. Continuamos reiterando el proceso poco a poco hasta conseguir el núcleo lo 
más pequeño posible que pueda arrancar en nuestro equipo.

(*) Cuando ejecutamos dicho comando, nos aparecerá la siguiente ventana con los
diferentes módulos. Iremos poco a poco retirando módulos hasta simplificar el
kernel al máximo.


En nuestra primera compilación retiramos los siguientes módulos:

1. General Setup

* _CPU Isolation_ --> se asegura de que cuando la CPU está corriendo tareas
críticas, no sea disturbado por ruido.

* Support initial ramdisk/ramfs compressed using bzip2, LZMA, XZ, LZO y LZ4 --> permite
la carga de RAM inicial codificado en bzip2, LZMA, XZ, LZO, LZ4 o con un buffer
cpio.

2. _Processor type and features_

* Intel Low Power Subsystem Support

* AMD ACPI2Platform devices support

* Old AMD GART IOMMU support

* IBM Calgary IOMMU support

* Enable support for 16-bit segments

* Numa Memory Allocation and Scheduler Support --> Old style AMD Opteron NUMA detection --> Habilita la detección de topología de nodo AMD NUMA.

* Enable the LDT (local descriptor table) --> permite a los programas del
usuario instalar LDT.

* Linux guest support

3. _Networking support_

* Amateur Radio support --> Si queremos conectar nuestro Linux con una radio
amateur.

* Bluetooth subsystem support

* RF switch subsystem support --> si queremos tener control sobre Switches RF.

4. _Device Drivers_

* Multimedia support --> Si queremos usar webcams o otros tipos de grabadores de
video.

5. _File systems_

* Old quota format support

Esta es la primera compilación realizada. Hemos pasado de tener 3381 a tener 
2885. 





