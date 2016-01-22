#!/bin/bash

. ./variable.sh

if ! [ -f /usr/bin/mkisofs ]; then
apt-get install genisoimage -y
fi


mkdir "${CDROM_RW}"
mkdir /mnt/ramdir2
mkdir /mnt/ramdir2_b

# this doesn't work like expected. So remove for now
# mount -t overlayfs -o lowerdir="${CDROM_RO}" -o upperdir=/mnt/ramdir2 -o workdir="/mnt/ramdir2_b" none "${CDROM_RW}"
# rm -rf "${CDROM_RW}/casper"

./create_squash.sh "${CDROM_RW}/casper"

if test -f "${CDROM_RW}/casper/filesystem.squashfs"; then
	rsync --ignore-existing -avP "${CDROM_RO}/" "${CDROM_RW}/"
	echo "create iso"
	cd "${CDROM_RW}"
	mkisofs -D -r -V "${CD_TITLE:-Ubuntu}" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o "$ISO_FILE" .
fi
