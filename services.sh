#!/bin/bash
echo -e "Paramenters can be: $0 <kill> and/or <remove>"
if [ "$1" == "kill" ]; then
    sudo killall dropbox insync anydesk TeamViewer java chrome firefox 	
fi
if [ "$1" == "remove" ]; then 
	update-rc.d smbd remove
	update-rc.d samba remove
	update-rc.d nmbd remove
	update-rc.d apache2 remove
	update-rc.d docker remove
	update-rc.d apache-htcacheclean remove
	update-rc.d mongodb remove
	update-rc.d cups remove
	update-rc.d cups-browsed remove
	update-rc.d avahi remove
	update-rc.d avahi-daemon remove
else
	sudo service crtmpserver stop
	sudo service smbd stop
	sudo service samba stop
	sudo service nmbd stop
	sudo service apache2 stop
	sudo service docker stop
	sudo service apache-htcacheclean stop
	sudo service mongodb stop
	sudo service cups stop
	sudo service cups-browsed stop
	sudo service avahi stop
	sudo service avahi-daemon stop
	sudo service openbsd-inetd stop
	sudo service mysql stop
	sudo service speech-dispatcher stop
	sudo service unattended-upgrades stop
	sudo service apache-htcacheclean stop
	sudo service gdomap stop
fi
