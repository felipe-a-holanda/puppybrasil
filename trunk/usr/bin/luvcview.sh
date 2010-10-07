#!/bin/sh
luvcview >/tmp/luvcview 2>&1
ERROR=`grep -i "error" /tmp/luvcview`
if [[ "$ERROR" != "" ]];then
 Xdialog  --msgbox "Luvcview has encountered an error. \n please unsure your webcam is connected \n and configured correctly" 0 0 0
 exit
fi