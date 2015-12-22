#!/bin/bash
# This script will run the first time the raspberry pi boots.
# It is ran as root.

echo 'Starting firstboot.sh' >> /dev/kmsg

# resize root partion to possible maximum
echo 'Resizing root partition' >> /dev/kmsg
/usr/sbin/resize_root_partition

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

# Set locale
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

cat << EOF | debconf-set-selections
locales   locales/locales_to_be_generated multiselect     en_US.UTF-8 UTF-8
EOF

rm /etc/locale.gen
dpkg-reconfigure -f noninteractive locales
update-locale LANG=en_US.UTF-8

cat << EOF | debconf-set-selections
locales   locales/default_environment_locale select       en_US.UTF-8
EOF

echo 'Reconfigured locale' >> /dev/kmsg

# Set timezone
#echo 'Europe/Berlin' > /etc/timezone
#dpkg-reconfigure -f noninteractive tzdata

#echo 'Reconfigured timezone' >> /dev/kmsg

#echo 'Enabling and starting docker service' >> /dev/kmsg
#systemctl enable docker.service
#systemctl start docker.service

#echo 'Import Docker Swarm image' >> /dev/kmsg
#sleep 5
#docker load < /var/hypriot/swarm.tar.gz
#if (($? == 0)); then
#  rm -f /var/hypriot/swarm.tar.gz
#fi


