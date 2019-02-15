#!/bin/bash -e

install -m 644 files/avahi-daemon.conf "${ROOTFS_DIR}/etc/avahi/avahi-daemon.conf"

on_chroot << EOF
	systemctl enable avahi-daemon
EOF
