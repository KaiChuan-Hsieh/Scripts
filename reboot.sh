#!/bin/bash

count=0

while [ 1 -ne 2 ]
do
    count=$((count+1))
    echo "##########################"
    echo "#### THE $count ROUND ####"
    echo "##########################"
    echo "#########################"
    echo "#### WAIT-FOR-DEVICE ####"
    echo "#########################"
    adb wait-for-device
    res=$(adb shell getprop sys.boot_completed)
    while [ "${res:0:1}" != "1" ]
    do
        echo "#################################"
        echo "#### WAIT FOR BOOT COMPLETED ####"
        echo "#################################"
        sleep 10
        res=$(adb shell getprop sys.boot_completed)
    done
    echo "############################"
    echo "#### CHECK BOOT UP LOGS ####"
    echo "############################"
    adb root
    adb wait-for-device
    adb shell cat /data/logs/aplog > aplog_tmp.txt
    res=$(grep "Error temp mounting decrypted block device" aplog_tmp.txt)
    if [ ! -z "$res" ]; then
        echo "Hit blocking situation"
        break
    fi
    echo "########################################"
    echo "#### BOOT COMPLETED WAIT 10 SECONDS ####"
    echo "########################################"
    sleep 10
    echo "#######################"
    echo "#### REBOOT DEVICE ####"
    echo "#######################"
    adb reboot
    echo "##########################"
    echo "#### SLEEP 20 SECONDS ####"
    echo "##########################"
    sleep 20
done
