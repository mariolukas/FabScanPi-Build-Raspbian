#!/bin/bash

AptInstall parted || return 1

cp /usr/src/delivery/firstboot.sh /root/firstboot.sh
cp /usr/src/delivery/resize_root_partition /usr/sbin/resize_root_partition


cat << EOF > /etc/systemd/system/rc-local.service
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF

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

chmod +x /etc/rc.local

systemctl enable rc-local

