#!/bin/bash -e
CONFIG=${ROOTFS_DIR}/boot/config.txt

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

####
# begin activate camera legacy mode
##
sed $CONFIG -i -e '/\[pi4\]/,/\[/ s/^#\?dtoverlay=vc4-f\?kms-v3d/dtoverlay=vc4-fkms-v3d/g'
sed $CONFIG -i -e '/\[pi4\]/,/\[/ !s/^dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/g'
sed $CONFIG -i -e '/\[pi4\]/,/\[/ !s/^dtoverlay=vc4-fkms-v3d/#dtoverlay=vc4-fkms-v3d/g'

if ! sed -n '/\[pi4\]/,/\[/ p' $CONFIG | grep -q '^dtoverlay=vc4-fkms-v3d' ; then
  if grep -q '[pi4]' $CONFIG ; then
    sed $CONFIG -i -e 's/\[pi4\]/\[pi4\]\ndtoverlay=vc4-fkms-v3d/'
  else
    printf "[pi4]\ndtoverlay=vc4-fkms-v3d\n" >> $CONFIG
  fi
fi

sed $CONFIG -i -e 's/^camera_auto_detect.*/start_x=1/g'
sed $CONFIG -i -e 's/^dtoverlay=camera/#dtoverlay=camera/g'

####
# end activate camera legacy mode
##

#disable camera led
echo "disable_camera_led=1" >> $CONFIG

#echo "hdmi_force_hotplug=1" >> ${ROOTFS_DIR}/boot/config.txt

# more gpu memory
echo "gpu_mem=192" >> $CONFIG

# max usb power
#echo "max_usb_current=1" >> /boot/config.txt

# disabale bt on raspberry pi3 to prevent serial port problems..
echo "dtoverlay=pi3-disable-bt" >> $CONFIG

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
