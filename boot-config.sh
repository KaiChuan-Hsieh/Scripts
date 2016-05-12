#!/bin/bash

HOST=$1

case $1 in
"kirt-server")
mount /dev/sdb ~/Disk2
ip route add 10.72.71.0/24 dev eth1
ip route add 10.193.115.0/24 dev eth1
;;
*)
echo "Input host PC name as parameter!!"
;;
esac
