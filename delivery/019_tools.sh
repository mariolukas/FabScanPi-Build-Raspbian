#!/bin/bash


BannerEcho "Tools: Installing"

AptInstall raspistill mc htop minicom || return 1

BannerEcho "Tools: Done"

