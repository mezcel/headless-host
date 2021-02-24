#!/bin/bash

inputFile=$1
if [ -z $inputFile ]; then
	echo -e "\nError:\n\t!!! No input file detected !!!\n"
	exit
else
	if [ ! -f $inputFile ] && [ ! -d $inputFile ]; then
		echo -e "\nError:\n\t!!! Not a valid input. Check spelling or file path. !!!\n"
		exit
	fi
fi

win10Path=/mnt/c/Users
if [ -d $win10Path ]; then
	win10Path=$win10Path/$(whoami)
	if [ -d $win10Path ]; then
		win10Path=$win10Path/Downloads/
		if [ -d $win10Path ]; then
			sudo cp -rf $inputFile $win10Path
			echo -e "\nSuccess:\n\tInput: \"$1\", was moved to: \"$win10Path\".\n"
			exit
		fi
	fi
fi

echo -e "\nError:\n\tWLS did not detect the following file path: \"$win10Path\"\n"
