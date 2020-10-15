#! /bin/bash

echo -e "Bienvenid@ a la integración continua con Docusaurus y surge.\n"

echo -e "En primer lugar, introduzca el nombre de un directorio para crear hay su página:"

read directorio

mkdir $directorio

cd $directorio

echo -e "Introduzca a continuación el nombre de su página:"

read pagina

npx @docusaurus/init@next init $pagina classic

cd $pagina

npm run build

cd build

echo "$pagina.surge.sh" > CNAME

surge
