#!/bin/bash

BannerEcho "Meshlab: Installing"

AptInstall meshlab xvfb || return 1

BannerEcho "Meshlab: Installation Done"

