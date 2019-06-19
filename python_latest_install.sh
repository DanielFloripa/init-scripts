#!/usr/bin/bash

sudo apt update && sudo apt upgrade -y &&\
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev   &&\
sudo apt-get install -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm  gpp &&\
sudo apt-get install -y libncurses5-dev  libncursesw5-dev xz-utils tk-dev &&\
wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz &&\

tar xvf Python-3.6.5.tgz &&\
cd Python-3.6.5  &&\
./configure --enable-optimizations --with-ensurepip=install &&\
make -j8 && sudo make altinstall

# Do no changes default python version, will break other apps
#update-alternatives --install /usr/bin/python python /usr/bin/python2.7 50
#update-alternatives --install /usr/bin/python python /usr/local/bin/python3.6 40
#update-alternatives --install /usr/bin/python python /usr/bin/python3.5 30

# update-alternatives --config python
