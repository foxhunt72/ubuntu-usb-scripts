#!/bin/bash

export MB=150

mount -o remount,rw /cdrom

if test -f /cdrom/private.dd; then
  echo already exists, private file
  exit 1
fi

echo create block file on usb stick
dd if=/dev/zero of=/cdrom/private.dd bs=1M count=${MB}

echo create luks crypt on block file

cryptsetup luksFormat /cdrom/private.dd

echo opening luks block device
cryptsetup luksOpen /cdrom/private.dd private-usb

if test -e /dev/mapper/private-usb; then
  mkfs.ext4 /dev/mapper/private-usb
fi 

