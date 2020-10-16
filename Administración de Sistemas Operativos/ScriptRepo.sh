#! /bin/bash

. ./funcionesRepo.txt

# Realiza un script que introduciéndolo como parámetro el nombre de un
# repositorio, muestre como salida los paquetes de ese repositorio que
# están instalados en la máquina.

comienzo $1

sleep 1

comprobacion $1

sleep 1

listado_repo $VAR

ultimo $respuesta
