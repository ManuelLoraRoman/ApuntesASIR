# Configuración de cliente OpenVPN con certificados X.509

Para poder acceder a la red local desde el exterior, existe una red privada 
configurada con OpenVPN que utiliza certificados x509 para autenticar los 
usuarios y el servidor.

* Genera una clave privada RSA 4096

* Genera una solicitud de firma de certificado (fichero CSR) y súbelo a 
gestiona.
    
* Descarga el certificado firmado cuando esté disponible
    
* Instala y configura apropiadamente el cliente openvpn y muestra los 
registros (logs) del sistema que demuestren que se ha establecido una conexión.
    
* Cuando hayas establecido la conexión VPN tendrás acceso a la red 
172.22.0.0/16 a través de un túnel SSL. Compruébalo haciendo ping a 172.22.0.1.




