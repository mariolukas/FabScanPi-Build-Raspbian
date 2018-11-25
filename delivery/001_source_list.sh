#!/bin/bash

BannerEcho "APT: Configure"

touch /etc/apt/sources.list.d/raspi.list
echo "deb http://archive.raspberrypi.org/debian/ $deb_release main ui" >> /etc/apt/sources.list.d/raspi.list
echo "deb-src http://archive.raspberrypi.org/debian/ $deb_release main ui" >> /etc/apt/sources.list.d/raspi.list

wget http://archive.raspberrypi.org/debian/raspberrypi.gpg.key -O - | apt-key add -

echo "deb http://archive.fabscan.org/ $fabscan_release main
" >> /etc/apt/sources.list

# add fabscan.org archive key to apt
wget http://archive.fabscan.org/fabscan.public.key -O - | apt-key add -
apt-get update

AptInstall apt-transport-https || return 1

apt-get update

BannerEcho "APT: Configure Done"

