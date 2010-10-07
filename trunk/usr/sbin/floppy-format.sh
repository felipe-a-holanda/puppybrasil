#!/bin/sh
#Format floppy disks
#Copyright (c) Barry Kauler 2004 www.goosee.com/puppy
#2007 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html)

zapfloppy()
{
# Puppy will only allow 1440, 1680K and 1760K capacities.
ERR0=1
while [ ! $ERR0 -eq 0 ];do
xmessage -bg "#c0ffff" -center -title "Please wait..." -buttons "" "Low-level formatting disk with $1 Kbyte capacity" &
 fdformat /dev/fd0u$1
 ERR0=$?
 killall xmessage
 if [ ! $ERR0 -eq 0 ];then
  xmessage -bg "#ffe0e0" -name "loformat" -title "Puppy Lo-level Formatter" -center \
  -buttons "Try again":20,"QUIT":10 -file -<<XMSG
ERROR low-level formatting disk.
Is the write-protect tab closed?
XMSG

  AN0=$?
  if [ $AN0 -eq 10 ];then
   ERR0=0
  fi
  if [ $AN0 -eq 0 ];then
   ERR0=0
  fi
  if [ $AN0 -eq 1 ];then
   ERR0=0
  fi
 else
  INTROMSG="`
echo "SUCCESS!"
echo -e "Now you should press the \"Msdos/vfat filesystem\" button."
`"
 fi
done
}

fsfloppy()
{
echo "Creating msdos filesystem on the disk..."
ERR1=1
while [ ! $ERR1 -eq 0 ];do
xmessage -bg "#c0ffff" -center -title "Please wait..." -buttons "" "Creating msdos/vfat filesystem on floppy disk" &
 mkfs.msdos -c /dev/fd0u$1
 #mformat -f $1 a:
 #mbadblocks a:
 ERR1=$?
 killall xmessage
 if [ ! $ERR1 -eq 0 ];then
  xmessage -bg "#ffe0e0" -name "msdosvfat" -title "Floppy msdos/vfat filesystem" -center \
  -buttons "Try again":20,"QUIT":10 -file -<<XMSG
ERROR creating msdos/vfat filesystem on the floppy disk.
Is the write-protect tab closed?
XMSG

  AN0=$?
  if [ $AN0 -eq 10 ];then
   ERR1=0
  fi
  if [ $AN0 -eq 0 ];then
   ERR1=0
  fi
  if [ $AN0 -eq 1 ];then
   ERR1=0
  fi
 else
  INTROMSG="`
echo "SUCCESS!"
echo "The floppy disk is now ready to be used."
echo "Use the Puppy Drive Mounter to mount it."
echo "(NOTE: if you use the MToolsFM floppy file"
echo " manager, the floppy drive is accessed directly,"
echo " so do NOT use the Puppy Drive Mounter)"
echo "First though, press EXIT to get out of here..."
`"
 fi
done
sync
echo "...done."
echo " "
}

INTROMSG="`
echo "WELCOME!"
echo "My Puppy Floppy Formatter only formats floppies with"
echo "1440 Kbyte capacity and with the msdos/vfat filesystem,"
echo "for interchangeability with Windows."
echo " "
echo "You only need to lo-level format if the disk is formatted"
echo "with some other capacity, or it is corrupted. You do not"
echo "have to lo-level format a new disk, but may do so to"
echo "check its integrity."
echo "A disk is NOT usable if it is only lo-level formatted: it"
echo "also must have a filesystem, so this must always be the"
echo "second step."
echo "Doing step-2 only, that is, creating a filesystem on a"
echo "disk, is also a method for wiping any existing files."
`"

#big loop...
while :; do

MNTDMSG=" "
mount | grep "/dev/fd0" > /dev/null 2>&1
if [ $? -eq 0 ];then #=0 if string found
 CURRENTMNT="`mount | grep "/dev/fd0" | cut -f 3 -d ' '`"
 #this tells Rox to close any window with this directory and subdirectories open...
 rox -D "$CURRENTMNT"
 sync
 umount "$CURRENTMNT" #/mnt/floppy
 if [ ! $? -eq 0 ];then
  MNTDMSG="`
echo " "
echo "Puppy found a floppy disk already mounted in the drive, but"
echo "is not able to unmount it. The disk must be unmounted now."
echo "Please use the Puppy Drive Mounter (in the File Manager menu)"
echo "to unmount the floppy disk. DO THIS FIRST!"
echo " "
`"
 else
  MNTDMSG="`
echo " "
echo "Puppy found that the floppy disk was mounted, but has now"
echo "unmounted it. Now ok to format disk."
echo " "
`"
 fi
fi

xmessage -bg "#e0ffe0" -name "pformat" -title "Puppy Floppy Formatter" -center \
-buttons "Lo-level Format":20,"Msdos/vfat filesystem":30,"EXIT":10 -file -<<XMSG
$INTROMSG
$MNTDMSG
Press a button:
XMSG

ANS=$?

if [ $ANS -eq 0 ]; then
 break
fi
if [ $ANS -eq 1 ]; then
 break
fi
if [ $ANS -eq 10 ]; then
 break
fi

if [ $ANS -eq 20 ];then #format
 zapfloppy 1440
fi

if [ $ANS -eq 30 ];then #vfat
 fsfloppy 1440
fi

done
