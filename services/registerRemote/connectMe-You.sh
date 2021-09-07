#!/usr/bin/env sh


# Script to connect and register the device with Remoteit
#
# The script first check if internet connation is available by pinging
# google.com. If no answer is returned there is no need to continue
# and the script exit with an error, so that it can restart at a later
# stage (see registerRemote.service and the "Restart=on-failure" option
# and the "RestartSec" value).
# The script extracts the Remoteit authentication information from an
# external file (FILENAME); It then uses those to perfoms the following
# actions:
#
#    1) Registering the device (in case it was the first time run)
#    2) Once the device has been registered adding two services.
#
# The two services are SSH and VNC

FILENAME=/usr/local/bin/auth

okSymbol="✓"
failSymbol="×"
alreadyConfigured="already configured"
alreadyRegistered="already registered"

# needed services are ssh and vnc with 
# default ports 
sshScr="ssh-FF"
sshPortScr=22
vncScr="vnc-FF"
vncPortScr=5900

echo "..check network connectivity"

if ping -c 1 -W 5 google.com 1>/dev/null 2>&1 
  then
      echo -en '\E[47;32m'"\033[1mS\033[0m"
      echo "Connected!"
  else
      echo -en '\E[47;31m'"\033[1mZ\033[0m"
      echo "Not Connected!"
      exit 1
  fi

echo "Authentication File Name: $FILENAME"
 
# let's login first
cat $FILENAME | xargs sudo remoteit signin

# let's  see if the device is already registered
if sudo remoteit register >&1 | grep -q "${okSymbol}"; then
	echo "...registration was succesfull"
else
	echo "...soemthing went wrong during the registration"
        echo "device might be already registered under a different name: let's try to unregister and reregister"
	if sudo remoteit unregister --yes >&1 | grep -q "${okSymbol}"; then
		if sudo remoteit register --name $HOSTNAME >&1 | grep -q "${failSymbol}"; then
			echo "... something went wrong during re-registration of legacy name: need something drastic"
              		sudo apt remove --yes remoteit
              		sudo apt-get install --yes remoteit
		else
			echo "registration succesfull under ${HOSTNAME}"
		fi
	else
		echo "... something went wrong during deregistration of legacy name: need something drastic"
                sudo apt remove --yes remoteit
                sudo apt-get install --yes remoteit
	fi
fi

# let's check on the services 
if sudo remoteit remove |grep -q $sshScr; then
	echo "service " $sshScr " already present"
else
	# let's add ssh as services (default port is 20)
	sudo remoteit add --name $sshScr --port $sshPortScr --type ssh
fi

if sudo remoteit remove |grep -q $vncScr; then
        echo "service " $vncScr " already present"
else
	# let's add vnc as a service (default port is 5900)
	sudo remoteit add --name $vncScr --port $vncPortScr --type vnc
fi

# ... all done: let's logout
sudo remoteit signout

exit 0

