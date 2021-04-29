#!/bin/bash

## Nano
sudo apt remove -y nano
sudo apt -y autoremove
sudo apt -y autoclean

## LibreOffice
sudo apt-get remove -y --purge libreoffice*
sudo apt-get -y clean
sudo apt-get -y autoremove

## synaptic
sudo apt-get -y remove synaptic*
sudo apt-get -y purge synaptic*
sudo apt-get -y autoremove
sudo apt-get -y autoclean