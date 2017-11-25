#!/bin/bash
## https://mintguide.org/system/283-how-to-check-and-fix-the-disk-for-errors-and-bad-sectors-in-linux-mint.html

sudo umount /media/daniel/HD1500GB
sudo fsck -t -y -f -c /dev/sdg1
sudo dumpe2fs /dev/sdg1
sudo mke2fs -n /dev/sdg1
