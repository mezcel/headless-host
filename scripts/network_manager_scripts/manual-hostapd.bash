#!/bin/bash

# Setup the interface
sudo ip link set wlan0 down
sudo ip addr flush dev wlan0
sudo ip link set wlan0 up
sudo ip addr add 10.0.0.1/24 dev wlan0

# start hostapd
sudo sudo killall dnsmasq; dnsmasq
sudo sudo hostapd