#!/bin/bash


BannerEcho "avahi-daemon: Installing"

AptInstall avahi-daemon || return 1

update-rc.d avahi-daemon defaults

BannerEcho "avahi-daemon: Done"
