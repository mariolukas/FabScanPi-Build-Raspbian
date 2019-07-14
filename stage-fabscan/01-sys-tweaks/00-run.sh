#!/bin/bash -e

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

	systemctl enable rc-local
EOF


# configure boot.txt for fabscanpi
echo " " >> ${ROOTFS_DIR}/boot/config.txt
echo "#fabscan related" >> ${ROOTFS_DIR}/boot/config.txt
echo "hdmi_force_hotplug=1" >> ${ROOTFS_DIR}/boot/config.txt
# enable camera module
echo "start_x=1" >> ${ROOTFS_DIR}/boot/config.txt
# more gpu memory
echo "gpu_mem=128" >> ${ROOTFS_DIR}/boot/config.txt
# disable camera led
echo "disable_camera_led=1" >> ${ROOTFS_DIR}/boot/config.txt


# max usb power
#echo "max_usb_current=1" >> /boot/config.txt

# disabale bt on raspberry pi3 to prevent serial port problems..
echo "dtoverlay=pi3-disable-bt" >> ${ROOTFS_DIR}/boot/config.txt

# override cmdline.txt with fabscanpi one ( serial console disabled )
install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/"

# setip pi cam 
echo 'SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"' > ${ROOTFS_DIR}/etc/udev/rules.d/10-vchiq-permissions.rules

on_chroot << EOF
	usermod -a -G video ${FIRST_USER_NAME}
EOF


# override hostname 
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"

# add fabscanpi to hosts list
echo "127.0.0.1       fabscanpi" >> ${ROOTFS_DIR}/etc/hosts
