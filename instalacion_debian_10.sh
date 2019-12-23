#!/bin/bash

# This script is intended to perform initial configurations for my debian 10
# installations. It will download and install some software and create user
# accounts in order to automate the process

# Only if a user is root the script will be executed
if [[ "${UID}" -ne 0 ]]
then
	echo 'Por favor, para ejecutar este script debes tener privilegios administrativos.'
	exit 1	
fi

# First we upgrade the system

echo "¿Quieres actualizar las fuentes de software?"
read -p "y/n > " OPTION

if [[ "$OPTION" == "Y" || "$OPTION" == "y" ]]
then
	apt update
fi

echo "¿Quieres actualizar el software?"
read -p "y/n > " OPTION

if [[ "$OPTION" == "Y" || "$OPTION" == "y" ]]
then
	apt upgrade
fi

# Instalo keepassXC
echo "¿Quieres instalar keepassxc?"
read -p "y/n > " OPTION

if [[ "$OPTION" == "Y" || "$OPTION" == "y" ]]
then
	apt-get install -y keepassxc
fi

# Creo el usuario FSIE con password Fsievalencia
echo "¿Quieres crear el usuario FSIE VALENCIA?"
read -p "y/n > " OPTION

if [[ "$OPTION" == "Y" || "$OPTION" == "y" ]]
then
	useradd -c "FSIE VALENCIA" -m fsievalencia
	# Check if the useradd command succeded
	if [[ "${?}" -ne 0 ]]
	then
		echo "Error ${?}. Can't create the account"
	else	
		# Force password change on first login
		# passwd -e fsievalencia	
		# Set fsievalencia's password to Fsievalencia
		echo "fsievalencia:Fsievalencia" | chpasswd
		# echo -e "Fsievalencia\nFsievalencia" | passwd fsievalencia	
	fi
fi


# Create as many users as the person who runs the script want.

OPTION="y"

while [[ "$OPTION" == "Y" || "$OPTION" == "y" ]]
do
	echo "¿Quieres crear un usuario?"
	read -p "y/n > " OPTION
	
	if [[ "$OPTION" == "Y" || "$OPTION" == "y" ]]
	then
		read -p "Enter the user name: " USER_NAME
		read -p "Enter the person's name whom this account is for: " COMMENT
		
		#Create the user
		useradd -c "${COMMENT}" -m ${USER_NAME}
			
		# Check if the useradd command succeded
		if [[ "${?}" -ne 0 ]]
		then
			echo "Error ${?}. It wasn't be able to create the account"
		else
			# Force password change on first loginp
			echo "${USER_NAME}:qazwsxedc" | chpasswd
			passwd -e ${USER_NAME}
			if [[ "${?}" -ne 0 ]]
			then
				echo "Error ${?}. The password's change on first login couldn't be set"				
			else
				echo "${USER_NAME} must change his password on next login"			
			fi
		fi
	fi
done

