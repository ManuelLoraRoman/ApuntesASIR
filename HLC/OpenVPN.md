# Configuración de cliente OpenVPN con certificados X.509

Para poder acceder a la red local desde el exterior, existe una red privada 
configurada con OpenVPN que utiliza certificados x509 para autenticar los 
usuarios y el servidor.

* Genera una clave privada RSA 4096

Ejecutaremos el siguiente comando en la terminal de nuestra máquina:

```
manuel@debian:/media/manuel/Datos/Cosas Seguridad/VPN$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/home/manuel/.ssh/id_rsa): /home/manuel/.ssh/idVPN_rsa
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/manuel/.ssh/idVPN_rsa.
Your public key has been saved in /home/manuel/.ssh/idVPN_rsa.pub.
The key fingerprint is:
SHA256:bLuo6rNA4NT4Jw1KdVE+dAl3Jkjz45Egm3I7asl1EVE manuel@debian
The key's randomart image is:
+---[RSA 4096]----+
|   . ++X=E.o     |
|  + . *.B.=      |
|.+ + + + =       |
|= o = ..+ o      |
| + o * .S.       |
|. . * o. .       |
|.  =    .        |
| .o    . .       |
| .++... .        |
+----[SHA256]-----+
```

Y ya tendríamos generada nuestra clave.

* Genera una solicitud de firma de certificado (fichero CSR) y súbelo a 
gestiona.
    
* Descarga el certificado firmado cuando esté disponible
    
* Instala y configura apropiadamente el cliente openvpn y muestra los 
registros (logs) del sistema que demuestren que se ha establecido una conexión.
    
* Cuando hayas establecido la conexión VPN tendrás acceso a la red 
172.22.0.0/16 a través de un túnel SSL. Compruébalo haciendo ping a 172.22.0.1.




