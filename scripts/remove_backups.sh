#!/bin/bash

## Remove all the stray backup files and directories created by the headless host installation.

sudo rm -rf ~/.vim.backup*
sudo rm -rf ~/terminalsexy.backup*
sudo rm -rf ~/suckless.backup*

sudo rm ~/.vimrc.backup*
sudo rm ~/.tmux.conf.backup*
sudo rm ~/.bashrc.backup*
sudo rm ~/.toprc.backup*
sudo rm ~/xinitrc.backup*

sudo rm /etc/issue.backup*
sudo rm /etc/motd.backup*
sudo rm /etc/network/interface.backup*
sudo rm /etc/apt/sources.list.backup*
