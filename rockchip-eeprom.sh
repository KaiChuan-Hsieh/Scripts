#!/bin/bash

FILEPATH=/sys/bus/i2c/devices/2-0050/eeprom

function usage {
    echo "command example:"
    echo "bash rockchip-eeprom.sh ether: get ethernet address"
    echo "bash rockchip-eeprom.sh ether <data>: write ethernet address"
    echo "bash rockchip-eeprom.sh sn: get sn number"
    echo "bash rockchip-eeprom.sh sn <data>: write sn number"
    exit 1
}

function read_ether {
    xxd -s 0x0 -l 6 -g 1 $FILEPATH | awk '{ print $2$3$4$5$6$7 }'
    exit 1
}

function write_ether {
    PARA=$1
    if [ ${#PARA} -ne 12 ]; then
        echo "invalid input"
        exit 1
    fi

    touch mac.bin

    idx=0
    while [ $idx -lt 12 ];
    do
        echo -n ${PARA:$idx:2} | xxd -r -p >> mac.bin
        idx=$((idx+2))
    done

    dd if=mac.bin of=$FILEPATH bs=1 count=6 > /dev/null 2>&1
    rm mac.bin

    exit 1
}

function read_sn {
    data=`xxd -s 0x6 -l 12 -g 1 $FILEPATH \
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

    touch sn.bin

    idx=0
    while [ $idx -lt 12 ];
    do
        tmp=$(printf %02x \'${PARA:$idx:1})
        data="$data$tmp"
        echo -n $tmp | xxd -r -p >> sn.bin
        idx=$((idx+1))
    done

    echo $data

    dd if=sn.bin of=$FILEPATH bs=1 count=12 seek=6 > /dev/null 2>&1
    rm sn.bin

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
        ;;
    esac
fi

usage
