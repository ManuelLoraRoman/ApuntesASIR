#! /bin/bash

#. ./funcionesRepo.txt

# Realiza un script que introduciéndolo como parámetro el nombre de un
# repositorio, muestre como salida los paquetes de ese repositorio que
# están instalados en la máquina.



echo "\n"
echo "SELECCIÓN DE PAQUETES POR REPOSITORIO"
echo "---------------------------------------"

echo "Repositorio introducido: " $1

if echo "$1" | grep "^http\:\/\/.\.*" > /dev/null
then

	VAR=`echo "$1" | cut -f3 -d"/"`


elif echo "$1" | grep ".\.*\.*" > /dev/null
then
	echo "\nSegunda opción seleccionada\n"

else
	echo "\nError"
fi

for p in $(dpkg -l | grep '^ii' | cut -d ' ' -f 3);

# Esta primera sección del for permite visualizar el nombre de los paquetes
# instalados en nuestra máquina e iterar sobre ellos.

	do apt-cache showpkg $p | head -3 | grep -v '^Versions' | sed -e 's/Package: //;' | paste - - | grep $VAR | awk -F '\t' '{print $1}';
done;

# security.debian.org
# http://security.debian.org
