#!/bin/bash

BannerEcho "OpenCV: Installing"

AptInstall libtbb2 python-opencv-tbb  || return 1

apt-get -f -y install

BannerEcho "OpenCV: Done"
