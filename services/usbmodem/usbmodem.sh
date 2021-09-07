#!/usr/bin/env sh

# Script for setting up modem over USB
#
# Currently only two types of modems are supported:
#
#     - Wireless 3G Mobile Wifi Router Usb Dongle Mobile Broadband Modem Port (https://www.ebay.co.uk/itm/393426638804?_trkparms=ispr%3D1&hash=item5b9a0e17d4:g:PdIAAOSwocxf~XIU&amdata=enc%3AAQAGAAACkPYe5NmHp%252B2JMhMi7yxGiTJkPrKr5t53CooMSQt2orsSU8qUIAeVPdz29zRlje3Lg3ghZCNWTvBTnKwOAx7Uv5Wn0ROVxJrkL2WYvusmxNTu1sB1OSzI3mhfwfccgOknA01kUajPo854a520WFkdkJu6V9ttLne5bs1IGxZZ9xwpc2iJWzh9BLE1%252BuLTRkFGX2XpgVLOUimU%252BL9xPMcSg9JUGcNIEMJn1Jwsy03xdVmJ4h80EsG2JlKED8lIi63tjRlu%252F7mCoysZyHjSuOlxQ0AzUsvOXqM6n9Yo7lqy2XBlDdG6o7d9MFtHEmp5c1kkshA%252BIw%252BKh8Pks%252F%252FXQeDenYAyC7mIy3GNexicodMNkacG5lmYSVnC7mTQBKZo8DxesXiCLfKfCpqEkmpMq8ojY61bnm8AXn%252Fa81U7yYS0KKNIjn91CCxiOXOlw3WPBpr2yIWIaUMUa3E90ohufZhdXoX0xNs9XA8AG%252BWpzpmS8t5P%252BIIpGpWUwQgL%252Bv3TUo5hvVRJYS%252BmBDf5pm35c%252B1BgQp97eE%252BtN5%252Bwjx8z%252BqUKcP8ZGW991vxOvgT8Ai6FCmvaJoU9PmG0Z5IisxXTq8VazNETgAp8sAWxq8ZES3VeHT%252Bo9UGk1VjXHVCA6N3U5Ad20eeiL4U21paCWcjPBOZe1dlm0yEDX70btdVJ9rAYWgyOd8x2NxGfcpnU9n2fiF6139tg5SoCckWDs2hshbFouclwZM%252FSlBwc5FEbSQagRDWS90BazTbC0fZ1ddA%252BAbFmrZn4TJ7p%252BS53r4ryR7BTQzZJiOKGkxAKCH6jSH7Rg1zm%252FYKCyJH9jAIq5dgJH6LELTc9i3IoVTrn6Cyt6UkGM31wk%252BI76AlxmuwtTfgA%252FLu%7Campid%3APL_CLK%7Cclp%3A2334524)
#     - Alcatel Link Key IK40V 4G LTE Cat.4 modem 150 mBps SMS/USSD/DHCP (https://www.ebay.co.uk/itm/273199137461?hash=item3f9bf002b5:g:D8QAAOSw~O1a4IrX)
#
# The script first attempts to initialize the Alcatel, which is not the default option. This
# modem does not require AT command initializations; hence the wvdial is not required, becuase
# at power-up it does immediately connect to the 4G/3G network, independently.
# The default modem based on Broadcom chipset, though, it does require AT command initialization
# to access the network and ebsatblish connection; so it's done later, only if it has been re-
# cogonized as the attached USB modem doungle


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
