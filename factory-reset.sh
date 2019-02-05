#!/bin/bash

{
    echo admin   # Pour avoir les droits d'administation
    echo factory-reset # pour restaurer la configuration d'origine
    echo y
    echo yes
    echo list
    echo quit
} | gpg --command-fd=0 --status-fd=1 --card-edit

