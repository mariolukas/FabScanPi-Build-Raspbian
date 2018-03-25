#!/bin/bash


BannerEcho "Tools: Installing"
# raspberrypi-sys-mods ( package to install)
AptInstall raspi-copies-and-fills libraspberrypi0 raspi-config libraspberrypi-bin mc htop minicom || return 1

BannerEcho "Tools: Done"

