#!/bin/bash

if test -z "$1"; then
  echo no options....
  exit 1
fi

mount -o rbind /dev $1/dev
mount -o rbind /proc $1/proc
mount -o rbind /sys $1/sys

cp /etc/resolv.conf $1/etc/
chroot $1


umount $1/dev
umount $1/proc
umount $1/sys

