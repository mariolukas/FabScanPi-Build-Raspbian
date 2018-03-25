#!/bin/bash

BannerEcho "Network: Installing"

rm /etc/systemd/network/99-default.link

sudo ln -s /lib/udev/rules.d/80-net-setup-link.rules /etc/udev/rules.d/80-net-setup-link.rules

echo "127.0.0.1       fabscanpi" >> /etc/hosts

BannerEcho "Network: Installing Done"
