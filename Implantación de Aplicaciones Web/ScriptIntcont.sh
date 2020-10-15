#! /bin/bash

echo -e "Bienvenid@ a la integración continua con Docusaurus y surge.\n"

echo -e "En primer lugar, introduzca el nombre de un directorio para crear hay su página:"

read directorio

mkdir $directorio

cd $directorio

echo -e "Introduzca a continuación el nombre de su página:"

read pagina

echo -e "Ahora comprobaremos si tenemos instalado el paquete npm."

ins=`dpkg -s npm | grep -o installed`

if [ $ins="installed" ];
then
	echo -e "Ya está instalado dicho paquete"
else
	apt-get install npm > /dev/null
	echo -e "El paquete ya está instalado"
fi

npx @docusaurus/init@next init $pagina classic

cd $pagina

npm run build

cd build

echo "$pagina.surge.sh" > CNAME

surge
