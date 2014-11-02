#!/bin/bash

if test ${UID} -ne 0; then
  sudo $0
  exit 0
fi

mount -o remount,rw /cdrom

if test -e /dev/mapper/private-usb; then
  echo already unlocked.
  exit 1
fi

cryptsetup luksOpen /cdrom/private.dd private-usb

mkdir /root/mount

mount /dev/mapper/private-usb /root/mount || exit 1    # TODO more error handling

mkdir /root/mount/user/.ssh
mkdir /root/mount/system
mkdir /root/mount/system/wifi

rsync -avP /root/mount/system/wifi/ /etc/NetworkManager/system-connections/
rsync -avP /etc/NetworkManager/system-connections/ /root/mount/system/wifi/

killall -HUP NetworkManager


export NORMAL_USER=$(who | awk '{print $1}' | uniq | grep -v root)

mkdir /home/${NORMAL_USER}/.ssh || exit 1    # TODO more error handling

mount -o bind /root/mount/user/.ssh /home/${NORMAL_USER}/.ssh   # TODO more error handling
chown $NORMAL_USER:$NORMAL_USER /home/${NORMAL_USER}/.ssh

sh /root/mount/start_private.sh
