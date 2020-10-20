#! /bin/bash

echo -e "Bienvenid@ a la integración continua con Docusaurus y surge.\n"

echo -e "En primer lugar, introduzca el nombre de un directorio donde irán sus páginas:"

read directorio

if [ -d $directorio ]
then
	cd $directorio

else
	mkdir $directorio

	cd $directorio
fi

echo -e "Introduzca a continuación el nombre de su página:"

read pagina

echo -e "Ahora comprobaremos si tenemos instalado el paquete npm."

ins=`dpkg -s npm | grep -o installed`

if [ $ins="installed" ];
then
	echo -e "Ya está instalado dicho paquete."
else
	apt-get install npm > /dev/null
	echo -e "El paquete ya está instalado."
fi

if [ -d $pagina ]
then
	echo -e "El directorio $pagina ya existe."
else
	npx @docusaurus/init@next init $pagina classic
fi

cd $pagina

if [ -d build ]
then
	echo -e "El directorio de contenidos estáticos ya está creado."
	echo -e "¿Desea actualizar su contenido?(S/N)"
	read respuesta

	if [ $respuesta="S" ]
	then
		npm run build
	else
		echo -e "No se actualizará el directorio"
else
	npm run build
fi

cd build

if [ -f CNAME ]
then
	echo -e "El fichero CNAME ya existe, por lo tanto se procederá al despliegue"
else
	echo "$pagina.surge.sh" > CNAME
fi

surge
