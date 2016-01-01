#!/bin/bash

BannerEcho "Camera: Configure"

echo 'SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"' > /etc/udev/rules.d/10-vchiq-permissions.rules

# add user to video group
usermod -a -G video pi

BannerEcho "Camera: Configure Done"
