#!/bin/bash


BannerEcho "wifi: Installing"

AptInstall wpasupplicant || return 1

"

auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
" >> /etc/network/interfaces

"
update_config=1
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
eapol_version=1

network={
ssid="YOUR_SSID"
psk="YOUR_SECRET"
proto=RSN
key_mgmt=WPA-PSK
pairwise=CCMP
auth_alg=OPEN
}
" > /etc/wpa_supplicant/wpa_supplicant.conf

# deactivate sleep mode
"
options 8192cu rtw_power_mgnt=0 rtw_enusbss=0
" > /etc/modprobe.d/8192cu.conf

BannerEcho "wifi: Done"

