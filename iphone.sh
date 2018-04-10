#!/bin/bash
## source: https://gist.github.com/samrocketman/70dff6ebb18004fc37dc5e33c259a0fc

user="" # "~"

case "$1" in
	"mount")
		sudo su
		type -p ifuse
		type -p idevicepair
		idevicepair pair
		ifuse ${user}/usr/mnt/
		sleep 10
		idevicepair pair
		ifuse ${user}/usr/mnt/
		ls ${user}/usr/mnt/
		udisksctl mount --block-device=/dev/sdb1
		virtualbox --startvm "w7" &
		exit
	;;
	"umount")
		fusermount -u ${user}/usr/mnt
		exit
	;;
	"install")
		mkdir -p "${user}/usr/src"

		sudo apt-get install automake libtool pkg-config libplist-dev libplist++-dev python-dev libssl-dev libusb-1.0-0-dev libfuse-dev -y
		sudo apt-get install libusbmuxd* libimobiledevice* -y

		cd ~/usr/src

		for x in libplist libusbmuxd usbmuxd libimobiledevice ifuse; do
			git clone https://github.com/libimobiledevice/${x}.git;
		done

		#Build libplist
		cd ~/usr/src/libplist
		./autogen.sh --prefix="$HOME/usr"
		make && make install

		#Build libusbmuxd
		cd ~/usr/src/libusbmuxd
		./autogen.sh --prefix="$HOME/usr"
		make && make install

		#Build libimobiledevice
		cd ~/usr/src/libimobiledevice
		./autogen.sh --prefix="$HOME/usr"
		make && make install

		#Build usbmuxd
		#Unfortunately, sudo make install is required because it needs to write to /lib/udev/rules.d and /lib/systemd/system.
		cd ~/usr/src/usbmuxd
		./autogen.sh --prefix="$HOME/usr"
		make && sudo make install

		#Build ifuse
		cd ~/usr/src/ifuse
		./autogen.sh --prefix="$HOME/usr"
		make && make install
		# tests
		mkdir -p ~/usr/mnt
		type -p ifuse
		type -p idevicepair
		idevicepair pair
		ifuse ~/usr/mnt/
		ls ~/usr/mnt/
		# move to global
		sudo su
		cp -rf usr/* /usr/
		exit
	;;
	*)
		echo "Choose: mount || umount || install"
	;;
esac	

