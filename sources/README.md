# source script

## 1.0 About

* Scripts used by the primary installer.

### 1.1 Primary install and setup scripts

* setup an offline repo
* setup a Tui environment
* setup a desktop environment
* setup telecommunications network
	* Wifi Note: Win10 will only connect to WPA2 not WPA 

---

## 2.0 Networking

* networking guidance: [debian.org/doc/manuals/debian-reference/ch05](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html)

### 2.1 Hostapd with Dnsmasq Wifi (Primary Method)

* Configs for my headless pocket computer.
* It is also likely to work for, or be similar to a "Raspbian Pi" configuration. IDK. *I have not tested it on a Pi.*

```sh
## Debian Dependencies:

sudo apt install -y firmware-linux-free
sudo apt install -y firmware-linux-nonfree
sudo apt install -y firmware-iwlwifi
sudo apt install -y resolvconf
sudo apt install -y dnsmasq 
sudo apt install -y iptables 
sudo apt install -y hostapd
sudo apt install -y ifplugd
sudo apt install -y openssh-server
```

##### 2.1.1 /etc/network/interfaces

```conf
## /etc/network/interfaces

auto lo 
iface lo inet loopback

auto $myeth
#allow-hotplug $myeth
iface $myeth inet dhcp
#iface $myeth inet static
#	address 192.168.1.100
#	broadcast 192.168.1.255
#	netmask 255.255.255.0
#	gateway 192.168.1.1
#	dns-nameservers 192.168.1.2

auto $mywlan
iface $mywlan inet static
	address 10.42.0.1
	netmask 255.255.255.0
	wireless-channel 1
	wireless-mod ad-hoc
```

##### 2.1.2 /etc/hostapd/hostapd.conf

```conf
## /etc/hostapd/hostapd.conf

interface=$mywlan
driver=nl80211
ssid=$myssid
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$mypassword
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```

##### 2.1.3 /etc/default/hostapd

```conf
## /etc/default/hostapd

DAEMON_CONF="/etc/hostapd/hostapd.conf"
```

##### 2.1.4 /etc/dnsmasq.conf

```conf
## /etc/dnsmasq.conf

interface=$mywlan
dhcp-range=10.42.0.0,10.42.0.8,12h
```

##### 2.1.5 /etc/default/grub

```conf
## /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0"
```

---

### 2.2 Basic NetworkManager (Alternate Method)

> A lot of debian based distros come with "NetworkManager". It works for a lot of use cases, but my use case is not \
satisfied through it's default configurations. But it does work.

* There are a bunch of *other ways* to do this. 
	* Some are depreciated, some are **OS specific**, many are a mix and match of tools and mappings.
	* There are an assortment of **hardware considerations** to discern.
	* nmcli's ```802-11-wireless-security.proto rsn``` is suposed to make WPA2... but idk.
* This is the easiest and most generic way available on most linux based distros.

* I went with NetworkManager only because of the ```nmcli```.
	* I don't need to micro manage all the config script.

##### 2.2.1 Nmcli configurations

```bash
#!/bin/bash

## #############################################################################
## Revert to using oldscool network interface names

sudo sed '/quiet/c\GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0"' /etc/default/grub > ~/grub.tmp
sudo mv ~/grub.tmp /etc/default/grub
sudo update-grub

## #############################################################################
## Install networking packages

sudo apt install network-manager openssh-server

## #############################################################################
## My defined ethernet

sudo nmcli connection add type ethernet autoconnect yes ifname eth0 con-name "$(hostname)-ethernet"
sudo nmcli connection modify "$(hostname)-ethernet" ipv4.method shared
sudo nmcli connection modify "$(hostname)-ethernet" ipv4.addresses 192.168.1.100/8
sudo nmcli connection modify "$(hostname)-ethernet" ipv4.gateway 192.168.1.100

## #############################################################################
## [ifupdown]
## managed=true

sudo sed '/managed=false/c\managed=true' /etc/NetworkManager/NetworkManager.conf > ~/NetworkManager_conf.tmp

sudo mv ~/NetworkManager_conf.tmp /etc/NetworkManager/NetworkManager.conf

## #############################################################################
## Sshd needs to wait for interfaces before connection
## sudo systemctl edit sshd

echo '[Unit]' > ~/wait_conf.tmp
echo 'Wants=network-online.target' >> ~/wait_conf.tmp
echo 'After=network-online.target' >> ~/wait_conf.tmp

sudo mkdir -p /etc/systemd/system/ssh.service.d/
sudo mv ~/wait_conf.tmp /etc/systemd/system/ssh.service.d/wait.conf

## #############################################################################
## Sshd server configuration

## edit Port and ListenAddress
## Port 22
## ListenAddress 192.168.0.100

## #############################################################################
## Disable wireless

echo "
##
## Consider just removing all things wireless all together
## Remove Bluetooth and remove wifi
## 
# sudo update-rc.d bluetooth remove
# wlan0=$(ls /sys/class/net | grep -E "wl")
# sudo ip set link $wlan0 down
# sudo nmcli radio all off
"
```