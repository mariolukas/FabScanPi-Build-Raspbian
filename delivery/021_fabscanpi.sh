#!/bin/bash

BannerEcho "FabScanPi Server: Installing"

AptInstall libharfbuzz-bin fabscanpi-server || return 1

update-rc.d fabscanpi-server defaults

BannerEcho "FabScanPi Server: Installation Done"
