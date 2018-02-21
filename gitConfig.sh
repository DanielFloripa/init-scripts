#!/bin/bash

if ! hash git 2>/dev/null ; then
	sudo apt-get install git
fi
if [ $# -eq 0 ]; then
	echo "Falta parametro: $0 <repoName>"
	exit 0
fi

git init
git add *
git commit -m "new"
git config --global credential.helper 'store'
git remote add origin https://github.com/DanielFloripa/${1}.git
git push origin master

	
