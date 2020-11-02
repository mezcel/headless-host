# Broadcom Network Drivers

The official firmware is from here: [broadcom.com](https://www.broadcom.com/support/download-search/?pf=Wireless+LAN+Infrastructure)

* broadcom-sta-dkms (6.30.223.271-10~bpo9+1) [ stretch backport ]( http://ftp.us.debian.org/debian/pool/non-free/b/broadcom-sta/broadcom-sta-dkms_6.30.223.271-10~bpo9+1_all.deb )
* broadcom-sta-dkms_6.30.223.271-10_all.deb [ buster ](http://ftp.us.debian.org/debian/pool/non-free/b/broadcom-sta/broadcom-sta-dkms_6.30.223.271-10_all.deb)


```sh
## update /etc/apt/sources.list to include (main contrib non-free)

## list my wifi driver hardware
lspci -nn | grep Network

sudo apt-get install wireless-tools
sudo apt-get install wicd-curses
sudo apt-get install wpasupplicant

sudo apt-get install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,')
sudo apt-get install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')
sudo apt-get install broadcom-sta-dkms

## remove conflicts
sudo modprobe -r b44 b43 b43legacy ssb brcmsmac bcma

## apply the driver
sudo modprobe wl
```

---

## wiki links

[broadcom_wireless#Installation](https://wiki.archlinux.org/index.php/broadcom_wireless#Installation)

[brcm80211](https://wireless.wiki.kernel.org/en/users/Drivers/brcm80211#supported_chips)

[b43](https://wireless.wiki.kernel.org/en/users/drivers/b43)

[broadcom.com](https://www.broadcom.com/support/download-search/?pf=Wireless+LAN+Infrastructure)

[Wireless network configuration](https://wiki.archlinux.org/index.php/Wireless_network_configuration#Installing_driver/firmware)

```sh
# official package refferences

sudo pacman -S --needed b43
sudo pacman -S --needed brsm80211
sudo pacman -S --needed broadcom-wl
sudo pacman -S --needed broadcom-wl-dkms
```
