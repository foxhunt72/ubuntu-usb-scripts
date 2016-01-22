#!/bin/bash

mount -o remount,rw /cdrom

rsync -avP /var/cache/apt/archives/*.deb /cdrom/packages/ 

sync
