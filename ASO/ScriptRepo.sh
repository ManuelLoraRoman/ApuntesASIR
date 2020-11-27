#! /bin/sh

. ./funcionesRepo.txt

# Realiza un script que introduciéndolo como parámetro el nombre de un
# repositorio, muestre como salida los paquetes de ese repositorio que
# están instalados en la máquina.

comienzo

sleep 1

comprobacion $repositorio

sleep 1

listado_repo $VAR

ultimo $respuesta
