#!/bin/bash


BannerEcho "wifi: Installing"

AptInstall firmware-brcm80211 wpasupplicant wireless-tools || return 1

echo "
#auto wlan0
#allow-hotplug wlan0
#iface wlan0 inet dhcp
#wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
#iface default inet dhcp
#pre-up iw dev wlan0 set power_save off
#post-down iw dev wlan0 set power_save on
" >> /etc/network/interfaces

echo "
ctrl_interface=/var/run/wpa_supplicant
update_config=1

ap_scan=1
network={
        ssid="YOUR SSID"
        scan_ssid=1
        psk="YOUR WIFI PASSWORD"
        proto=RSN
        key_mgmt=WPA-PSK
        pairwise=CCMP TKIP
        group=CCMP TKIP
        auth_alg=OPEN
}
" > /etc/wpa_supplicant/wpa_supplicant.conf

# deactivate sleep mode
echo "
options 8192cu rtw_power_mgnt=0 rtw_enusbss=0
" > /etc/modprobe.d/8192cu.conf

BannerEcho "wifi: Done"

