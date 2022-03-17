#!/bin/bash -e

install -m 644 files/sources.list.d/fabscanpi.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
install -m 644 files/preferences.d/fabscan "${ROOTFS_DIR}/etc/apt/preferences.d/"

sed -i "s/RELEASE/${FABSCANPI_STAGE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/fabscanpi.list"

#on_chroot apt-key add - < files/fabscan.public.gpg.key
cat files/fabscan.public.gpg.key | gpg --dearmor > "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/fabscan.public.gpg"
on_chroot << EOF
apt-get update
apt-get dist-upgrade -y
EOF
