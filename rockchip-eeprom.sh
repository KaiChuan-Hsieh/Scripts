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

function gpio {
    GPIO=$1
    ACTION=$2

    case $ACTION in
    acquire)
        echo $GPIO > /sys/class/gpio/export
        ;;
    release)
        echo $GPIO > /sys/class/gpio/unexport
        ;;
    output)
        echo out > /sys/class/gpio/gpio$GPIO/direction
        ;;
    input)
        echo in > /sys/class/gpio/gpio$GPIO/direction
        ;;
    high)
        echo 1 > /sys/class/gpio/gpio$GPIO/value
        ;;
    low)
        echo 0 > /sys/class/gpio/gpio$GPIO/value
        ;;
    *)
        echo "Unsupported Parameter"
        ;;
    esac
    sleep 1
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
    gpio 6 acquire
    gpio 6 output

    idx=0
    while [ $idx -lt 12 ];
    do
        echo -n ${PARA:$idx:2} | xxd -r -p >> mac.bin
        idx=$((idx+2))
    done

    dd if=mac.bin of=$FILEPATH bs=1 count=6 > /dev/null 2>&1
    rm mac.bin
    gpio 6 input
    gpio 6 release

    exit 1
}

function read_sn {
    data1=`xxd -s 0x6 -l 16 -g 1 $FILEPATH \
        | awk '{ print $2$3$4$5$6$7$8$9$10$11$12$13$14$15$16$17 }'`
    data2=`xxd -s 0x16 -l 4 -g 1 $FILEPATH \
        | awk '{ print $2$3$4$5 }'`

    idx=0
    while [ $idx -lt 32 ];
    do
        val=${data1:$idx:2}
        if [ $val != "00" ]
        then
            tmp=$(printf "\x$val")
            SN="$SN$tmp"
        fi
        idx=$((idx+2))
    done
    idx=0
    while [ $idx -lt 8 ];
    do
        val=${data2:$idx:2}
        if [ $val != "00" ]
        then
            tmp=$(printf "\x$val")
            SN="$SN$tmp"
        fi
        idx=$((idx+2))
    done

    echo $SN

    exit 1
}

function write_sn {
    PARA=$1
    SNLEN=${#PARA}
    if [ $SNLEN -gt 20 ]; then
        echo "invalid input"
        exit 1
    fi

    touch sn.bin
    gpio 6 acquire
    gpio 6 output

    dd if=/dev/zero of=$FILEPATH bs=1 count=20 seek=6 > /dev/null 2>&1

    idx=0
    while [ $idx -lt $SNLEN ];
    do
        tmp=$(printf %02x \'${PARA:$idx:1})
        echo -n $tmp | xxd -r -p >> sn.bin
        idx=$((idx+1))
    done

    dd if=sn.bin of=$FILEPATH bs=1 count=$SNLEN seek=6 > /dev/null 2>&1
    rm sn.bin
    gpio 6 input
    gpio 6 release

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
