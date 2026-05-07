#!/bin/bash

from=$1
to=$2


printf "\n\n[INSTALL] installing nixos on ${to} and transfering data from: ${from}.\n"
printf "\n---------------------------------------------------\n"


# connect to the BSU_Secure wifi network
#
# USAGE: connect_network <password>
connect_network() {

	printf "\n\n[WIFI]: Connecting to wifi now.\n\n"

	systemctl start wpa_supplicant

	wpa_cli 

	printf "\n\n[WIFI]: SUCCESSFULLY CONNECTED TO WIFI\n\n"
	printf "\n---------------------------------------------------\n"
}


# formats the disk that nixos will be installed on
# 
# USAGE:		format_disks <disk-to-format>
format_disk() {

	printf "\n\n[FORMAT_DISK]: erasing and formating ${1}"
	
	# make table
	parted $1 -- mklabel gpt

	# make boot partition
	parted $1 -- mkpart ESP fat32 1MB 512MB
	parted $1 -- set 3 esp on

	# make root partition
	parted $1 -- mkpart root ext4 512MB -8GB

	printf "\n[FORMAT_DISK]: formating filesystem ${1}2"

	mkfs.ext4 -L nixos "${1}2"

	printf "\n[FORMAT_DISK]: formating boot ${1}1"

	mkfs.fat -F 32 -n boot "${1}1"

	printf "\n[FORMAT_DISK]: mounting ${1}2 to /mnt"

	mount "${1}2" /mnt

	mkdir -p /mnt/boot

	printf "\n[FORMAT_DISK]: mounting ${1}1 to /mnt/boot"

	mount -o umask=077 "${1}1" /mnt/boot

	lsblk

	printf "\n\n[FORMAT_DISK]: SUCCESSFULLY FORMATED:\n\t ${1}2 -> /mnt \n\t ${1}1 -> /mnt/boot \n\n"
	printf "\n---------------------------------------------------\n"
}




# transfers configuration.nix and hardware-configuration.nix
# from the fist disk to the next
# 
# USAGE: 			transfer_config <root-disk>
transfer_config() {

	printf "\n[CONFIG.NIX]: Transfering configurations.nix now!"

	# mount from drive to the new directory
	mkdir /tmp/from
	
	mount $1 /tmp/from

	# generate /mnt/etc/nixos/*
	nixos-generate-config --root /mnt

	cp /tmp/from/etc/nixos/* -t /mnt/etc/nixos/

	# open copied files on mnt for varification
	nano /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/hardware-configuration.nix

	# unmount and remove /tmp/from
	umount $1
	rm -r /tmp/from

	# successfull verbose
	printf "\n\n[CONFIG.NIX]: SUCCESSFULLY TRANSFERED configuration.nix ${1} -> /mnt\n\n"
	printf "\n---------------------------------------------------\n"
}





# transfers many configs from one 
# drive to the destination drive
#
# USAGE:			post_install <root-disk>
post_install() {

	printf "\n\n[POST-INSTALL]: Starting post installation."

	mkdir /tmp/from
	mount $1 /tmp/from
	
	# copy bashrc.local
	cp /tmp/from/etc/bashrc.local /mnt/etc/bashrc.local

	# copy the .config directory
	cp -r /tmp/from/home/box/.config -t /mnt/home/box/

	# copy .bashrc 
	cp /tmp/from/home/box/.bashrc /mnt/home/box/.bashrc

	# copy OneDrive
	cp -r /tmp/from/home/box/OneDrive -t /mnt/home/box/

	# make scripts directory
	mkdir /mnt/home/box/scripts

	# copy scripts into new directory
	cp -r /tmp/from/home/box/scripts/* -t /mnt/home/box/scripts/

	umount $1
	rm -r /tmp/from

	printf "\n\n[POST-INSTALL]: SUCCESSFULLY transfered all configs.\n"
	printf "\n---------------------------------------------------\n"
}



# 	$0 		from 			/dev/nvme0n1p2 
#	$1 		to				/dev/sda


connect_network 				# connects to BSU_Secure wifi network

format_disk $to					# formats and mounts disk

transfer_config $from			# transfers configuration.nix files 

# nixos-install 					# install nixos

# post_install $from 				# transfer relevant data 


#TODO:
#
#	make this script pull from github or something like 
#	that instead of transfering from one disk to another
