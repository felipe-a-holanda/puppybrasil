#!/bin/bash

DIR='responsabilidades'

if [ $# != 1 -o $1 !='-s' ]
then
	echo ""
	echo "uso: $0 -s"
	echo ""
	echo "Este script cria o diretorio $DIR"
	echo "que vai guardar os links simbolicos"
	echo "de todos os arquivos do trunk"
	echo ""
	echo "deve ser invocado a partir do diretorio que contem o trunk"
	exit 0
fi

mkdir -p $DIR/ninguem
cp -rs $PWD/trunk/* $PWD/$DIR/ninguem/
if [ $? = 0 ];
then
	echo "Links criados"
else
	echo ""
	echo "Algo ruim aconteceu"
	echo ""
fi
