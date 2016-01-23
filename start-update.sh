#!/bin/bash

. ./variable.sh

mkdir "${CHROOT_DIR}"
mkdir /mnt/ramdir

mount -t overlayfs -o lowerdir=/rofs -o upperdir=/mnt/ramdir none "${CHROOT_DIR}"


echo "new chroot created on $CHROOT_DIR"
echo ""
echo "use:"
echo "./chroot.sh $CHROOT_DIR"
echo ""
