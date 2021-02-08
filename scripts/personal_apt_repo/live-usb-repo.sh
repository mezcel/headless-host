#!/bin/bash

## assumes that there is a directory full of *.deb files named "downloaded-debs"

mkdir -p /etc/apt/sources.list.d/

echo "deb [trusted=yes] file:///usr/lib/live/mount/medium downloaded-debs/" >> /etc/apt/sources.list.d/myRepoMirror.list