#!/bin/bash


DIR='responsabilidades'
TRUNK='trunk'

if [ $# = 0 -o $# -gt 2 ];
then	
	echo "Uso: $0 [ARQUIVO] [PESSOA]"
	echo "atribui o [ARQUIVO] a [PESSOA] "
	echo ""
	echo "Uso: $0 [ARQUIVO]"
	echo "Mostra quem eh o responsavel pelo [ARQUIVO]"
	echo ""
	echo "	Este comando atribui a responsabilidade de traduzir"
	echo "	um determinado [ARQUIVO] a uma certa [PESSOA]"
	echo "	O link simbolico contido em $DIR sera movido para a pasta "
	echo "	especial da [PESSOA]"
	echo ""
	echo "	Exemplo:"
	echo "	Digamos que o Tico queira traduzir o arquivo abiword.desktop"
	echo "	contido no diretorio trunk/usr/share/applications"
	echo ""
	echo "	O comando sera: "
	echo "	./atribui.sh trunk/usr/share/applications/abiword.desktop tico"
	exit 0
fi


realpath=$(readlink -f $1)
filename=$(echo $realpath | sed  "s|[^ ]*\/||")
RESP=$(echo $realpath | sed "s|$TRUNK\/[^\/]*|$DIR\/$2|g;s|$DIR[^ ]*$|$DIR|g")

if ! [ -a $realpath ]
then
	echo "Arquivo nao encontrado!"
	exit 0
fi


quem_responsavel()
{
	for pessoa in `ls $RESP`
	do		
		if [ -a $(echo $realpath | sed "s|$TRUNK|$DIR/$pessoa|g") ] 
		then
			echo $pessoa			
		fi
	done
	return 1	
}

if [ $# = 1 ]; # quem eh o responsavel?
then
	responsavel=$(quem_responsavel)
		
	if [ -z $responsavel ];
	then
		echo ""
		echo "Ops!"
		echo "nao encontrei nenhum link simbolico para este arquivo no diretorio $DIR"
		echo "Sera que ele nao foi criado?"
	exit 0
	fi
	
	
	if [ $responsavel == 'ninguem' ]
	then
		echo "Ninguem se responsabilizou por traduzir este arquivo"
		echo "Para assumir esta responsabilizade rode o comando:"
		echo "$0 $1 [SEUNOME] "
		exit 0
	fi
	
	echo "O arquivo $filename sera traduzido por $responsavel"
	
fi

if [ $# = 2 ]; #assumir a responsabilidade
then
	responsavel=$(quem_responsavel)
	
	if [ -z $responsavel ];
		then
			echo ""
			echo "Ops!"
			echo "nao encontrei nenhum link simbolico para este arquivo no diretorio $DIR"
			echo "Sera que ele nao foi criado?"
		exit 0
	fi
	
	if [ $responsavel != 'ninguem' ];
		then
			echo "$responsavel ja se responsabilizou por traduzir $filename"
			echo ""
			echo "Voce tem certeza de que deseja mudar o responsavel?"
			echo "(sim/nao)"
			read input
			if [ -z $input ]
			then				
				echo "A responsabilidade nao foi modificada"
				exit 0
			fi
			if [ $input != 'sim' ]
			then				
				echo "A responsabilidade nao foi modificada"
				exit 0
			fi
			#echo "Vc disse sim"
			
	fi
	
	
	
	
	initdir=$(echo $realpath | sed "s|$TRUNK[^ ]*||g")
	finaldir=$(echo $realpath | sed "s|[^ ]*$TRUNK||g")
	
	oldpath="$initdir$DIR/$responsavel$finaldir"
	newpath="$initdir$DIR/$2$finaldir"
	newdir=$(echo $newpath | sed  "s|[^\/]*$||")
	
	#echo "newdir:$newdir"
	#echo $oldpath
	#echo $newpath
	echo "Viva! $2 ira traduzir $filename!"
	mkdir -p $newdir
	mv $oldpath $newpath
	
	
fi

