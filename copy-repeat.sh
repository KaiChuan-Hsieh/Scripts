#!/bin/sh

read -p "Source file: " src
read -p "Destination file: " dst

while [ 1 -ne 2 ];
do
    if [ -e $dst ]; then
        rm $dst
    fi
    cp $src $dst
done
