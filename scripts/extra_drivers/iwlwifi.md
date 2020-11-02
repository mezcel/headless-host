# Intel Wireless WiFi Link, Wireless-N, Advanced-N, Ultimate-N devices

* [firmware-iwlwifi ]( http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-iwlwifi_20190114-2_all.deb )
* [initramfs-tools](http://ftp.us.debian.org/debian/pool/main/i/initramfs-tools/initramfs-tools_0.133+deb10u1_all.deb)

## Installation

Add a "non-free" component to the apt sources.

Update the list of available packages and install the firmware-iwlwifi package:

```bash
sudo apt update && apt install firmware-iwlwifi
```

As the iwlwifi module is automatically loaded for supported devices, reinsert this module to access installed firmware:

```bash
sudo modprobe -r iwlwifi ; modprobe iwlwifi
```