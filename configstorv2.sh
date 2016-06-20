#!/bin/bash 

#Updates system and packages to latest revisions
#yum update -y

#Creates Raid 0 array on two disks, /dev/sdc & /dev/sdd

mdadm --create /dev/md127 --level 0 --raid-devices 2 /dev/sdc /dev/sdd
sleep 10

#Creates partion on Raid 0 volume

parted /dev/md127 --script mklabel gpt
parted /dev/md127 --script mkpart primary 0% 100%

#Formates partition using XFS
mkfs.xfs /dev/md127p1

#Creates mount point and updates fstab so mount point persists during reboots, automatically mounts volumes for current session
mkdir -p /data
#add to fstabl
echo /dev/md127p1 /data                   xfs     defaults        0 0 >> /etc/fstab
mount -a