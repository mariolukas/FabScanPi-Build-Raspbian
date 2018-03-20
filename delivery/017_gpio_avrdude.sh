#!/bin/bash

BannerEcho "Configure AVR Dude Autoreset: Installing"

AptInstall avrdude python-rpi.gpio strace || return 1

wget https://raw.githubusercontent.com/watterott/RPi-ShieldBridge/master/software/autoreset
wget https://raw.githubusercontent.com/watterott/RPi-ShieldBridge/master/software/avrdude-autoreset

chmod +x autoreset
chmod +x avrdude-autoreset
mv autoreset /usr/bin
mv avrdude-autoreset /usr/bin
mv /usr/bin/avrdude /usr/bin/avrdude-original
ln -s /usr/bin/avrdude-autoreset /usr/bin/avrdude

touch /etc/udev/rules.d/80-arduinopi.rules
echo "KERNEL=="ttyAMA0", SYMLINK+="ttyS0",GROUP="dialout",MODE:=0666" > /etc/udev/rules.d/80-arduinopi.rules

if [ -f /etc/inittab ]; then
  sed -i -e 's/T0:23:respawn:/#T0:23:respawn:/g' /etc/inittab
fi

usermod -a -G dialout pi

BannerEcho "Configure AVR Dude Autoreset: Installation Done"