#!/bin/bash

function RemovePurge {
	packageName=$1

	sudo apt -y remove $packageName
	sudo apt -y purge $packageName
	sudo apt -y clean
	sudo apt -y autoremove
	sudo apt -y autoclean
}

function RemoveSoftware {
	RemovePurge 'nano'
	RemovePurge 'libreoffice*'
	RemovePurge 'synaptic*'
	RemovePurge 'ligtdm'
	RemovePurge 'xfburn'
	RemovePurge 'compton'
	RemovePurge 'filezilla'
	RemovePurge 'hexchat'
	RemovePurge 'gimp'
}

RemoveSoftware
