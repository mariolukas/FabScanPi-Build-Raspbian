#!/bin/bash

BannerEcho "Users: Setting Up"

NEW_USER="pi"
NEW_USER_PASSWORD="raspberry"
adduser --disabled-password --gecos "" "${NEW_USER}"
echo "${NEW_USER}:${NEW_USER_PASSWORD}" | chpasswd
chsh -s /bin/bash "${NEW_USER}"

AptInstall sudo
adduser "${NEW_USER}" sudo

BannerEcho "Users: Done"
