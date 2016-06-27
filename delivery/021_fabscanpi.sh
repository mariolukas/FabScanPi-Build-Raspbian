#!/bin/bash

BannerEcho "FabScanPi Server: Installing"

AptInstall fabscanpi-server || return 1

update-rc.d fabscanpi-server defaults


BannerEcho "FabScanPi Server: Installation Done"
