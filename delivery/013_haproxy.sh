#!/bin/bash

BannerEcho "Haproxy: Installing"

AptInstall haproxy || return 1

BannerEcho "Haproxy: Done"
