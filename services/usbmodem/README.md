# Copyrights(c) - Francesco Fiaschi

## Service for configuring the 4G/LTE USB modem

This script uses the Wvdial and other script to interact with the 4G/LTE USB
modem.
The services is programmed to check periodically on a USB presence modem
functionality. It's programmed as "simple" and will launch the usbmodem.sh
script. It will restart until it exits succesfully (i.e. Restart=on-failure)
after 60sec has been elapsed (i.e. RestartSec=60s ~1min)

The script first check on root permissio rights, then it will perform the
following actions:

- check on Alcatel USB modem and configure it with usb_modeswitch and the
  dedicated configuration file in /etc/usb_modeswitchAlcatel.conf
- If not an Alcatel USB modem we are assuming it's a default modem dongle,
  we configure it with a different config file and start connet with AT
  commands in the id4connect file 


Extracted from simpleMe&You 1-5 image from the 29th of September 2020. 


The *.service file does live in /etc/systemd/system, whereas the scripts, *.sh,
normally lives in /usr/local/bin

