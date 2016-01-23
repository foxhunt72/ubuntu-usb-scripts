#!/bin/bash

. ./variable.sh

if [ -n "$1" ]; then
  export CASPER_NEW_DIR="$1"
fi

if ! [ -f /usr/bin/mksquashfs ]; then
  apt-get install squashfs-tools -y
fi


####
# usb drive writable
mount -o remount -o rw /cdrom

if test -d "${CASPER_NEW_DIR}"; then
	echo "${CASPER_NEW_DIR} already exists, please remove"
	exit 1
fi

mkdir "${CASPER_NEW_DIR}"

if ! [ -d "${CASPER_NEW_DIR}" ]; then
  echo "can't create $CASPER_NEW_DIR"
  echo "posible readonly media."
  echo "Change dir with $0 [alternative_dir]"
  exit 1
fi

rm -rf "${CHROOT_DIR}"/var/cache/apt/*

chroot ${CHROOT_DIR} dpkg-query -W --showformat='${Package} ${Version}\n' | tee ${CASPER_NEW_DIR}/filesystem.manifest
cp -v ${CASPER_NEW_DIR}/filesystem.manifest ${CASPER_NEW_DIR}/filesystem.manifest-desktop
REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
for i in $REMOVE 
do
	        sudo sed -i "/${i}/d" ${CASPER_NEW_DIR}/filesystem.manifest-desktop
done

for i in proc sys dev
do
  umount ${CHROOT_DIR}/${i} 2>/dev/null
  umount -l ${CHROOT_DIR}/${i} 2>/dev/null

  if ! df "${CHROOT_DIR}/${i}" | grep "${CHROOT_DIR}$" >/dev/null; then
	echo "ERROR: $i is still mounted on ${CHROOT_DIR}/${i}"
	exit 1
  fi
done

# controleer of ze unmounted zijn



# compress the chroot
mksquashfs ${CHROOT_DIR} ${CASPER_NEW_DIR}/filesystem.squashfs
rsync --ignore-existing -avP "${CASPER_DIR}/" "${CASPER_NEW_DIR}/"
printf $(sudo du -sx --block-size=1 ${CASPER_NEW_DIR} | cut -f1) > ${CASPER_NEW_DIR}/filesystem.size

