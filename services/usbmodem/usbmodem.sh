#!/usr/bin/env sh

if [ "$(id -u)" -eq 0 ]
then
  if lsusb | grep -q "T & A Mobile"; then
	echo Alcatel 4G/LTE Modem
        usb_modeswitch -c /etc/usb_modeswitchAlcatel.conf
  else
	echo Not an Alcatel Modem
 	echo ...trying default dongle
	if usb_modeswitch -c /etc/usb_modeswitch.conf |grep -q "Bye!"; then
		echo "...something went wrong in switching to modem"
 	else
		echo "succesfully configured default dongle"
		echo "...attempt to configure via AT commands"
  		if wvdial id4gconnect; then
  			echo "Internet connection succesful!"
		else
			echo "...something went wrong in the initialization"
		fi
	fi
  fi
else
  echo "You need to be ROOT (sudo can be used)"
fi
