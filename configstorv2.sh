#!/bin/bash

#Creates Raid 0 array on two disks, /dev/sdc & /dev/sdd
mdadm --create /dev/md127 --level 0 --raid-devices 2 /dev/sdc /dev/sdd
#Formates partition using XFS
mkfs.xfs /dev/md127 -f
#Creates mount point and updates fstab so mount point persists during reboots, automatically mounts volumes for current session
mkdir -p /data
#add to fstabl
echo /dev/md127 /data                   xfs     defaults        0 0 >> /etc/fstab
#mount volumes
mount -a
#Allow everyone access to /data
chmod 777 /data