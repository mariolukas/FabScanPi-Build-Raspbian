#!/bin/bash

BannerEcho "APT: Configure"


echo "deb http://archive.fabscan.org/ jessie main
" >> /etc/apt/sources.list

# add fabscan.org archive key to apt
wget http://archive.fabscan.org/fabscan.public.key -O - | apt-key add -
apt-get update

BannerEcho "APT: Configure Done"

