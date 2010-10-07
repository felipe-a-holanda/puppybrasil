#!/bin/sh

ICONDIR="/usr/local/lib/X11/mini-icons"

. /etc/rc.d/PUPSTATE 
if [[ "$PUPMODE" = "5" ]];then 

. /usr/local/graphics-test/graphix_test
DISPLAY_TEXT=`cat /tmp/luci_recomend`
export DISPLAY_TEXT

export firstrunwiz="
<window height-request=\"440\" title=\"Welcome to Lucid Puppy\">

 <vbox>
 
 
<frame Welcome to Lucid Puppy Linux 5.1>
   <hbox width-request=\"600\"><vbox>
    <text width-request=\"536\"><label>\"The graphical desktop has been configured automatically. If the desktop is to your liking, then click the second button to connect to the Internet or OK to close this program.  
    
You can change the Video Resolution and/or Language and Locale with the buttons below.  If you want to make more changes than those, then please click for the Classic Configuration Experience.  Either way, thanks for using Puppy.\"</label></text>

    </vbox>
    <vbox> <button ok></button>
    <button tooltip-text=\"Connect to the Internet\"> <input file>$ICONDIR/net3.png</input>
          <action>exec sns</action></button>
    <text><label>\"\"</label></text>

    
   </vbox></hbox>
  </frame>
 <frame Change Video Resolution and Language & Locale>
   <hbox width-request=\"600\">
    <vbox><text width-request=\"560\"><label>\"Click here to change the video resolution, then Right-Click, Menu -> Shutdown -> Restart X server.\"</label></text>
   
    </vbox><vbox>
    <button tooltip-text=\"Change Video Resolution\">
     <input file>$ICONDIR/mini-display.xpm</input>
     <action>exec xrandrshell</action>
    </button>
   </vbox></hbox>
  <hbox width-request=\"600\">
    <vbox><text width-request=\"560\"><label>\"Click here to change the Language and Locale so that Puppy will speak your language\"</label></text>
   
    </vbox><vbox>
    <button tooltip-text=\"Change Language & Locale\">
     <input file>$ICONDIR/mini-chinese.xpm</input>
     <action>exec chooselocale</action>
    </button>
   </vbox></hbox></frame>
<frame Classic Configuration Experience>
   <hbox width-request=\"600\">
    <vbox><text width-request=\"560\"><label>\"Click here to change Keyboard Layout, Timezone, and Video Driver.  The screen will blank so please save any work that is open.  The CCE and other programs to personalize Puppy are also available from the Desktop and Setup Menus and from the 'setup' icon on the desktop.\"</label></text>
   
    </vbox><vbox>
    <button tooltip-text=\"Change Keyboard Layout, Timezone, and Video Driver\">
     <input file>$ICONDIR/prompt16.xpm</input>
     <action>exec comconexp</action>
    </button>
   </vbox></hbox></frame>
    <frame Lupu Recommends>
   <hbox width-request=\"600\">
    <vbox><text width-request=\"590\"><label>\"${DISPLAY_TEXT}\"</label></text>
   
    </vbox></hbox>
  </frame>
 </vbox> 
</window>"
gtkdialog3 -p firstrunwiz -c

unset firstrunwiz

fi
