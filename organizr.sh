#!/bin/bash


#while IFS=' ' read -r line || [[ -n "$line" ]]; do
#    gthumb $line
#    read $next
#done < "$1"


cat $1 | while read LINE
#for LINE in $(cat $1)
do
	echo "$LINE"
	gthumb $LINE
	sleep 10
done
