#!/bin/bash

function usage {
    echo "command example:"
    echo "bash rockchip-efuse.sh ether: get ethernet address"
    echo "bash rockchip-efuse.sh ether <data>: write ethernet address"
    echo "bash rockchip-efuse.sh sn: get sn number"
    echo "bash rockchip-efuse.sh sn <data>: write sn number"
}

function read_ether {
    xxd -s 0x10 -l 6 -g 1 /sys/bus/nvmem/devices/rockchip-efuse1024/nvmem | awk '{ print $2$3$4$5$6$7 }'
}

if [ "$#" -eq 1 ]; then
    PARA=$1
    case $PARA in
    ether)
        read_ether
        ;;
    sn)
        read_sn
        ;;
    *)
        echo "Unsupported parameter"
        usage
        exit 1
        ;;
    esac
fi

if [ "$#" -eq 2 ]; then
    PARA=$1
    case $PARA in
    ether)
        write_ether $2
        ;;
    sn)
        write_sn $2
        ;;
    *)
        echo "Unsupported parameters"
        usage
        exit 1
        ;;
    esac
fi

usage
