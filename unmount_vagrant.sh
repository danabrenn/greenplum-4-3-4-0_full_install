#!/usr/bin/env bash

echo "***** Unmounting /vagrant From All Hosts *****"

# change to the root directory
cd /

# unmount the /vagrant directory
umount -l /vagrant