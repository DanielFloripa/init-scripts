#!/bin/bash

### # How to Install JAVA 8 on Linux Systems # ###

# Comandos retirados de: http://www.tecmint.com/install-java-jdk-jre-in-linux/

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  ARCH='x64'
else
  #ARCH='i386'
  #ARCH='i586'
  ARCH='i686'
fi

ARCH_TYPE=`dpkg --print-architecture`
MASTERV=`curl -s https://www.java.com/pt_BR/download/ | grep Version | cut -d' ' -f2`
MIDDLEV=`curl -s https://www.java.com/pt_BR/download/ | grep Version | cut -d' ' -f4`
VERSION="${MASTERV}u${MIDDLEV}"
SUBVERSION='b01'
FILE="jdk-${VERSION}-linux-${ARCH}.tar.gz"
echo 'Versão a ser instalada: ${VERSION}-${SUBVERSION}'
#java -version 2>&1 >/dev/null | grep 'Runtime' | awk '{print $6}'

#Faça tudo como sudo
#	sudo su

#1. Before installing Java, make sure to first verify the version of installed Java.
	echo "Versão Atual:"
	java -version

#2. Make a directory where you want to install Java. For global access (for all users) install it preferably in the directory /opt/java.
	mkdir /opt/java && cd /opt/java

#3. Now it’s time to download Java (JDK) 8u45 source tarball files for your system architecture by going to official Java download page. You may use wget command to download files directly into the /opt/java directory as shown below.
    if [ -f /home/daniel/Downloads/$FILE ]; then
        echo "File already exists"
        cp /home/daniel/Downloads/$FILE /opt/java;
    else
        wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${VERSION}-${SUBVERSION}/$FILE"
        echo "if any error please download it manualy from: http://www.oracle.com/technetwork/java/javase/downloads/index.html"

    fi
    #http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz

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
	java -version

#Suggested: If you are not using OpenJDK, you may remove it as:

	apt-get remove openjdk-*


#10. To enable Java 8 JDK 8u45 Support in Firefox, you need to run following commands to enable Java module for Firefox.
#On Debian, Ubuntu and Mint
	update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/jre/lib/amd64/libnpjp2.so 20000

#On RHEL, CentOS and Fedora
	#alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /opt/java/jdk1.${MASTERV}.0_${MIDDLEV}/jre/lib/${ARCH_TYPE}/libnpjp2.so 20000

#11. Now verify the Java support by restarting Firefox and enter about:plugins on the address bar.
