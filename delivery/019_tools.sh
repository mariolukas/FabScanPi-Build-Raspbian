#!/bin/bash


BannerEcho "Tools: Installing"

AptInstall mc htop minicom || return 1

BannerEcho "Tools: Done"

