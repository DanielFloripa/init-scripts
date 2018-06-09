#!/bin/bash

#Context:
if [ "$0" == "bash" ]; then
	USER="debian" # "ubuntu"
	ALL_PARAM=("config" "apt" "java")
	APP="headless"
	echo "Executing in server mode:" $USER ${ALL_PARAM[@]} $APP  
	LEVEL=0
else
	ALL_PARAM=$@
	UUSER="$1"
	APP="dpkg"
	LEVEL=1
fi

#Universal:
UUSER_H="/home/$UUSER"
OUTPUT="run_after.sh"
OS_NAME=`cat /etc/os-release | grep "HOME_URL" | cut -d'.' -f2 | cut -d'.' -f1`
CODENAME=`cat /etc/os-release | grep "VERSION=" | cut -d'(' -f2 | cut -d')' -f1 | cut -d' ' -f1`

#Misc:
WARN='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

if [ $# == 0 -a "$0" != "bash" ]; then
	echo -e "${WARN} Parameters missing.
	${BLUE}Execute: $0 <username> <@args>
	{ config || apt || opencv || drivers || java || poweroff/reboot}>${NC}";
	exit 0;
fi

for param in ${ALL_PARAM[@]}; do
	echo "Executing the" $param "parameter"
	if [ "$param" == "apt" ]; then 
		sudo apt-get update
		sudo apt-get remove empathy akregator kmail kopete thunderbird pidgin hexchat banshee totem unity-webapps-common apport --assume-yes
		sudo apt autoremove
		sudo apt-get -f install
		sudo apt-get upgrade --assume-yes
		sudo apt-get install ftp curl git zip vim bash-completion aptitude htop firmware-misc-nonfree --assume-yes
		if [ $LEVEL > 1 ]; then 
			sudo apt-get install texlive-full aspell-pt-br kde-l10n-ptbr kile-l10n okular --assume-yes
		fi
		sudo apt-get install geany gparted wine inkscape shutter filezilla dia vlc gnuplot sqlite sqlitebrowser --assume-yes
		# @TODO:python-libs*
		sudo apt-get install  python-all python-pygame python-pil python-serial python-pip python3 python3-all python3-pip --assume-yes
		sudo bash python_latest_instal.sh
		sudo apt autoremove --assume-yes
		### R e insync:
		sudo apt-get install r-base r-base-dev --allow-unauthenticated  --assume-yes

		wget https://download1.rstudio.org/rstudio-xenial-1.1.447-amd64.deb
		sudo chmod +x rstudio-xenial-1.1.447-amd64.deb
		sudo dpkg -i rstudio-xenial-1.1.447-amd64.deb
		#rm -rf rstudio-xenial-1.1.447-amd64.deb
		
		sudo apt install insync --assume-yes
		echo "insync start" >> $OUTPUT
		###TODO: zotero
		### Draw.io:
		if hash draw.io 2>/dev/null; then
			echo -e "${BLUE} Draw.io already installed${NC}"
		else
			if [ ! -e draw.io* ]; then
				VERS=`curl -s https://github.com/jgraph/drawio-desktop/releases/latest | cut -d"v" -f2 | cut -d "\"" -f1`
				wget https://github.com/jgraph/drawio-desktop/releases/download/v$VERS/draw.io-amd64-$VERS.deb
			fi
			chmod +x draw.io*.deb
			sudo dpkg -i draw.io*.deb
		fi
		if hash fslint-gui 2>/dev/null; then
			echo -e "${BLUE} Fslint already installed${NC}"
		else
			sudo apt-get install debhelper python-glade2 --assume-yes
			if [ ! -e fslint* ]; then git clone https://github.com/pixelb/fslint.git; fi
			cd fslint
			dpkg-buildpackage -I.git -rfakeroot -tc
			sudo dpkg -i ../fslint*.deb
			cd ../
		fi
		### Google Chrome:
		if  hash google-chrome 2>/dev/null; then
			echo -e "${BLUE} Chrome already installed${NC}"
		else
			sudo apt-get install libxss1 libappindicator1 libindicator7 --assume-yes 
			if [ ! -e google-chrome*.deb ]; then 
				wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; 
			fi
			chmod +x google-chrome-stable_current_amd64.deb 
			sudo dpkg -i google-chrome-stable_current_amd64.deb 
			echo "google-chrome" >> $OUTPUT
		fi
		### Youtube-DL:
		if hash youtube-dl 2>/dev/null; then
			echo -e "${BLUE} yt-dl already installed${NC}"
		else
			sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/bin/youtube-dl
			sudo chmod a+rx /usr/bin/youtube-dl
		fi
		### Teamviewer
		TV_VER="NEW"
		if hash teamviewer 2>/dev/null; then 
			echo -e "${BLUE} Teamviwer already installed${NC}"
		elif [ "${TV_VER}" == "OLD" ]; then
			sudo dpkg --add-architecture i386
			sudo apt-get install libc6 libgcc1 libasound2 libdbus-1-3 libexpat1 libfontconfig1 libfreetype6 libjpeg62 libsm6 libxdamage1 libxext6 libxfixes3 libxinerama1 libxrandr2 libxrender1 libxtst6 zlib1g --assume-yes
			sudo apt --fix-broken install
			if [ ! -e teamviewer_i386.deb ]; then wget https://download.teamviewer.com/download/teamviewer_i386.deb; fi
			sudo dpkg -i teamviewer_i386.deb 
			sudo apt-get install -f
			echo "teamviewer" >> $OUTPUT
			sudo dpkg --add-architecture amd64
		else
			if [ ! -e teamviewer_amd64.deb ]; then
				wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
			fi
			chmod +x teamviewer_amd64.deb
			sudo dpkg -i teamviewer_amd64.deb
			sudo apt-get -f install
			echo "teamviewer" >> $OUTPUT
		fi
		#### AnyDesk  #####
		if hash anydesk 2>/dev/null; then 
			echo -e "${BLUE} AnyDesk already installed${NC}"
		else
			wget https://download.anydesk.com/linux/anydesk_2.9.5-1_amd64.deb
			sudo dpkg -i anydesk_2.9.5-1_amd64.deb
			sudo apt -f install
		fi
		### Dropbox
		if hash dropbox 2>/dev/null; then 
			echo -e "${BLUE} Dropbox already installed${NC}"
		elif [ "$APP" == "headless" ]; then
			DBOX_F="$UUSER_H/.dropbox-dist/"
			cd $UUSER_H && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
			wget https://www.dropbox.com/download?dl=packages/dropbox.py -O $DBOX_F/dropbox.py
			chmod +x $DBOX_F/dropbox.py
			sudo ln -fs $DBOX_F/dropbox.py /usr/bin/dropbox
			echo "$DBOX_F/dropboxd" >> $OUTPUT
		else
			if [ ! -e dropbox*.deb ]; then 
				wget https://linux.dropbox.com/packages/$OS_NAME/dropbox_2015.10.28_amd64.deb
			fi
			sudo apt -f install 
			chmod +x dropbox* 
			sudo dpkg -i dropbox*.deb
			sudo apt -f install
			echo "dropbox start -i" >> $OUTPUT
		fi
		### LibreOffice:
		if hash libreoffice 2>/dev/null; then
			echo -e "${BLUE} Libreoffice already installed.${NC}"
		else
			VERS="6.0.4"
			FILEBASE="LibreOffice_${VERS}_Linux_x86-64_deb"
			if [ ! -e libreoffice*.tar.gz ]; then
				wget http://download.documentfoundation.org/libreoffice/stable/${VERS}/deb/x86_64/${FILEBASE}.tar.gz
				wget http://download.documentfoundation.org/libreoffice/stable/${VERS}/deb/x86_64/${FILEBASE}_langpack_pt-BR.tar.gz
			fi
			mkdir loffice loffice-lp
			tar -zxvf ${FILEBASE}.tar.gz -C loffice
			tar -zxvf ${FILEBASE}_langpack_pt-BR.tar.gz -C loffice-lp
			chmod +x loffice/*/DEBS/*
			chmod +x loffice-lp/*/DEBS/*
			sudo dpkg -i loffice/*/DEBS/*
			sudo dpkg -i loffice-lp/*/DEBS/*
		fi
		#
		### Sublime ###
		if hash subl 2>/dev/null; then
			echo -e "${BLUE} Sublime already installed.${NC}"
		else
			echo -e "Installling sublime"
			if [ ! -e sublimehq-pub.gpg ]; then
				wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
				#sudo apt-key add -wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg
			fi
			
			if sudo grep "sublimetext" /etc/apt/sources.list > /dev/null; then
				echo -e "${BLUE} Sublime sources already configured!${NC}"
			else
				sudo apt-get install -y apt-transport-https
				sudo apt-get install dirmngr --assume-yes
				sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
				echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
			fi			
			sudo apt-get update
			sudo apt-get install -y sublime-text
		fi
		#
		### Virtual Box
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
		#"add to /etc/apt/sources.list:"
		echo "deb http://download.virtualbox.org/virtualbox/$OS_NAME $CODENAME contrib" >> /etc/apt/sources.list
		sudo apt-get update
		sudo apt-get install -y dkms
		#sudo apt-get install -y virtualbox-5.1
		#wget http://download.virtualbox.org/\virtualbox/5.1.28/Oracle_VM_VirtualBox_Extension_Pack-5.1.28-117968.vbox-extpack
		### lamp stack:
		#sudo ./lamp.sh "abcde"
		#""" NodeJS NPM:"""
		sudo apt-get install -y nodejs
		curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
		sudo apt-get install -y nodejs
		sudo apt-get install -y build-essential
		curl -L https://www.npmjs.com/install.sh | sudo -E bash -
		### iphone drivers
		
		if [ $LEVEL > 2 ]; then 
			bash iphone.sh install
		fi
	
	elif [ "$param" == "pip" ]; then
		sudo pip install --upgrade pip
		sudo pip3 install --upgrade pip
		sudo pip install awscli
		sudo pip install python-openstackclient
		
	############## Video Drivers ###############
	elif [ "$param" == "drivers" ]; then
		### Nvidia Drivers:
		sudo aptitude update
		sudo aptitude -r install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') nvidia-legacy-340xx-driver
		sudo aptitude -r install nvidia-xconfig
		echo "nvidia-xconfig" >> $OUTPUT
		
	############## CONFIGURATIONS ###############
	elif [ "$param" == "config" ]; then
		sudo usermod -a -G sudo $UUSER
		if sudo grep "$UUSER ALL=(ALL:ALL) ALL" /etc/sudoers; then
			echo -e "${BLUE} Sudoers already configured!${NC}"
		else
			echo "$UUSER ALL=(ALL:ALL) ALL" | sudo tee --append /etc/sudoers
		fi
		sudo adduser daniel --add_extra_groups sudo
		### BASH history to infinity:
		sudo sed -e "s/^HISTSIZE.*$/HISTSIZE=-1/" -i $UUSER_H/.bashrc
		sudo sed -e "s/^HISTFILESIZE.*$/HISTFILESIZE=-1/" -i $UUSER_H/.bashrc
		### NON-Free repo:
		if sudo grep non-free /etc/apt/sources.list; then
			echo -e "${BLUE} Non-free sources already configured!${NC}"
		else
			echo "deb http://httpredir.debian.org/debian/ stretch main contrib non-free" | sudo tee --append /etc/apt/sources.list > /dev/null
		fi
		### Cran-R:
		if sudo grep "cran-r" /etc/apt/sources.list; then
			echo -e "${BLUE} R sources already configured!${NC}"
		else
			sudo apt-get install dirmngr --assume-yes
			sudo apt-key adv --keyserver keys.gnupg.net --recv-key 6212B7B7931C4BB16280BA1306F90DE5381BA480
			# sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
			echo "deb http://cran-r.c3sl.ufpr.br/bin/linux/$OS_NAME stretch-cran34/" | sudo tee --append /etc/apt/sources.list > /dev/null
		fi
		### Insync:
		if sudo grep "insynchq" /etc/apt/sources.list; then
			echo -e "${BLUE} Insync sources already configured!${NC}"
		else
			wget -qO - https://d2t3ff60b2tol4.cloudfront.net/services@insynchq.com.gpg.key \ | sudo apt-key add -
			echo "deb http://apt.insynchq.com/$OS_NAME stretch non-free" | sudo tee --append /etc/apt/sources.list > /dev/null
		fi
		sudo apt-get update

	############## JAVA ORACLE ###############
	### How to Install JAVA 8 on Linux Systems ##
	### Comandos retirados de: http://www.tecmint.com/install-java-jdk-jre-in-linux/
	elif [ "$param" == "java" ]; then
		MACHINE_TYPE=`uname -m`
		if [ ${MACHINE_TYPE} == "x86_64" ]; then
			ARCH="x64"
		else
			#ARCH='i386'
			#ARCH='i586'
			ARCH="i686"
		fi
		ARCH_TYPE=`dpkg --print-architecture`
		MASTERV="8" #`curl -s https://www.java.com/pt_BR/download/ | grep Version | cut -d' ' -f2`
		MIDDLEV="144" #`curl -s https://www.java.com/pt_BR/download/ | grep Version | cut -d' ' -f4`
		VERSION="${MASTERV}u${MIDDLEV}"
		SUBVERSION="b01"
		FILE="jdk-$VERSION-linux-$ARCH.tar.gz"
		echo -e "${WARN} Versao a ser instalada: ${VERSION}-${SUBVERSION} ${NC}"
		#2. Make a directory where you want to install Java. For global access (for all users) install it preferably in the directory /opt/java.
		su -s .
		mkdir -p /opt/java ; cd /opt/java
		#3. Now it’s time to download Java (JDK) source tarball files for your system architecture by going to official Java download page. 
		#You may use wget command to download files directly into the /opt/java directory as shown below.
		if [ -f $UUSER_H/Downloads/jdk* ]; then
			echo -e "${BLUE} File: $FILE already exists${NC}"
			cp -v $UUSER_H/Downloads/jdk* /opt/java;
		else
			wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${VERSION}-${SUBVERSION}/$FILE"
			echo -e "${WARN} If any error please download it manualy from: http://www.oracle.com/technetwork/java/javase/downloads/index.html${NC}"
		fi
		#4. Once file has been downloaded, you may extract the tarball using tar command as shown below.
		tar -zxvf $FILE
		#5. Next, move to the extracted directory and use command update-alternatives to tell system where java and its executables are installed.
		cd jdk1.${MASTERV}.0_${MIDDLEV}/
		update-alternatives --install /usr/bin/java java /opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/bin/java 100
		update-alternatives --config java
		#6. Tell system to update javac alternatives as:
		update-alternatives --install /usr/bin/javac javac /opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/bin/javac 100
		update-alternatives --config javac
		#7. Similarly, update jar alternatives as:
		update-alternatives --install /usr/bin/jar jar /opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/bin/jar 100
		update-alternatives --config jar
		#8. Setting up Java Environment Variables.
		export JAVA_HOME=/opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/
		export JRE_HOME=/opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/jre
		export PATH=$PATH:/opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/bin:/opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/jre/bin
		#9. Now You may verify the Java version again, to confirm.
		echo "#Versao nova Java: " >> $OUTPUT
		echo "java -version" >> $OUTPUT
		#Suggested: If you are not using OpenJDK, you may remove it as:
		echo -e "${BLUE} Removing old openjdk...${NC}"
		sudo apt-get remove openjdk-*
		#10. To enable Java 8 JDK 8u45 Support in Firefox, you need to run following commands to enable Java module for Firefox.
		#On Debian, Ubuntu and Mint
		update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/jre/lib/amd64/libnpjp2.so 20000
		#On RHEL, CentOS and Fedora
			#alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/jre/lib/${ARCH_TYPE}/libnpjp2.so 20000
		#11. Now verify the Java support by restarting Firefox and enter about:plugins on the address bar.
		printf 'firefox about:plugins\n' >> $OUTPUT
		
	############## OpenCV Sources ###############
	### Baseado em http://www.pyimagesearch.com/2015/07/20/install-opencv-3-0-and-python-3-4-on-ubuntu/
	## Exemplo modificado de: https://github.com/Tes3awy/OpenCV-3.1.0-Compiling-on-Raspberry-Pi-2-
	elif [ "$param" == "opencv" ]; then
		INSTALL_DIR="$UUSER_H/Downloads"
		VERSION="3.1.0"
		sudo apt-get update && sudo apt-get upgrade -y
		sudo apt-get install build-essential cmake pkg-config unzip -y
		sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev  libpng12-dev libpng-dev libgphoto2 -y
		sudo apt-get install libgtk2.0-dev libgstreamer0.10-0-dbg libgstreamer0.10-0 libgstreamer0.10-dev libv4l-0 libv4l-dev -y
		sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y
		sudo apt-get install libxvidcore-dev libx264-dev -y
		sudo apt-get install libatlas-base-dev gfortran -y
		sudo apt-get install  python3-dev python-numpy python-scipy python-matplotlib -y
		#sudo apt-get install default-jdk ant
		sudo apt-get install libgtkglext1-dev libilmbase-dev  -y
		sudo apt-get install v4l-utils doxygen libpython3-stdlib libpython-stdlib libpython3.5-stdlib -y
		
		#wget http://ftp.br.debian.org/debian/pool/main/z/zlib/zlib1g_1.2.8.dfsg-2+b1_amd64.deb
		#chmod +x zlib1g_1.2.8.dfsg-2+b1_amd64.deb
		#sudo dpkg -i zlib1g_1.2.8.dfsg-2+b1_amd64.deb
		#wget http://ftp.br.debian.org/debian/pool/main/z/zlib/zlib1g-dev_1.2.8.dfsg-2+b1_amd64.deb
		#chmod +x zlib1g-dev_1.2.8.dfsg-2+b1_amd64.deb
		#sudo dpkg -i zlib1g-dev_1.2.8.dfsg-2+b1_amd64.deb
		
		if [ ! -e libpng12* ]; then
			wget http://ftp.br.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb 
			wget http://ftp.br.debian.org/debian/pool/main/libp/libpng/libpng12-dev_1.2.50-2+deb8u3_amd64.deb
		fi
		chmod +x libpng12-0_1.2.50-2+deb8u3_amd64.deb libpng12-dev_1.2.50-2+deb8u3_amd64.deb
		sudo dpkg -i libpng12-0_1.2.50-2+deb8u3_amd64.deb
		sudo dpkg -i libpng12-dev_1.2.50-2+deb8u3_amd64.deb
		#'Step 3: install python3 dependencies'
		if [ ! -e get-pip.py ]; then
			wget https://bootstrap.pypa.io/get-pip.py 
		fi
		python3 get-pip.py
		sudo pip install numpy
		# if error, do: `rm -rf ~/.cache/pip/ && sudo pip install numpy`
		#'Step 4: Download OpenCV 3.1.0 + contrib and unpack'
		cd $INSTALL_DIR
		if [ ! -e opencv.zip ]; then
			wget -O opencv.zip https://github.com/opencv/opencv/archive/3.1.0.zip
			unzip opencv.zip 
		fi
		#Contrib Libraries (Non-free Modules)
		if [ ! -e opencv_contrib.zip ]; then
			wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.1.0.zip
			unzip opencv_contrib.zip
		fi
		# Step 5: prepare the 'build'
		cd $INSTALL_DIR/opencv-3.1.0/
		#rm -rf build
		mkdir -p build ; cd build
		cmake -DENABLE_PRECOMPILED_HEADERS=OFF \
			-DCMAKE_BUILD_TYPE=RELEASE \
			-DCMAKE_INSTALL_PREFIX=/usr/local \
			-DINSTALL_C_EXAMPLES=OFF \
			-DINSTALL_PYTHON_EXAMPLES=ON \
			-DOPENCV_EXTRA_MODULES_PATH=$INSTALL_DIR/opencv_contrib-3.1.0/modules \
			-DBUILD_EXAMPLES=ON ..

		#echo 'Step 6: demora cerca de 3.5 a 4 horas'
		make -j4 #(I prefer -j3, because it doesnt use all the cores so it keeps the RasPi cool enough)
		echo -e "${WARN} Se algum erro ocorrer e o processo falhar ao continuar, execute: make clean${NC}"
		# Sometimes using multicores can cause problems, so if you face any problems just execute make, but keep in mind that 
		# it will take much longer so be patient as much as you can and grab your cup of tea.'
		# Step 7: install 'build' prepared in step 5'
		sudo make install
		sudo ldconfig
		#Edit opencv.conf and bash.bashrc'. Note opencv.conf will be blank
		if sudo grep lib /etc/ld.so.conf.d/opencv.conf; then
			echo -e "/usr/local/lib\n" | sudo tee --append /etc/ld.so.conf.d/opencv.conf > /dev/null
		fi
		sudo ldconfig
		if sudo grep PKG_CONFIG_PATH /etc/bash.bashrc; then
			echo -e "PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig\nexport PKG_CONFIG_PATH\n" | sudo tee --append /etc/bash.bashrc > /dev/null
		fi
		#Teste a versao do cv2'
		cd $INSTALL_DIR
		rm teste.py
		printf '#!/usr/bin/env python \nimport cv2 \nprint (cv2.__version__)\n' >> teste.py
		chmod +x teste.py
		RET=`python3 teste.py`
		if [ $RET == $VERSION ]; then
			echo -e "${BLUE} OpenCV instalado com sucesso!${NC}"
		else
			echo -e "${WARN} Houve algum erro, reinicie a instalacao!!!${NC}"
		fi

	############## REBOOT OR SHUTDOWN ###############
	elif [ "$param" == "poweroff" ]; then
		echo -e "${BLUE} Shutdown in 10 seconds.\n Clean files...${NC}"
		sudo rm -rf opencv* get-pip.py libpng12* dropbox* teamviewer* google-chrome* draw.io* teste.py
		sudo apt autoremove --assume-yes
		sleep 10
		sudo shutdown now
	elif [ "$param" == "reboot" ]; then
		echo -e "${BLUE} Reboot in 10 seconds.\n Clean files...${NC}"
		sudo rm -rf opencv* get-pip.py libpng12* dropbox* teamviewer* google-chrome* draw.io* teste.py
		sudo apt autoremove --assume-yes
		sleep 10
		sudo shutdown -r now
	fi
done

#TODO:
#sudo apt-get purge --auto-remove gnome-online-accounts
#install aws-cli openstack-cli

#https://docs.docker.com/install/linux/docker-ce/debian/#uninstall-docker-ce
