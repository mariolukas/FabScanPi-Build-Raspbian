#!/bin/bash

BannerEcho "CONFIG.TXT: Configure"

if [ ! -f /boot/config.txt ]; then
    touch /boot/config.txt
fi

echo "hdmi_force_hotplug=1" >> /boot/config.txt

# enable camera module
echo "start_x=1" >> /boot/config.txt
# more gpu memory
echo "gpu_mem=128" >> /boot/config.txt
# disable camera led
echo "disable_camera_led=1" >> /boot/config.txt
# max usb power
#echo "max_usb_current=1" >> /boot/config.txt

# disabale bt on raspberry pi3 to prevent serial port problems..
echo "dtoverlay=pi3-disable-bt" >> /boot/config.txt


echo "+dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 cgroup-enable=memory swapaccount=1 elevator=deadline rootwait" > /boot/cmdline.txt

BannerEcho "CONFIG.TXT: Configure Done"
