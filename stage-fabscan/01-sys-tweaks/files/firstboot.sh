#!/bin/bash
# This script will run the first time the raspberry pi boots.
# It is ran as root.

echo 'Starting firstboot.sh' >> /dev/kmsg

# resize root partion to possible maximum
echo 'Resizing root partition' >> /dev/kmsg

raspi-config nonint do_expand_rootfs

# Get current date from debian time server
ntpdate 0.debian.pool.ntp.org

echo 'Reconfiguring openssh-server' >> /dev/kmsg
echo '  Collecting entropy ...' >> /dev/kmsg

# Drain entropy pool to get rid of stored entropy after boot.
dd if=/dev/urandom of=/dev/null bs=1024 count=10 2>/dev/null

while entropy=$(cat /proc/sys/kernel/random/entropy_avail); [ $entropy -lt 100 ]
	do sleep 1
done

rm -f /etc/ssh/ssh_host_*
echo '  Generating new SSH host keys ...' >> /dev/kmsg
dpkg-reconfigure openssh-server
echo '  Reconfigured openssh-server' >> /dev/kmsg

reboot
