#!/bin/bash

mkdir /mnt/newroot
mkdir /mnt/ramdir

mount -t overlayfs -o lowerdir=/rofs -o upperdir=/mnt/ramdir none /mnt/newroot
