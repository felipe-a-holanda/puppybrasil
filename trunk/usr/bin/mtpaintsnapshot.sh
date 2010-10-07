#!/bin/sh
#Puppy Screenshot
# Trio Tj - GPL 2009

export Screenshot="	
<window title=\"Screenshot\">
	
  <frame      Please choose     >
  <pixmap><input file>/usr/share/pixmaps/gtkam.png</input></pixmap>
  <vbox>
   <button>
    <input file icon=\"gtk-refresh\"></input>
    <label>Wait 10 Sec</label>
	<action>(echo 10; sleep 1 ; echo 20; sleep 1 ; echo 30 ; sleep 1 ; echo 40; sleep 1 ; echo 50 ; sleep 1 ; echo 60 ; sleep 1 ; echo 70 ; sleep 1 ; echo 80 ; sleep 1 ; echo 90 ; sleep 1 ; echo 100 ) | Xdialog --title 'Puppy Screenshot' --beep-after --wrap --screen-center --center --no-buttons --gauge 'Please wait & prepare your screen ' 10 50 100 ; exec mtpaint -s &</action>
	<action>exit: Screenshot</action>
   </button>
   <button>
    <input file icon=\"gtk-apply\"></input>
    <label>  Now  </label>
    <action>exec mtpaint -s &</action>
	<action>exit: Screenshot</action>
   </button>
   <button>
    <input file icon=\"gtk-quit\"></input>
    <label>Quit</label>
   </button>
 </vbox>
 </frame>
</window>"

I=$IFS; IFS=""
for STATEMENTS in  $(gtkdialog3 --program=Screenshot --center ); do
	eval $STATEMENTS
done
IFS=$I
