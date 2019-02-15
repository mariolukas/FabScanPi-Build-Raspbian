#!/bin/bash -e

install -m 644 files/fabscanpi.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"

if [ "$FABSCANPI_STAGE" = "stable" ]; then
	sed -i -e 's/testing/stable/g' "${ROOTFS_DIR}/etc/apt/sources.list.d/fabscanpi.list"
fi	

on_chroot apt-key add - < files/fabscan.public.gpg.key
on_chroot << EOF
apt-get update
apt-get dist-upgrade -y
EOF
