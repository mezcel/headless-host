# headless-host

<a href="https://www.debian.org" target="_blank"><img src="https://www.debian.org/logos/openlogo-100.png" height="80"></a>

## About

Installer scripts and configuration notes for a ```Debian +10.5``` host server.

### Content Features

This project package will install and configure the following:

* Tui, Gui, Wifi, & Sshd server
  * Pre-patched DWM, Dmenu, & St
  * Off-line copy of [NERDTree](https://github.com/preservim/nerdtree) for Vim
  * Off-line copy of [lightline](https://github.com/itchyny/lightline.vim) for Vim
  * Off-line copy of [ohmybash](https://ohmybash.nntoan.com/) for Bash
* Reminder notes, guides, and configuration templates
  * Hardware driver links
  * Alternative network management

## Install

* Run ```bash install.sh```, to  install.
* The way I use this repo:
  1. Burn a [debian-live-10.x.x-amd64-standard.iso](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-10.6.0-amd64-standard.iso) onto a usb.
  2. Clone this repo onto the same usb ( *just for convenience* )
  3. After Debian is installed on the computer, copy [headless-host.git](https://github.com/mezcel/headless-host.git) onto that machine.
      * (Optional/Recommendation) The first time you run this script, do so within the "root" account because it will populate ```skel``` and ```wpa_supplicant``` files for other users.
      * After new user accounts are created you have the option to run this again to configure the environment for that individual account.
  4. Run the ```bash install.sh``` and follow the prompts.
      * Each time the script is ran, menu prompts will change depending on what software, files, or hardware is present.
  5. When the installation is finished, the alias ```hh``` will be appended to ```~/.bashrc```.
      * Typing ```hh``` in the ```bash``` terminal will launch a script which serves as an easy access quick launcher for common terminal tasks.
      * ```hh``` use case example:
        ```sh
        ## Type "hh" to view a list of predefined "hh" options.
        ## Example: Use wpa_supplicant to activate a wireless network interface
        ##  and connect to a known ssid access point.

        hh up               ## or "hh u"

        ## a few other alias usecase examples:
        # hh ping           ## or "hh p"
        # hh umount         ## or "hh u"
        # hh alsamixer      ## or "hh a"
        ```
    6. The full/max intallation with take well over +15 minutes.
       * The minimal installation will take < 15 minutes.
* Alternately, one could just individually run one of the source scripts contained within ```./sources/``` and the ```my_iwconfig``` file.

## Bashrc alias

There is an option to install a ```bash``` alias: "hh"

Typing ```hh``` in the ```bash``` terminal will launch a script which serves as an easy access quick launcher for common terminal tasks.

---

## Official Links

| Debian/ISO | Github | Drivers |
|---|---|---|
| <ul><li>[debian.org](https://www.debian.org)</li><li>[Debian News](https://www.debian.org/News/)</li><li>[iso-hybrid](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)</li><li>[iso-dvd](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/)</li></ul> | <ul><li>[NERDTree](https://github.com/preservim/nerdtree)</li><li>[lightline](https://github.com/itchyny/lightline.vim)</li><li>[ohmybash](https://ohmybash.nntoan.com/)</li><li>[powerline](https://github.com/powerline/powerline)</li><li>[vifm](https://github.com/vifm)</li><li>[geany-themes](https://github.com/geany/geany-themes)</li></ul> | <ul><li>[firmware-iwlwifi ]( http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-iwlwifi_20190114-2_all.deb )</li><li>[initramfs-tools](http://ftp.us.debian.org/debian/pool/main/i/initramfs-tools/initramfs-tools_0.133+deb10u1_all.deb)</li><li>broadcom-sta-dkms (6.30.223.271-10~bpo9+1) [ stretch backport ]( http://ftp.us.debian.org/debian/pool/non-free/b/broadcom-sta/broadcom-sta-dkms_6.30.223.271-10~bpo9+1_all.deb )</li><li>broadcom-sta-dkms_6.30.223.271-10_all.deb [ buster ](http://ftp.us.debian.org/debian/pool/non-free/b/broadcom-sta/broadcom-sta-dkms_6.30.223.271-10_all.deb)</li></ul>|

---

## Primary Deb Packages Installed Through This Script

| [TTY](sources/1.0-Install-Tty-Environment.bash) | [Desktop](sources/2.0-Install-Desktop-Environment.bash) | [Connectivity](sources/3.0-Install-Networking.bash) | [Adhoc Wifi](sources/3.1-Install-Wifi-Adhoc.bash) |
|---|---|---|---|
|<ul><li>linux-image-$(uname -r)</li><li>linux-headers-$(uname -r)</li><li>firmware-linux-free</li><li>firmware-linux-nonfree</li><li>firmware-iwlwifi</li><li>firmware-brcm80211</li><li>broadcom-sta-dkms</li><li>resolvconf</li><li>build-essential</li><li>debianutils</li><li>util-linux</li><li>bash</li><li>bash-completion</li><li>vim</li><li>tmux</li><li>ranger</li><li>vifm</li><li>htop</li><li>aspell</li><li>wget</li><li>curl</li><li>elinks</li><li>bc</li><li>dos2unix</li><li>unzip</li><li>dialog</li><li>highlight</li><li>udiskie</li><li>fonts-ubuntu-family-console</li><li>ttf-ubuntu-font-family</li><li>fonts-inconsolata</li><li>pandoc</li><li>tlp</li><li>git</li><li>alsa-utils</li><li>pavucontrol</li><li>vorbis-tools</li><li>mplayer</li></ul>|<ul><li>build-essential</li><li>git</li><li>xorg</li><li>xinit</li><li>arandr</li><li>libx11-dev</li><li>libxft-dev</li><li>libxinerama-dev</li><li>xclip</li><li>xvkbd</li><li>libgcr-3-dev</li><li>suckless-tools</li><li>openbox</li><li>conky</li><li>libvte-dev</li><li>geany</li><li>geany-plugins</li><li>mousepad</li><li>zathura</li><li>pcmanfm</li><li>libfm-tools</li><li>libusbmuxd-tools</li><li>udiskie</li><li>xarchiver</li><li>gvfs</li><li>tumbler</li><li>ffmpegthumbnailer</li><li>xterm</li><li>openbox</li><li>tint2</li><li>feh</li><li>gparted</li><li>iceweasel</li><li>firefox-esr</li><li>gimp</li><li>alsa-utils</li><li>pavucontrol</li><li>vlc</li><li>libdvd-pkg</li></ul>|<ul><li>linux-image-$(uname -r)</li><li>linux-headers-$(uname -r)</li><li>firmware-linux-free</li><li>firmware-linux-nonfree</li><li>firmware-iwlwifi</li><li>firmware-brcm80211</li><li>broadcom-sta-dkms</li><li>resolvconf</li><li>build-essential</li><li>util-linux</li><li>elinks</li><li>w3m</li><li>git</li><li>curl</li><li>iputils-ping</li></ul>|<ul><li>linux-image-$(uname -r)</li><li>linux-headers-$(uname -r)</li><li>firmware-linux-free</li><li>firmware-linux-nonfree</li><li>firmware-iwlwifi</li><li>firmware-brcm80211</li><li>broadcom-sta-dkms</li><li>resolvconf</li><li>dnsmasq</li><li>iptables</li><li>hostapd</li><li>ifplugd</li><li>openssh-server</li></ul>|

---

## Extras

Theme packs not directly included in this project:

* [adeverteuil/console-solarized.git](https://github.com/adeverteuil/console-solarized.git)
* [morhetz/gruvbox-contrib.git](https://github.com/morhetz/gruvbox-contrib.git)
* [arcticicestudio/nord.git](https://github.com/arcticicestudio/nord)
* [solarized](https://ethanschoonover.com/solarized)
