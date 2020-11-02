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
      * Start with the "root" account because it will populate ```skel``` and ```wpa_supplicant``` files for other users.
  4. Run ```bash install.sh``` and follow the prompts.
     * **Note**: If "broadcom" is installed, the computer will restart, and you will need to re-run the installer again to complete the installation.
      * Menu prompts will change depending on what software, files, or hardware is present.
  5. When the installation is finished, the alias ```hh``` will be appended to ```~/.bashrc```.
      * ```hh``` is just an alias to launch a helper script.
      * ```hh``` use case example:
        ```sh
        ## activate a wireless network interface & connect to a known ssid access point.
        hh up
        ```
    6. The full/max intallation with take well over +15 minutes.
       * The minimal installation will take < 15 minutes.
* Alternately, one could just individually run one of the source scripts contained within ```./sources/``` and the ```my_iwconfig``` file.

---

## Official Debian Links

* [debian.org](https://www.debian.org)
* [Debian News](https://www.debian.org/News/)
* [iso-hybrid](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)
* [iso-dvd](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/)

---

## Unrelated Plugins

Not included in this project:

* [adeverteuil/console-solarized.git](https://github.com/adeverteuil/console-solarized.git)
