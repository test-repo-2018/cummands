#!/bin/bash
#SHELL=/bin/bash
#TERM=xterm
. ~/.bash_aliases
. ~/.bashrc
. ~/.profile

BASE_DIR=/tmp/cummands

if [ ! -f ~/raspberry_status/password.txt ]; then
  read -sp 'Password: ' passvar
  echo $passvar > ~/raspberry_status/password.txt
fi

PASSWORD=`cat ~/raspberry_status/password.txt`


if [ ! -d "$BASE_DIR/" ]; then
  # if folder doesnt exist, then create it
  mkdir $BASE_DIR
fi
cd $BASE_DIR
if [ ! -d "$BASE_DIR/.git" ]; then
  # if .git folder doesnt exist, clone the repo here
  git clone https://github.com/test-repo-2018/cummands.git .
fi


rm rasp_status.txt 
NOW1=$(date +"%Y-%m-%d-[%T]")
#touch touch_{$NOW1}_start.log
#=======================================================================================================================
echo -----------------   $NOW1   -------------------------------------- >> $BASE_DIR/rasp_status.txt 2>&1
/sbin/ifconfig     >> $BASE_DIR/rasp_status.txt 2>&1 
#/usr/bin/top -n 1 >> $BASE_DIR/rasp_status.txt 2>&1 
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1
echo df -k >> $BASE_DIR/rasp_status.txt 2>&1
df -k      >> $BASE_DIR/rasp_status.txt 2>&1
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1
#=======================================================================================================================
echo ps aux - grep [y]outube-dl >> $BASE_DIR/rasp_status.txt 2>&1
ps aux | grep [y]outube-dl      >> $BASE_DIR/rasp_status.txt 2>&1
echo cat /home/pi/Youtube_scripts/YOUTUBE_STATUS.TXT >> $BASE_DIR/rasp_status.txt 2>&1
cat /home/pi/Youtube_scripts/YOUTUBE_STATUS.TXT      >> $BASE_DIR/rasp_status.txt 2>&1
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1
echo ps aux - grep [w]get >> $BASE_DIR/rasp_status.txt 2>&1
ps aux | grep [w]get      >> $BASE_DIR/rasp_status.txt 2>&1
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1
echo ps aux - grep [d]eluged >> $BASE_DIR/rasp_status.txt 2>&1
ps aux | grep [d]eluged      >> $BASE_DIR/rasp_status.txt 2>&1
echo cat /home/pi/Deluge_scripts/DELUGE_STATUS.TXT >> $BASE_DIR/rasp_status.txt 2>&1
cat /home/pi/Deluge_scripts/DELUGE_STATUS.TXT      >> $BASE_DIR/rasp_status.txt 2>&1
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1
S=1
F=/sys/class/net/eth0/statistics/rx_bytes
X=`cat $F`
sleep $S
Y=`cat $F`
BPS="$(((Y-X)/(S*1024)))"
echo "Speed = $BPS kbps"  >> $BASE_DIR/rasp_status.txt 2>&1
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1
deluge-console info  >> $BASE_DIR/rasp_status.txt 2>&1

#=======================================================================================================================
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1 
echo ~   >> $BASE_DIR/rasp_status.txt 2>&1 
ls -l  ~ >> $BASE_DIR/rasp_status.txt 2>&1 
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1 
echo ~/data/deluge_completed    >> $BASE_DIR/rasp_status.txt 2>&1 
ls -l  ~/data/deluge_completed  >> $BASE_DIR/rasp_status.txt 2>&1 
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1 
echo ~/data/Youtube  >> $BASE_DIR/rasp_status.txt 2>&1 
find ~/data/Youtube -type f -print0 | xargs -0 ls -l  >> $BASE_DIR/rasp_status.txt 2>&1 
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1 
echo ~/data/Curl    >> $BASE_DIR/rasp_status.txt 2>&1 
ls -l  ~/data/Curl  >> $BASE_DIR/rasp_status.txt 2>&1 
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1 
echo ~/data/Wget    >> $BASE_DIR/rasp_status.txt 2>&1 
find  ~/data/Wget   >> $BASE_DIR/rasp_status.txt 2>&1 
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1 
echo folder size of ~/data >> $BASE_DIR/rasp_status.txt 2>&1
cd ~/data/
du -s */ | sort -n         >> $BASE_DIR/rasp_status.txt 2>&1
cd $BASE_DIR
echo ------------------------------------------------------------------ >> $BASE_DIR/rasp_status.txt 2>&1 

#=======================================================================================================================
#---------------------------------------------------------------------
#sleep $[ ( $RANDOM % 10 )  + 1 ]s
#---------------------------------------------------------------------
IPADDRESS=`hostname -I`
IPADDRESS=`echo $IPADDRESS | xargs`
export IPADDRESS
#---------------------------------------------------------------------
rm rasp_stat_{$IPADDRESS}.zip
rm rasp_stat_{$IPADDRESS}.txt
mv rasp_status.txt rasp_stat_{$IPADDRESS}.txt
7za a -tzip -p${PASSWORD} -mem=AES256 rasp_stat_{$IPADDRESS}.zip rasp_stat_{$IPADDRESS}.txt
#---------------------------------------------------------------------

NOW=$(date +"%Y-%m-%d-[%T]")
#curl  --dump-header header.txt --form "message=from raspberry pi {$IPADDRESS} - $NOW" --form "fileName=@/home/pi/gsbabu_raspberry_status/rasp_stat_{$IPADDRESS}.zip" "http://66.7.209.193/~gsbabuc/message_post/index.php?action=upload" > curl.log 2>&1 

#/home/pi/utils/mail_office_attachment.sh "/home/pi/gsbabu_raspberry_status/rasp_stat_{$IPADDRESS}.zip"


#exit

git pull 
git config --global credential.helper cache
git config --global push.default simple
git add  "rasp_stat_{$IPADDRESS}.zip"
git commit -m $NOW
git pull 
git push 

