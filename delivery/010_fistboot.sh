#!/bin/bash

AptInstall avahi-daemon || return 1

cp /usr/src/delivery/firstboot.sh /root/firstboot.sh
cp /usr/src/delivery/resize_root_partition /usr/sbin/resize_root_partition

cat << EOF > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing

if [ ! -e /root/firstboot_done ]; then
        touch /root/firstboot_done
        if [ -e /root/firstboot.sh ]; then
                /root/firstboot.sh
        fi
fi

exit 0
EOF

