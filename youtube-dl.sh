#!/bin/bash

NAME=`youtube-dl --get-filename $1 -o '%(title)s'`

youtube-dl --verbose --extract-audio --audio-format mp3 $1 -o '%(title)s.%(ext)s'

RENAME=`echo ${NAME//[^[:ascii:]]/} | sed 's/[^[:print:]]//' | awk '{print tolower($0)}' | sed 's/.*/\u&/'`

mv "$NAME.mp3" "$RENAME.mp3"
