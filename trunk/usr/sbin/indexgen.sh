#!/bin/bash
#(c) Copyright Barry Kauler 2009, puppylinux.com.
#2009 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html)
#generates index.html master help page. called from petget, rc.update,
#  /usr/local/petget/installpreview.sh, 3builddistro (in Woof).
#w012 commented-out drop-down for all installed pkgs as too big in Ubuntu-Puppy.
#w016 support/find_homepages (in Woof) used to manually update HOMEPAGEDB variable.
#w019 now have /root/.packages/PKGS_HOMEPAGES
#w464 reintroduce dropdown help for all builtin packages.
#v423 file PKGS_HOMEPAGES is now a db of all known pkgs, not just in puppy.

export LANG=C
. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION
. /root/.packages/DISTRO_PKGS_SPECS

WKGDIR="`pwd`"

#search for installed pkgs with descriptions...

#search .desktop files...
PKGINFO1="`ls -1 /usr/share/applications | sed -e 's%^%/usr/share/applications/%' | xargs cat - | grep '^Name=' | cut -f 2 -d '='`"
#...normal format of each entry is 'name description', ex: 'Geany text editor'.

#w012 commented out...
##search pkg database...
##want to get entries 'nameonly|description', ex: 'abiword|A wonderful wordprocessor'
##user-installed...
#USER_INSTALLED_INFO="`cut -f 2,10 -d '|' /root/.packages/user-installed-packages`"
##builtin pet pkgs...
#if [ ! -f /tmp/petget_builtin_pet ];then
# BUILTIN_PET_NAMES="`echo "$PKGS_SPECS_TABLE" | grep '^yes' | cut -f 2,3 -d '|' | grep '|$' | sed -e 's%^%|%'`" #ex: '|abiword|'
# echo "$BUILTIN_PET_NAMES" > /tmp/petget_builtin_pet
#fi
#BUILTIN_PET_INFO="`grep --file=/tmp/petget_builtin_pet /root/.packages/Packages-puppy-* | cut -f 2-9 -d ':' | cut -f 2,10 -d '|'`"
##builtin compatible-distro pkgs...
#if [ ! -f /tmp/petget_builtin_system ];then #pkg_chooser.sh creates this.
# BUILTIN_COMPAT_NAMES="`echo "$PKGS_SPECS_TABLE" | grep '^yes' | cut -f 3 -d '|' | tr ',' '\n' | sort -u | grep -v '^$' | sed -e 's%[0-9]$%%' -e 's%\\-%\\\\-%g' -e 's%\\*%.*%g' -e 's%^%^%'`"
# echo "$BUILTIN_COMPAT_NAMES" >/tmp/petget_builtin_system
#fi
#BUILTIN_COMPAT_INFO="`grep --file=/tmp/petget_builtin_system /root/.packages/Packages-${DISTRO_BINARY_COMPAT}-*  | cut -f 2-9 -d ':' | cut -f 2,10 -d '|'`"
#PKGINFODB="${USER_INSTALLED_INFO}
#${BUILTIN_PET_INFO}
#${BUILTIN_COMPAT_INFO}"
##tidy it up...
#PKGINFODB="`echo "$PKGINFODB" | grep -v -E '_DEV|_DOC|_NLD' | sort --key=1 --field-separator='|' --unique | sed -e 's%|%||||||||||||||||||||||||||||||%' | uniq --check-chars=32 | tr -s '|'`"
##...code on end gets rid of multiple hits.

EXCLLISTsd=" 0rootfs_skeleton autologin bootflash burniso2cd cd/dvd check configure desktop format network pupdvdtool wallpaper pbackup pburn pcdripper pdict pdisk pdvdrsab pmetatagger pschedule pstopwatch prename pprocess pmirror pfind pcdripper pmount puppy pupctorrent pupscan pupx pwireless set text "

cp -f /usr/share/doc/index.html.top /tmp/newinfoindex.xml

#dropdown menu for apps in menu...
echo '<p>Applications available in the desktop menu:</p>' >>/tmp/newinfoindex.xml
echo '<center>
<form name="form">
<select name="site" size="1" onchange="javascript:formHandler()">
' >>/tmp/newinfoindex.xml
echo "$PKGINFO1" |
while read ONEINFO
do
 NAMEONLY="`echo "$ONEINFO" | cut -f 1 -d ' ' | tr [A-Z] [a-z]`"
 EXPATTERN=" $NAMEONLY "
 nEXPATTERN="^$NAMEONLY "
 [ "`echo "$EXCLLISTsd" | grep -i "$EXPATTERN"`" != "" ] && continue
 HOMESITE="http://en.wikipedia.org/wiki/${NAMEONLY}"
 REALHOME="`cat /root/.packages/PKGS_HOMEPAGES | grep -i "$nEXPATTERN" | head -n 1 | cut -f 2 -d ' '`"
 [ "$REALHOME" != "" ] && HOMESITE="$REALHOME"
 echo "<option value=\"${HOMESITE}\">${ONEINFO}" >> /tmp/newinfoindex.xml
done
echo '</select>
</form>
</center>
' >> /tmp/newinfoindex.xml

#w464 dropdown list of all builtin pkgs...
echo '<p>Complete list of packages (in Puppy or not):</p>' >>/tmp/newinfoindex.xml
echo '<center>
<form name="form2">
<select name="site2" size="1" onchange="javascript:formHandler2()">
' >>/tmp/newinfoindex.xml
sed -e 's% %|%' -e 's%$%|%' /root/.packages/PKGS_HOMEPAGES > /tmp/pkgs_homepages_mod
printcols /tmp/pkgs_homepages_mod 2 1 | sed -e 's%^%<option value="%' -e 's%|$%#%' -e 's%|%">%' -e 's%#$%%' >> /tmp/newinfoindex.xml
sync
echo '</select>
</form>
</center>
' >> /tmp/newinfoindex.xml

#w012 commented out...
##dropdown menu for all installed pkgs...
#echo '<p>All packages installed in Puppy:</p>' >>/tmp/newinfoindex.xml
#echo '<center>
#<form name="form2">
#<select name="site2" size="1" onchange="javascript:formHandler2()">
#' >>/tmp/newinfoindex.xml
#echo "$PKGINFODB" |
#while read ONEINFO
#do
# [ "$ONEINFO" = "" ] && continue
# NAMEONLY="`echo "$ONEINFO" | cut -f 1 -d '|' | tr [A-Z] [a-z]`"
# EXPATTERN=" $NAMEONLY "
# nEXPATTERN="^$NAMEONLY "
# [ "`echo "$EXCLLISTsd" | grep -i "$EXPATTERN"`" != "" ] && continue
# HOMESITE="http://en.wikipedia.org/wiki/${NAMEONLY}"
# REALHOME="`echo "$HOMEPAGEDB" | grep -i "$nEXPATTERN" | head -n 1 | cut -f 2 -d ' '`"
# [ "$REALHOME" != "" ] && HOMESITE="$REALHOME"
# xONEINFO="`echo -n "$ONEINFO" | sed 's%|%:  %'`"
# echo "<option value=\"${HOMESITE}\">${xONEINFO}" >> /tmp/newinfoindex.xml
#done
#echo '</select>
#</form>
#</center>
#' >> /tmp/newinfoindex.xml

##dropdown menu for all executables...
#echo '<p>All executable files in Puppy:</p>' >>/tmp/newinfoindex.xml
#echo '<center>
#<form name="form">
#<select name="site" size="1" onchange="javascript:formHandler()">
#' >>/tmp/newinfoindex.xml
#echo "$PKGINFONODESCR" |
#while read ONEINFO
#do
# [ "`echo "$ONEINFO" | grep -E 'NOTUSED|FULL|\.bin$|config$|README|OLD|\.glade$'`" != "" ] && continue
# EXPATTERN=" $ONEINFO "
# [ "`echo "$EXCLLISTsd" | grep -i "$EXPATTERN"`" != "" ] && continue
# echo "<option value=\"http://linux.die.net/man/${ONEINFO}\">${ONEINFO}</option>" >> /tmp/newinfoindex.xml
#done
#echo '</select>
#</form>
#</center>
#' >> /tmp/newinfoindex.xml

#now complete the index.html file...
cat /usr/share/doc/index.html.bottom >> /tmp/newinfoindex.xml
mv -f /tmp/newinfoindex.xml /usr/share/doc/index.html


###END###
