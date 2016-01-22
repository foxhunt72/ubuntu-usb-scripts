#!/bin/bash

. ./variable.sh

mkdir "${CHROOT_DIR}"
mkdir /mnt/ramdir

mount -t overlayfs -o lowerdir=/rofs -o upperdir=/mnt/ramdir none "${CHROOT_DIR}"
