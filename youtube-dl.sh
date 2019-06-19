#!/bin/bash

sudo youtube-dl -U

NAME=`youtube-dl --get-filename $1 -o '%(title)s'`
RENAME=`echo ${NAME//[^[:ascii:]]/}".mp3" | sed 's/[^[:print:]]//' | awk '{print tolower($0)}' | sed 's/.*/\u&/'`
echo "Change: '$NAME' to '$RENAME'"

youtube-dl --verbose -x --audio-quality 0 $1 
if [ "$2" == "cut" ]; then
	echo -e "\n\t Start $3; Duration: $4?"
	avconv -y -i "${NAME}"* -ss $3 -t $4 -vn -acodec libmp3lame '-q:a' 1 "file:$RENAME"
else
	avconv -y -i "${NAME}"* -vn -acodec libmp3lame '-q:a' 1 "file:$RENAME"
fi

FIRST=`echo ${NAME} | cut -d'-' -f1`
SECOND=`echo ${NAME} | cut -d'-' -f2`

echo -e "\n\tInsert Genre:"
read GENRE_T

if [[ $GENRE_T == *" "* ]]; then
	GENRE_ID3=`id3tool -l | grep -i "${GENRE_T}" | cut -d' ' -f1-2`
else
	GENRE_ID3=`id3tool -l | grep -i "${GENRE_T}" | cut -d' ' -f1`
fi

## GENRE_ID3=`id3tool -l | grep -i "${GENRE_T}" | cut -d' ' -f1`

echo -e "\t::${GENRE_T}:: and ::${GENRE_ID3}::\n"

if [ "${GENRE_T}" == "${GENRE_ID3}" ]; then
	echo -e "\t::${GENRE_T}:: and ::${GENRE_ID3}:: is equals!"
	GENRE="${GENRE_T}"
else
	id3tool -l | grep -i "${GENRE_T}"
	if [ $? == 0 ]; then
		echo -e "\n\tRepeat the correct and full genre:"
		read GENRE
	else
		while [ $? == 1 ]; do
			echo -e "\n\tGenre not in list, repeat again:"
			read GENRE_T
			id3tool -l | grep -i "${GENRE_T}"
		done
		echo -e "\n\tRepeat the correct and full genre:"
        	read GENRE
	fi
fi

echo -e "\n\tVerify if correct:\n\t\tAutor:${FIRST}; Title:${SECOND}; Genre:${GENRE}; ([y]es / i[n]vert / [e]dit)"
read RESPONSE

if [ "$RESPONSE" == "y" ]; then
	id3tool -r "${FIRST}" -t "${SECOND}" -G "${GENRE}" "${RENAME}"
elif [ "${RESPONSE}" == "n" ]; then 
	id3tool -t "${FIRST}" -r "${SECOND}" -G "${GENRE}" "${RENAME}"
elif [ "${RESPONSE}" == "e" ]; then
	echo -e "\tAutor:"
	read AUTHOR
	echo -e "\tTitle:"
	read TITLE
	id3tool -r "${AUTHOR}" -t "${TITLE}" -G "${GENRE}" "${RENAME}"
fi

echo -e "\n\tThe result is:"
id3tool "${RENAME}"

echo -e "\n\tRemoving original video! : ${NAME}"
rm -i "${NAME}"*
rm -i *.ogg *.opus
