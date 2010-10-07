#!/bin/sh



copia_scripts()
#copia os shell scripts do diretorio passado como argumento
{
	
	echo $1
	for arquivo in `ls $1`
	do
		x=10
		tipo=`file $1/$arquivo`
		if (echo $tipo | grep 'shell script')
		then
			cp --parents $1/$arquivo trunk
			echo $arquivo
	
		fi
	done
}



######################################

mkdir trunk


# Copia configurações dos menus
cp --recursive --parents /etc/xdg trunk

# Copia os menus
cp --recursive --parents /usr/share/desktop-directories trunk

# Copia as entradas de menus dos programas
cp --recursive --parents /usr/share/applications trunk


# Copia os atalhos do desktop
cp --recursive --parents /root/Choices/ROX-Filer trunk


# Copia a documentação
cp --recursive --parents /usr/share/doc trunk

#TODO:
# 
# Copiar os arquivos de outros programas
#

# Copia os shell scripts
# (Lento!)
copia_scripts '/usr/bin'
copia_scripts '/usr/sbin'


