#!/bin/bash

function usage {
    echo "command example:"
    echo "bash rockchip-efuse.sh ether: get ethernet address"
    echo "bash rockchip-efuse.sh ether <data>: write ethernet address"
    echo "bash rockchip-efuse.sh sn: get sn number"
    echo "bash rockchip-efuse.sh sn <data>: write sn number"
    exit 1
}

function read_ether {
    xxd -s 0x10 -l 6 -g 1 /sys/bus/nvmem/devices/rockchip-efuse1024/nvmem | awk '{ print $2$3$4$5$6$7 }'
    exit 1
}

function write_ether {
    PARA=$1
    if [ ${#PARA} -ne 12 ]; then
        echo "invalid input"
        exit 1
    fi
    data1="0x${PARA:6:2}${PARA:4:2}${PARA:2:2}${PARA:0:2}"
    data2="0x0000${PARA:10:2}${PARA:8:2}"
    addr1="0x10"
    addr2="0x11"

    echo "write $data1 to address $addr1"
    echo "write $data2 to address $addr2"
    echo "$addr1=$data1" > /sys/bus/nvmem/devices/rockchip-efuse1024/nvmem
    echo "$addr2=$data2" > /sys/bus/nvmem/devices/rockchip-efuse1024/nvmem

    exit 1
}

function read_sn {
    data=`xxd -s 0x12 -l 12 -g 1 /sys/bus/nvmem/devices/rockchip-efuse1024/nvmem \
        | awk '{ print $2$3$4$5$6$7$8$9$10$11$12$13 }'`

    idx=0
    while [ $idx -lt 24 ];
    do
        val=${data:$idx:2}
        tmp=$(printf "\x$val")
        SN="$SN$tmp"
        idx=$((idx+2))
    done

    echo $SN

    exit 1
}

function write_sn {
    PARA=$1
    if [ ${#PARA} -ne 12 ]; then
        echo "invalid input"
        exit 1
    fi

    idx=0
    while [ $idx -lt 12 ];
    do
        tmp=$(printf %02x \'${PARA:$idx:1})
        data="$data$tmp"
        idx=$((idx+1))
    done

    echo $data

    addr1="0x12"
    addr2="0x13"
    addr3="0x14"

    data1="0x${data:6:2}${data:4:2}${data:2:2}${data:0:2}"
    data2="0x${data:14:2}${data:12:2}${data:10:2}${data:8:2}"
    data3="0x${data:22:2}${data:20:2}${data:18:2}${data:16:2}"

    echo "write $data1 to address $addr1"
    echo "write $data2 to address $addr2"
    echo "write $data3 to address $addr3"
    echo "$addr1=$data1" > /sys/bus/nvmem/devices/rockchip-efuse1024/nvmem
    echo "$addr2=$data2" > /sys/bus/nvmem/devices/rockchip-efuse1024/nvmem
    echo "$addr3=$data3" > /sys/bus/nvmem/devices/rockchip-efuse1024/nvmem

    exit 1
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
