#!/bin/bash -e
CONFIG=${ROOTFS_DIR}/boot/firmware/config.txt
 
# workaround create permission file for serial 
echo "KERNEL==\"ttyACM0\", MODE=\"0666\" " > ${ROOTFS_DIR}/etc/udev/rules.d/20-serial-device-permissions.rules
echo "KERNEL==\"ttyAMA0\", MODE=\"0666\" " >> ${ROOTFS_DIR}/etc/udev/rules.d/20-serial-device-permissions.rules

on_chroot << EOF
	usermod -a -G tty ${FIRST_USER_NAME}
EOF

# enable swapping
install -m 644 files/dphys-swapfile "${ROOTFS_DIR}/etc/dphys-swapfile"

# configure firstboot options
install -m 777 files/rc.local "${ROOTFS_DIR}/etc/rc.local"
install -m 777 files/firstboot.sh "${ROOTFS_DIR}/root/firstboot.sh"

on_chroot << EOF
	if [ "${ENABLE_SWAPPING}" == "1" ]; then
		systemctl enable dphys-swapfile
	fi

  # disabale bluetooth
  systemctl disable hciuart.service
  systemctl disable bluealsa.service
  systemctl disable bluetooth.service

	systemctl enable rc-local
EOF

# disabale bt and configure serial port  to prevent serial port problems..
cat <<EOL >> $CONFIG
[pi3]
dtoverlay=pi3-disable-bt
[pi3+]
dtoverlay=pi3-disable-bt
[pi4]
dtoverlay=disable-bt
[pi5]
dtoverlay=disable-bt
dtparam=uart0_console=on
EOL

# override cmdline.txt with fabscanpi one ( serial console disabled )
install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/firmware"

# setip pi cam 
#echo 'SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"' > ${ROOTFS_DIR}/etc/udev/rules.d/10-vchiq-permissions.rules

on_chroot << EOF
	usermod -a -G video ${FIRST_USER_NAME}
EOF


# override hostname 
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"

# add fabscanpi to hosts list
echo "127.0.0.1       fabscanpi" >> ${ROOTFS_DIR}/etc/hosts
