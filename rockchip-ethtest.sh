#!/bin/sh

PARA=$1

function usage {
    echo "Operations list:"
    echo "<enable>: enable Test Mode"
    echo "<disable>: disable Test Mode"
    echo "<giga_mode1_start>: start Giga Mode 1 Test"
    echo "<giga_mode1_stop>: stop Giga Mode 1 Test"
    echo "<giga_mode4_start>: start Giga Mode 4 Test"
    echo "<giga_mode4_stop>: stop Giga Mode 4 Test"
    echo "<mlt3_channelA>: MLT-3 Test from channel A"
    echo "<mlt3_channelB>: MLT-3 Test from channel B"
    echo "<mlt3_stop>: Stop MLT-3 Test"
}

if [ "$#" -ne 1 ]; then
    echo "Usage: rockchip-ethtest.sh <operation>"
    usage
    exit 1
fi

case $PARA in
enable)
    echo "Enable Test Mode"
    echo "31 $((16#0005))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "5 $((16#8b86))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "6 $((16#e200))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "31 $((16#0007))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "30 $((16#0020))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "21 $((16#0108))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
disable)
    echo "Disable Test Mode"
    echo "31 $((16#0005))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "5 $((16#8b86))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "6 $((16#e201))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "31 $((16#0007))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "30 $((16#0020))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "21 $((16#1108))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
giga_mode1_start)
    echo "Giga Mode 1 Test Start"
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "9 $((16#2000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
giga_mode1_stop)
    echo "Giga Mode 1 Test Stop"
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "9 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
giga_mode4_start)
    echo "Giga Mode 4 Test Start"
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "9 $((16#8000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
giga_mode4_stop)
    echo "Giga Mode 4 Test Stop"
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "9 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
mlt3_channelA)
    echo "Output MLT-3 from Channel A"
    echo "31 $((16#0007))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "30 $((16#002f))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "23 $((16#d818))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "30 $((16#002d))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "24 $((16#f060))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "16 $((16#00ae))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
mlt3_channelB)
    echo "Output MLT-3 from Channel B"
    echo "31 $((16#0007))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "30 $((16#002f))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "23 $((16#d818))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "30 $((16#002d))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "24 $((16#f060))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "16 $((16#008e))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
mlt3_stop)
    echo "Stop MLT-3"
    echo "31 $((16#0007))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "30 $((16#002f))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "23 $((16#d88f))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "30 $((16#002d))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "24 $((16#f050))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "31 $((16#0000))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    echo "16 $((16#006e))" > /sys/bus/mdio_bus/devices/stmmac-0\:00/phy_registers
    ;;
*)
    echo "Unsupport Command"
    ;;
esac
