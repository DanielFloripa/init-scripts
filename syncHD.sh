#!/bin/bash

DEV1="/dev/sdb1"
DEV2="/dev/sdc1"

DEF="/media/daniel/"
DIR1=`sudo blkid $DEV1 | cut -d'"' -f2 | cut -d'"' -f1`
DIR2=`sudo blkid $DEV2 | cut -d'"' -f2 | cut -d'"' -f1`

SRC="$DEF$DIR1"
DST="$DEF$DIR2"

sudo mkdir -p $SRC
sudo mkdir -p $DST

#sudo mount $DEV1 $SRC
#sudo mount $DEV2 $DST

echo $SRC $DST
#rsync -ah --stats --progress --log-file="log`date +%s`.log" $SRC/* $DST/
sleep 2

sudo umount $SRC
sudo umount $DST
if [ "$?" == '1' ]; then
	echo "Deletando pastas"
	sudo rm -rf $SRC $DST
else
	echo "FALHA AO DESMONTAR. ERRO:" $?
fi

