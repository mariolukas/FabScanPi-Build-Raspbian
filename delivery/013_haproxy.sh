#!/bin/bash

BannerEcho "Haproxy: Installing"

AptInstall haproxy || return 1

cp etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg

BannerEcho "Haproxy: Done"
