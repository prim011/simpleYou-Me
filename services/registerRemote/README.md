# Copyrights(c) - Francesco Fiaschi


This script uses the remoteit functionality to connect and register the
device under the "hostname", which by default has been placed to "miniNAS-FF".

The services is programmed as "idle" (i.e. to start only when the system is up)
and will launch the conenctMe-You.sh script. It will restart until it exits
succesfully (i.e. Restart=on-failure) after 220sec has been elapsed
(i.e. RestartSec=220s ~3.6min)

The script first check on internet connection, if not present exits with failure
and the service will resume in 220s. If the network is present then it will
perform the following actions

1) login on remoteit
2) register the device with "hostname": if already registered with another
   device it will remove the package and services associated and will reinstall
   remoteit as fresh
3) If it's first time the device has been registered, it will create the 
   ssh and vnc services.
4) logout from remoteit

Extracted from simpleMe&You 1-5 image from the 29th of September 2020. 


The *.service file does live in /etc/systemd/system, whereas the scripts, *.sh,
normally lives in /usr/local/bin
