#!/bin/bash -e

install -m 644 files/haproxy.conf "${ROOTFS_DIR}/etc/haproxy/haproxy.cfg"
install -m 644 files/503-no-fabscanpi.http "${ROOTFS_DIR}/etc/haproxy/errors/503-no-fabscanpi.http"

# generate snakeoil certs
on_chroot << EOF
	#make-ssl-cert generate-default-snakeoil --force-overwrite
	cat /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/private/ssl-cert-snakeoil.key > /etc/ssl/snakeoil.pem
	systemctl enable haproxy
EOF
