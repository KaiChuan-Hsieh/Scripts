#!/bin/bash

if [ -e ".repo" ]
then
    repo sync
else
    echo "Select a branch indicated below:"
    echo "[1] l-mr1-dev-fugu"
    read -p "Selection: " choice

    case $choice in
    "1") 
        repo init -u https://partner-android.googlesource.com/platform/vendor/pdk/fugu/aosp_fugu-userdebug/manifest -b l-mr1-dev-fugu
        repo sync
        ;;
    *) 
        echo "Invalid branch"
        ;;
    esac
fi
