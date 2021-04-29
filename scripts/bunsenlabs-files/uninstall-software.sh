#!/bin/bash

## Nano
sudo apt remove -y nano
sudo apt-get autoremove
sudo apt-get autoclean

## LibreOffice
sudo apt-get remove -y --purge libreoffice*
sudo apt-get clean
sudo apt-get autoremove

## synaptic
sudo apt-get remove synaptic*
sudo apt-get purge synaptic*
sudo apt-get autoremove
sudo apt-get autoclean