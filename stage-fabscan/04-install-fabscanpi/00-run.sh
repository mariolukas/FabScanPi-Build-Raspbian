#!/bin/bash -e

on_chroot << EOF
	systemctl enable fabscanpi-server
EOF

sleep 20