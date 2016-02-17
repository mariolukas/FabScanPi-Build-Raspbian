#!/bin/bash


BannerEcho "Tools: Installing"

AptInstall raspstill mc htop || return 1

BannerEcho "Tools: Done"

