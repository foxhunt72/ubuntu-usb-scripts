#!/bin/bash

. variable.sh

####
# usb drive writable
mount -o remount -o rw /cdrom

if test -d "${CASPER_NEW_DIR}"; then
	echo "${CASPER_NEW_DIR} already exists, please remove"
	exit 1
fi

mkdir "${CASPER_NEW_DIR}"

chroot ${CHROOT_DIR} dpkg-query -W --showformat='${Package} ${Version}\n' | tee ${CASPER_NEW_DIR}/filesystem.manifest
cp -v ${CASPER_NEW_DIR}/filesystem.manifest ${CASPER_NEW_DIR}/filesystem.manifest-desktop
REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
for i in $REMOVE 
do
	        sudo sed -i "/${i}/d" ${CASPER_NEW_DIR}/filesystem.manifest-desktop
done

umount ${CHROOT_DIR}/proc
umount ${CHROOT_DIR}/sys
umount ${CHROOT_DIR}/dev


# compress the chroot
mksquashfs ${CHROOT_DIR} ${CASPER_NEW_DIR}/filesystem.squashfs
printf $(sudo du -sx --block-size=1 ${CASPER_NEW_DIR} | cut -f1) > ${CASPER_NEW_DIR}/filesystem.size

