#!/bin/bash


BannerEcho "Tools: Installing"

AptInstall raspstill mc htop minicom || return 1

BannerEcho "Tools: Done"

