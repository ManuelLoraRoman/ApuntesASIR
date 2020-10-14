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
