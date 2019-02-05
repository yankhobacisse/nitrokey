#!/bin/bash

 # Restauration de la configuration d'usine
{
	echo admin   # Pour avoir les droits d'admin
	echo factory-reset # pour restaurer la configuration d'origine
	echo y
	echo yes
       	echo quit    # quit l'edition de la carte                                               
} | gpg --command-fd=0 --status-fd=1 --card-edit

# changement du pin admin
{
	echo admin
	echo passwd
	echo 3
	echo Q
	echo quit
} | gpg --command-fd=0 --status-fd=1 --card-edit

# Les algorithmes supportés par nitrokey pro sont rsa 2048 à rsa 4096
#changement de la taille des clefs
{
	echo admin      # Pour avoir le droit d'exucter les droits d'administrateur
	echo key-attr   # pour changer la longueur des clefs ou les algorithmes
	echo 1          # (1)RSA (2)ECC RSA pour la signature ie ici la seul algorithme supporté
	echo 2048       # 2048-4096 la taille de la sous clefs de signature
	echo 1          # (1)RSA (2)ECC RSA pour la sous clef de chiffrement
	echo 2048       # 2048-4096 la taille de la sous clef de chiffrement
	echo 1          # (1)RSA (2)ECC RSA pour la sous clef d' authentification
	echo 2048       # 2048-4096 la taille de la sous clef d'authentification
	echo quit
} | gpg --command-fd=0 --status-fd=1 --card-edit


