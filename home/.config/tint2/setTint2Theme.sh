#!/bin/bash

tint2rcTheme=$1

if [ ! -z $tint2rcTheme ]; then
    cp $tint2rcTheme ~/.config/tint2/tint2rc
else
    echo -e "\nNothing happened.\n\tPass a .tint2rc config file.\n"
fi
