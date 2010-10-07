#!/bin/sh
#Adapted from Vodaphone Mobile Connect scripts.
# This driver script functions only if the product id is not already 
# compiled into another driver and does not appear in the modules_alias file.
#This consolidates the modprobe and echo-to-new_id portions of vmc scripts: vmc-huawei, vmc-novatel, vmc-option, vmc-zte.
#It supports both Option and Sierra (vendor 1199) modems.
#It may be necessary to blacklist pl2303 and onda

VID="$1"
PID="$2"
KERNVER="`uname -r`"
MODULE="option"; SCRIPT="Option"
[ "$VID" = "1199" ] && MODULE="sierra" && SCRIPT="Sierra"
UCIDS="`echo v${VID}p${PID} | tr [a-f] [A-F]`"

if [ "`grep "^alias usb:${UCIDS}d" /lib/modules/$KERNVER/modules.alias | grep " $MODULE"`" = "" ];then
 /sbin/pup_event_backend_modprobe $MODULE
 echo "0x${VID} 0x${PID}" > /sys/bus/usb-serial/drivers/${MODULE}1/new_id
 sleep 5
 
 #Run modem initialization script to detect modem.
 [ ! -e /tmp/usb_modeswitch_active ] && /etc/init.d/$SCRIPT start
fi

### END ###