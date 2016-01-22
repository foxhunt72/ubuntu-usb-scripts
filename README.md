ubuntu-usb-scripts
==================

remastering scripts for usb drive and some luksscript to make some private data usable on a usb stick


HOWTO
-----

boot from a ubuntu usbstick

### or use kvm, if youre usb stick is not /dev/sdb  change that
sudo qemu-system-x86_64 -cpu qemu64,+vmx -smp cores=2,threads=1,sockets=1 -enable-kvm -hda /dev/sdb -m 1024 -boot c


In the ubuntu live usb do the following actions

# install git
sudo apt-get update
sudo apt-get install git -y

# install the scripts
git clone https://github.com/foxhunt72/ubuntu-usb-scripts.git

# start a new chroot and go in to it with chroot
cd ubuntu-usb-scripts
./start-update.sh
./fox_chroot.sh /mnt/newroot

# do your custimization
# kernel updates??? i wouldn't do them but you could try it, just remember that the kernel is a seperated file on the cdrom 

exit    # out of the chroot

# create a new squashfs directory with al the customization that you did in the chroot
./create_squash.sh




