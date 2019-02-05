#!/bin/bash

#on demande les information relatives à chaque utilsatuer   
flag=false
choice=""
NAME=""
while [ $flag = false ]
do
	read -p  "ENTREZ VOTRE NOM " NAME
	read -p  "Etes-vous sûr de votre choix y/n" choice
	if [ "$choice" = "y" ] || [ "$choice" = "Y" ]
	then
		flag=true
		break
																								                fi
																									
done


flag=false
choice=""
while [ $flag = false ]
do
	read -p  "ENTREZ VOTRE PRENOM " PRENOM
	read -p  "Etes-vous sûr de votre choix y/n" choice
	if [ "$choice" = "y" ] || [ "$choice" = "Y" ]
	then
		flag=true
		break
	fi
done
    
flag=false
choice=""

while [ $flag = false ]
do
	read -p  "ENTREZ VOTRE CUID " CUID
	read -p  "Etes-vous sûr de votre choix y/n" choice
	if [ "$choice" = "y" ] || [ "$choice" = "Y" ]
	then
		flag=true
		break
	fi
done

flag=false
choice=""
# l'email doit être du domaine d'orange (orange.fr, orange.com ...)
while [ $flag = false ]
do
	read -p  "ENTREZ VOTRE EMAIL " new_email
	read -p  "Etes-vous sûr de votre choix y/n" choice
	if [ "$choice"  = "y" ] || [ "$choice"  = "Y" ]
	then 
		domain=`echo $new_email | cut -d'@' -f2 | cut -d'.' -f1`
			
                if [ "$domain" = "orange" ] 
		then
		
                	falg=true
                        break
                fi
	fi
done

# Personalisation de la carte à puce
{
	echo admin   # Pour executer les droits d'adminstrateur   	
	echo passwd  # Pour changer les PIN utilisateur ou adminstrateur
	echo 1       # Changer le PIN administrateur
	echo q       # Quitter le changement de PIN
	echo name    # Pour changer le nom de utilsateur
	echo "$PRENOM"    # Prenon de l'utilsateur
	echo "$NAME"    # Nom de l'utilsateur
	echo login   # Pour changer le login
	echo "$NAME" # le login de l'utilsateur
	echo sex     # le sex de l'utilsateur
	echo M       # (M)ale (F)emele ou espace si inconu
	echo lang    # pour changer la langue
	echo fr      # fr pour français, en pour englais
	echo list    # afficher les information de la carte
	echo quit    # quit l'edition de la carte
} | gpg --command-fd=0 --status-fd=1 --card-edit

realname="$NAME$PRENOM$CUID"
#Generation d'une paire de clefs dans le token sans copie locale
{
	echo admin       # Pour avoir le droit d'exucter les droits d'administrateur
	echo generate    # pour generer les clefs dans le token
	echo n           # (o/n) pas de copie locale
	echo 0           # la clef n'expire jamais
	echo O           # un oui de confirmation
	echo "$realname"     # le real name du proprietaire de la clefs
	echo "$new_email"     # l'addresse email du proprietaire de la cles
	echo nocomment # pas de commentaire
	echo o           # un oui de confirmation des information pour la clef
	echo list        # affichage des informations dans la carte
	echo quit
} | gpg --command-fd=0 --status-fd=1 --card-edit	

#on creer le repertoire pubkeys s'il n'existe pas pour stocker les clefs publiques
if [ ! -d  $(pwd)/pubkeys ]
then
	mkdir -p  $(pwd)/pubkeys
fi
#on creer une reportoire pour les noms des participant
if [ ! -d $(pwd)/realname ]
then
        mkdir -p $(pwd)/realname
fi
pubIdentifiant=`gpg2 --with-colons --list-keys $new_email  | grep '^pub' | cut -d ':' -f 5 | cut -c9-16 `      list_clef="$list_clef $realname "
echo "$realname" >>$(pwd)/realname/"$realname.name"
#on exporte la clefs publique dans le repertoire pubkeys
gpg --export "$pubIdentifiant" | base64 --wrap=0 >>$(pwd)/pubkeys/"$realname.pub"

#on creer le repertoire pubkeys s'il n'existe pas pour stocker les clefs publiques
if [ ! -d  $(pwd)/pubkeys_for_windows ]
then
        mkdir -p  $(pwd)/pubkeys_for_windows
fi

gpg --armor --export "$pubIdentifiant" >>$(pwd)/pubkeys_for_windows/"$realname.pub"
