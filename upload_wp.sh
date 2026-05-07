#!/bin/bash
# USAGE:
# 	use sh upload_wp.sh <URL> <OUTFILE>


jmtpfs /home/box/Sync-Tablet

wget $1 -O /home/box/$2.html

html2pdf /home/box/$2.html

						# TODO: check for correct here!
cp /home/box/$2.pdf -t /home/box/Sync-Tablet/Internal\ shared\ Storage/Books/

fusermount -u /home/box/Sync-Tablet
