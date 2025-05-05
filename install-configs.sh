#!/bin/bash

from=$(pwd)
to=$2


printf "\n\n[INSTALL] installing nixos on ${to} and transfering data from: ${from}\n"
printf "\n---------------------------------------------------\n"


# connect to wifi network
#
# USAGE: 		connect_network
connect_network() {

	printf "\n\n[WIFI]: Connecting to wifi now.\n\n"

	systemctl start wpa_supplicant

	# user logs into a network
	wpa_cli 

	printf "\n\n[WIFI]: SUCCESSFULLY CONNECTED TO WIFI\n\n"
	printf "\n---------------------------------------------------\n"
}


# formats the disk that nixos will be installed on
# 
# USAGE:		format_disks <disk-to-format>
format_disk() {

	printf "\n[FORMAT_DISK]: erasing and formating ${1}"
	
	# make table
	parted $1 -- mklabel gpt

	# make boot partition
	parted $1 -- mkpart ESP fat32 1MB 512MB
	parted $1 -- set 1 boot on

	# make root partition
	parted $1 -- mkpart root ext4 512MB -8GB

	printf "[FORMAT_DISK]: formating filesystem ${1}2"

	mkfs.ext4 -L nixos "${1}2"

	printf "[FORMAT_DISK]: formating boot ${1}1"

	mkfs.fat -F 32 -n boot "${1}1"

	printf "[FORMAT_DISK]: mounting ${1}2 to /mnt"

	mount "${1}2" /mnt

	mkdir -p /mnt/boot

	printf "[FORMAT_DISK]: mounting ${1}1 to /mnt/boot"

	mount -o umask=077 "${1}1" /mnt/boot
	
	lsblk

	printf "\n\n[FORMAT_DISK]: SUCCESSFULLY FORMATED:\n\t ${1}2 -> /mnt \n\t ${1}1 -> /mnt/boot \n\n"
	printf "\n---------------------------------------------------\n"
}


# transfers configuration.nix and hardware-configuration.nix 
# to the destination disk
# 
# USAGE: 			transfer_config <config-dir>
transfer_config() {

	printf "\n[CONFIG.NIX]: Transfering configurations.nix now!"m

	# generate /mnt/etc/nixos/*
	nixos-generate-config --root /mnt

	cp "${1}/configs/*.nix" -t /mnt/etc/nixos/

	# open copied files on mnt for verification
	nano /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/hardware-configuration.nix

	# successfull verbose
	printf "\n\n[CONFIG.NIX]: SUCCESSFULLY TRANSFERED configuration.nix ${1} -> /mnt\n\n"
	printf "\n---------------------------------------------------\n"
}


# transfers many configs to the new nixos installation
# USAGE:			post_install <config-dir>
post_install() {

	printf "\n[POST-INSTALL]: Starting post installation."

	
	# copy bashrc.local
	cp "${1}/configs/bashrc.local" /mnt/etc/bashrc.local

	mkdir /mnt/home/box/.config/i3

	# copy the i3 config directory
	cp -r "${1}/configs/i3-config" /mnt/home/box/.config/i3/config

	# copy .bashrc 
	cp "${1}/configs/.bashrc" /mnt/home/box/.bashrc

	# make scripts directory
	mkdir /mnt/home/box/scripts

	# copy scripts into new directory
	cp -r "{$1}/scripts/*" -t /mnt/home/box/scripts/

	printf "\n\n[POST-INSTALL]: SUCCESSFULLY transfered all configs.\n"
	printf "\n---------------------------------------------------\n"
}


# WORK FLOW:

	# connect_network 				# connects to  wifi network

	# format_disk $to				# formats and mounts disk

	# transfer_config $from			# transfers configuration.nix files to new disk

	# nixos-install 				# install nixos

	# post_install $from 			# transfer relevant data 
