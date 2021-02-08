#!/bin/bash

## assumes that there is a directory full of *.deb files named "downloaded-debs"

mkdir -p /etc/apt/sources.list.d/

echo "deb [trusted=yes] file:///usr/lib/live/mount/medium downloaded-debs/" >> /etc/apt/sources.list.d/myRepoMirror.list

## Make list of installed applications
# mkdir ~/Downloads
# dpkg -l | grep ^ii | awk '{print $2}' | cut -d: -f1 > ~/Downloads/live-downloads.txt

## prepend "sudo apt install" on every line
#echo '#!/bin/bash' > ~/Downloads/live-installs.txt
#echo "" >> ~/Downloads/live-installs.txt
#sed 's/^/sudo apt install /g' ~/Downloads/live-downloads.txt >> ~/Downloads/live-installs.txt