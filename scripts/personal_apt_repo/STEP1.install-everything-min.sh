#!/bin/bash

## #############################################################################
##
## ABOUT:
##
## This script will download packages with their complete dependencies.
##
## I don't need all of these on one computer.
## * Many of these packages are either redundant or conflict with each other.
## * This is +4Gb of software. Arranged in alphabetical order for debugging.
## * A library of Debs for my offline Debian "laboratory".
##
## Don't do this as "root", otherwise some things may get "permissioned" out.
##
## Note: You may need to run this script multiple times before all is installed.
##
## Packages: https://www.debian.org/distrib/packages
##
## #############################################################################

## ##################
## Hardware
## ##################
#sudo apt install -y linux-image-4.19.0-10
sudo apt install -y linux-image-$(uname -r)
#sudo apt -t buster-backports install linux-image-$(uname -r)
#sudo apt install -y linux-headers-4.19.0-10
sudo apt install -y linux-headers-$(uname -r)
sudo apt install -y grub-efi-amd64

sudo apt install -y firmware-linux
sudo apt install -y firmware-linux-free
sudo apt install -y firmware-linux-nonfree
sudo apt install -y initramfs-tools
sudo apt install -y firmware-iwlwifi
sudo apt install -y firmware-realtek
sudo apt install -y broadcom-sta-dkms
sudo apt install -y grub

## ##################
## Software
## ##################
sudo apt install -y acpi
sudo apt install -y acpid
sudo apt install -y alsa-base
sudo apt install -y alsa-utils
sudo apt install -y alsa-oss
sudo apt install -y alsamixergui
sudo apt install -y apmd
sudo apt install -y arandr
sudo apt install -y arc-theme
sudo apt install -y aspell
#sudo apt install -y audacity
sudo apt install -y bash
sudo apt install -y bc
sudo apt install -y bridge-utils
sudo apt install -y build-essential
sudo apt install -y cfdisk
sudo apt install -y cmatrix
sudo apt install -y conky
sudo apt install -y cpufrequtils
sudo apt install -y curl
sudo apt install -y dbus-x11
sudo apt install -y debianutils
sudo apt install -y dh-autoreconf
sudo apt install -y dhcpcd5
sudo apt install -y dhcpcd-dbus
sudo apt install -y dia
sudo apt install -y dialog
sudo apt install -y dnsmasq
sudo apt install -y dnscrypt-proxy
sudo apt install -y dos2unix
sudo apt install -y dosfstools
sudo apt install -y dpkg-dev
sudo apt install -y dwm
sudo apt install -y eject
sudo apt install -y elinks
sudo apt install -y emacs
sudo apt install -y exfat-utils
sudo apt install -y fdisk
sudo apt install -y feh
sudo apt install -y ffmpegthumbnailer
sudo apt install -y firefox-esr
sudo apt install -y fonts-inconsolata
sudo apt install -y fonts-ubuntu-console
sudo apt install -y gawk
sudo apt install -y gdb
sudo apt install -y geany-plugins
sudo apt install -y geany
sudo apt install -y genisoimage
sudo apt install -y gimp
sudo apt install -y git
sudo apt install -y glade
#sudo apt install -y gnome-power-manager
sudo apt install -y golang
sudo apt install -y gparted
sudo apt install -y groff
sudo apt install -y gtk+2.0
sudo apt install -y gtk+3.0
sudo apt install -y gtk3-dev
sudo apt install -y gvfs-daemons
sudo apt install -y gvfs
sudo apt install -y gzip
sudo apt install -y highlight
sudo apt install -y hostapd
sudo apt install -y hostap-utils
sudo apt install -y htop
sudo apt install -y hunspell
sudo apt install -y iceweasel
sudo apt install -y ifplugd
sudo apt install -y ii
sudo apt install -y ifupdown
sudo apt install -y inetutils
#sudo apt install -y inxi
sudo apt install -y iproute2
sudo apt install -y iputils-ping
sudo apt install -y isc-dhcp-client
sudo apt install -y isc-dhcp-server
#sudo apt install -y iwd
sudo apt install -y jq
sudo apt install -y laptop-mode-tools
sudo apt install -y libasound2
sudo apt install -y libblockdev-crypto2
sudo apt install -y libdvd-pkg
sudo apt install -y libfm-tools
sudo apt install -y libfontconfig1-dev
sudo apt install -y libfreetype6-dev
sudo apt install -y libgcr-3-dev
sudo apt install -y libgimp2.0
sudo apt install -y libgs9
sudo apt install -y libgtk-3-dev
sudo apt install -y libheif1
sudo apt install -y libimlib2
sudo apt install -y libjson-c3
sudo apt install -y libjson-c-dev
sudo apt install -y libncurses5-dev
sudo apt install -y libncursesw5-dev
sudo apt install -y libobrender32v5
sudo apt install -y libpam0g-dev
sudo apt install -y libreoffice
sudo apt install -y libssl-dev
sudo apt install -y libunwind8
sudo apt install -y libusbmuxd-tools
sudo apt install -y libvte-dev
sudo apt install -y libx11-dev
sudo apt install -y libxext-dev
sudo apt install -y libxfont2
sudo apt install -y libxft-dev
sudo apt install -y libxinerama-dev
sudo apt install -y lshw
sudo apt install -y lsusb
sudo apt install -y lxappearance
sudo apt install -y mousepad
sudo apt install -y mplayer
sudo apt install -y mupdf
sudo apt install -y net-tools
#sudo apt install -y network-manager
#sudo apt install -y network-manager-gnome
#sudo apt install -y nm-tray
sudo apt install -y nftables
sudo apt install -y nfs-utils
sudo apt install -y ntp
sudo apt install -y nitrogen
sudo apt install -y nodejs
sudo apt install -y ntfs-3g
sudo apt install -y obconf
sudo apt install -y openbox
sudo apt install -y openssh
sudo apt install -y openssh-server
sudo apt install -y os-prober
sudo apt install -y pandoc
sudo apt install -y pavucontrol
sudo apt install -y pcmanfm
sudo apt install -y poppler-utils
sudo apt install -y powertop
sudo apt install -y ppp
sudo apt install -y pulseaudio
sudo apt install -y python2
sudo apt install -y python3-pip
sudo apt install -y python3
sudo apt install -y python-pip
sudo apt install -y qalculate
sudo apt install -y ranger
sudo apt install -y resolvconf
sudo apt install -y shellinabox
sudo apt install -y simplescreenrecorder
sudo apt install -y squashfs-tools
sudo apt install -y suckless-tools
#sudo apt install -y texlive-base
#sudo apt install -y texlive-full
#sudo apt install -y texlive-games
#sudo apt install -y texlive-humanities
#sudo apt install -y texlive-math-extra
#sudo apt install -y texlive-music
#sudo apt install -y texlive-pictures
#sudo apt install -y texlive-publishers
#sudo apt install -y texlive-science
#sudo apt install -y texlive-xetex
#sudo apt install -y texstudio
#sudo apt install -y thunar
#sudo apt install -y thunar-archive-plugin
#sudo apt install -y thunar-media-tags-plugin
#sudo apt install -y tightvncserver
sudo apt install -y tint2
sudo apt install -y tlp
sudo apt install -y tmux
sudo apt install -y top
sudo apt install -y tree
sudo apt install -y tumbler
sudo apt install -y udiskie
sudo apt install -y udisks2
sudo apt install -y udhcpc
sudo apt install -y unzip
sudo apt install -y upower
sudo apt install -y util-linux
sudo apt install -y vi
sudo apt install -y vifm
sudo apt install -y vim
sudo apt install -y vlc
sudo apt install -y vorbis-tools
sudo apt install -y w3m
sudo apt install -y wget
#sudo apt install -y wicd-curses
#sudo apt install -y wicd
sudo apt install -y wireless-tools
sudo apt install -y wireless-regdb
sudo apt install -y wpasupplicant
sudo apt install -y x11-apps
sudo apt install -y x11-xkb-utils
sudo apt install -y xarchiver
sudo apt install -y xclip
sudo apt install -y xfishtank
sudo apt install -y xfburn
sudo apt install -y xinit
sudo apt install -y xorg
sudo apt install -y xrdp
sudo apt install -y xserver-common
sudo apt install -y xserver-xorg-core
sudo apt install -y xserver-xorg-input-all
sudo apt install -y xserver-xorg-video-all
sudo apt install -y x11-xserver-utils
sudo apt install -y xfonts-base
sudo apt install -y xterm
sudo apt install -y xvkbd
sudo apt install -y zathura
sudo apt install -y zip
sudo apt install -y zlib1g-dev
