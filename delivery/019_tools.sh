#!/bin/bash


BannerEcho "Tools: Installing"
# raspberrypi-sys-mods ( package to install)
AptInstall libraspberrypi-bin mc htop minicom || return 1

BannerEcho "Tools: Done"

