#!/bin/bash

BannerEcho "OpenCV: Installing"

AptInstall libtbb2 python-opencv-tbb  || return 1

BannerEcho "OpenCV: Done"
