#!/bin/bash

BannerEcho "OpenCV: Installing"


AptInstall libtbb2_4.3 python-opencv-tbb  || return 1

BannerEcho "OpenCV: Done"
