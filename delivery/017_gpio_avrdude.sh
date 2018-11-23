#!/bin/bash

BannerEcho "Configure AVR Dude Autoreset: Installing"

AptInstall avrdude python-rpi.gpio strace || return 1

#wget https://github.com/watterott/RPi-UNO-HAT/raw/master/software/autoreset
#wget https://github.com/watterott/RPi-UNO-HAT/raw/master/software/avrdude-autoreset

cp /usr/src/delivery/scripts/autoreset /usr/bin
cp /usr/src/delivery/scripts/avrdude-autoreset /usr/bin

chmod +x /usr/bin/autoreset
chmod +x /usr/bin/avrdude-autoreset

touch /etc/udev/rules.d/80-arduinopi.rules
echo "KERNEL=="ttyAMA0", SYMLINK+="ttyS0",GROUP="dialout",MODE:=0666" > /etc/udev/rules.d/80-arduinopi.rules

if [ -f /etc/inittab ]; then
  sed -i -e 's/T0:23:respawn:/#T0:23:respawn:/g' /etc/inittab
fi

usermod -a -G dialout pi

BannerEcho "Configure AVR Dude Autoreset: Installation Done"