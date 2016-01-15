#!/bin/bash

BannerEcho "Users: Setting Up"

NEW_USER="pi"
NEW_USER_PASSWORD="raspberry"
adduser --disabled-password --gecos "" "${NEW_USER}"
echo "${NEW_USER}:${NEW_USER_PASSWORD}" | chpasswd
chsh -s /bin/bash "${NEW_USER}"

# workaround create permission file for serial 
echo "KERNEL==\"ttyACM0\", MODE=\"0666\" " > /etc/udev/rules.d/20-serial-device-permissions.rules
echo "KERNEL==\"ttyAMA0\", MODE=\"0666\" " >> /etc/udev/rules.d/20-serial-device-permissions.rules

AptInstall sudo
adduser "${NEW_USER}" sudo

sudo usermod -a -G tty pi
sudo usermod -a -G dialout pi

BannerEcho "Users: Done"
