#!/bin/sh
#icewm configuration ver 0.6
#01micko gpl 2010
#credit to tronkel for the idea, thanks Jack
#20100730
#20100731 #added check to see if icewm is running, added taskbar position, top/bottom, added autohide option
#20100801 #added window list on taskbar
#20100802 #added show/hide cpu status 

CURWM=`head -c5 /etc/windowmanager`
if [[ $CURWM != icewm ]];then Xdialog --title "Icewm" --timeout 6 --msgbox "You are not running Icewm. \nIcewm needs to be running to use this tool."  0 0 0 &
	exit
fi
IMGDIR="/usr/share/pixmaps"

. $HOME/.icewm/preferences 2>/dev/null
if [ "$ShowTaskBar" = "1" ];then CHKBOX1=true
	else CHKBOX1=false
fi
if [ "$TaskBarShowShowDesktopButton" = "1" ];then CHKBOX2=true
	else CHKBOX2=false
fi
if [ "$TaskBarShowWindowIcons" = "1" ];then CHKBOX3=true
	else CHKBOX3=false
fi
if [ "$TaskBarDoubleHeight" = "0" ];then CHKBOX4=true
	else CHKBOX4=false
fi
if [ "$TaskBarAtTop" = "0" ];then CHKBOX5=true
	else CHKBOX5=false
fi
if [ "$TaskBarAutoHide" = "0" ];then CHKBOX6=true
	else CHKBOX6=false
fi
if [ "$TaskBarShowWindowListMenu" = "0" ];then CHKBOX7=true
	else CHKBOX7=false
fi
if [ "$TaskBarShowCPUStatus" = "0" ];then CHKBOX8=true
	else CHKBOX8=false
fi
#desktop number function
function DESKTOPS(){
	REPLACE=`grep 'WorkspaceNames' $HOME/.icewm/preferences`
	if [ "$NUM" = "1" ];then rpl -q "$REPLACE" "WorkspaceNames = \" 1 \"" $HOME/.icewm/preferences
		elif [ "$NUM" = "2" ];then rpl -q "$REPLACE" "WorkspaceNames = \" 1 \", \" 2 \"" $HOME/.icewm/preferences
		elif [ "$NUM" = "3" ];then rpl -q "$REPLACE" "WorkspaceNames = \" 1 \", \" 2 \", \" 3 \"" $HOME/.icewm/preferences
		elif [ "$NUM" = "4" ];then rpl -q "$REPLACE" "WorkspaceNames = \" 1 \", \" 2 \", \" 3 \", \" 4 \"" $HOME/.icewm/preferences
	fi
}
export -f DESKTOPS

function MSG(){
	Xdialog --title "Icewm" --timeout 10 --msgbox "Please restart Icewm from: \n Start > Shutdown > Restart Icewm"  0 0 0 &
}
export -f MSG

NUM="`grep 'WorkspaceNames' $HOME/.icewm/preferences|tail -c4|head -c1`"
NUMBERS="<item>$NUM</item>" 
for I in 1 2 3 4; do NUMBERS=`echo "$NUMBERS<item>$I</item>"`; done 

#MAIN GUI
export MAIN="
<window title=\"Icewm Configuration\" resizable=\"false\">
 <vbox>
  <hbox homogeneous=\"true\">
   <pixmap>
    <input file>$IMGDIR/icewm-logo.png</input>
   </pixmap>
  </hbox>
   <frame Choose your Icewm options>
   <checkbox tooltip-text=\"Checked shows Taskbar, Unchecked hides Taskbar\">
     <label>Toggles Show/Hide Taskbar</label>
	  <variable>CHKBOX1</variable>
	  <action>if true rpl 'ShowTaskBar=0' 'ShowTaskBar=1' $HOME/.icewm/preferences 2>/dev/null</action>
	  <action>if false rpl 'ShowTaskBar=1' 'ShowTaskBar=0' $HOME/.icewm/preferences 2>/dev/null</action>
	  <default>$CHKBOX1</default>
	</checkbox>
	<checkbox tooltip-text=\"Checked shows Show Desktop Button, Unchecked hides Show Desktop Button\">
     <label>Toggles Show/Hide Show Desktop Button</label>
	  <variable>CHKBOX2</variable>
	  <action>if true rpl 'TaskBarShowShowDesktopButton=0' 'TaskBarShowShowDesktopButton=1' $HOME/.icewm/preferences 2>/dev/null</action>
	  <action>if false rpl 'TaskBarShowShowDesktopButton=1' 'TaskBarShowShowDesktopButton=0' $HOME/.icewm/preferences 2>/dev/null</action>
	  <default>$CHKBOX2</default>
	</checkbox>
	<checkbox tooltip-text=\"Checked shows Taskbar Window Icons, Unchecked hides Taskbar Window Icons\">
     <label>Toggles Show/Hide Taskbar Window Icons</label>
	  <variable>CHKBOX3</variable>
	  <action>if true rpl 'TaskBarShowWindowIcons=0' 'TaskBarShowWindowIcons=1' $HOME/.icewm/preferences 2>/dev/null</action>
	  <action>if false rpl 'TaskBarShowWindowIcons=1' 'TaskBarShowWindowIcons=0' $HOME/.icewm/preferences 2>/dev/null</action>
	  <default>$CHKBOX3</default>
	</checkbox>
	<checkbox tooltip-text=\"Checked shows normal Taskbar Height, Unchecked Doubles Taskbar Height\">
     <label>Toggles Single/Double Taskbar Height</label>
	  <variable>CHKBOX4</variable>
	  <action>if true rpl 'TaskBarDoubleHeight=1' 'TaskBarDoubleHeight=0' $HOME/.icewm/preferences 2>/dev/null</action>
	  <action>if false rpl 'TaskBarDoubleHeight=0' 'TaskBarDoubleHeight=1' $HOME/.icewm/preferences 2>/dev/null</action>
	  <default>$CHKBOX4</default>
	</checkbox>
	<checkbox tooltip-text=\"Checked shows Taskbar at bottom of screen, Unchecked at top\">
     <label>Toggles Bottom/Top Taskbar Position</label>
	  <variable>CHKBOX5</variable>
	  <action>if true rpl 'TaskBarAtTop=1' 'TaskBarAtTop=0' $HOME/.icewm/preferences 2>/dev/null</action>
	  <action>if false rpl 'TaskBarAtTop=0' 'TaskBarAtTop=1' $HOME/.icewm/preferences 2>/dev/null</action>
	  <default>$CHKBOX5</default>
	</checkbox>
	<checkbox tooltip-text=\"Unchecked Auto Hides the Taskbar\">
     <label>Toggles Show/Autohide the Taskbar</label>
	  <variable>CHKBOX6</variable>
	  <action>if true rpl 'TaskBarAutoHide=1' 'TaskBarAutoHide=0' $HOME/.icewm/preferences 2>/dev/null</action>
	  <action>if false rpl 'TaskBarAutoHide=0' 'TaskBarAutoHide=1' $HOME/.icewm/preferences 2>/dev/null</action>
	  <default>$CHKBOX6</default>
	</checkbox>
	<checkbox tooltip-text=\"Checked hides Window List Button on Taskbar, Unchecked shows\">
     <label>Toggles Show/Hide Window List button</label>
	  <variable>CHKBOX7</variable>
	  <action>if true rpl 'TaskBarShowWindowListMenu=1' 'TaskBarShowWindowListMenu=0' $HOME/.icewm/preferences 2>/dev/null</action>
	  <action>if false rpl 'TaskBarShowWindowListMenu=0' 'TaskBarShowWindowListMenu=1' $HOME/.icewm/preferences 2>/dev/null</action>
	  <default>$CHKBOX7</default>
	</checkbox>
	<checkbox tooltip-text=\"Checked hides CPU Status in System Tray, Unchecked shows\">
     <label>Toggles Hide/Show CPU Status in System Tray</label>
	  <variable>CHKBOX8</variable>
	  <action>if true rpl 'TaskBarShowCPUStatus=1' 'TaskBarShowCPUStatus=0' $HOME/.icewm/preferences 2>/dev/null</action>
	  <action>if false rpl 'TaskBarShowCPUStatus=0' 'TaskBarShowCPUStatus=1' $HOME/.icewm/preferences 2>/dev/null</action>
	  <default>$CHKBOX8</default>
	</checkbox>
   <hbox>
    <combobox width-request=\"50\">
	 <variable>NUM</variable>
$NUMBERS
	</combobox>
	<text><label>Set number of Desktops In Taskbar</label></text>
   </hbox>
   </frame>
   <hbox>
	<button ok>
	 <action>DESKTOPS</action>
	 <action>MSG</action>
	 <action>EXIT:OK</action>
	</button>
   </hbox>
 </vbox>
</window>"
gtkdialog3 -p MAIN
unset MAIN
	  
	