#!/bin/bash

## Run as Root

## Dependencies

sudo apt install -y squashfs-tools
sudo apt install -y genisoimage
sudo apt install -y zip

## DL iso maker scripts

sudo apt install -y git
git clone https://github.com/Tomas-M/linux-live.git ~/linux-live.git

#cd ~/linux-live.git
#./build

## view iso file in directory

#cd /tmp
#ls *.iso
