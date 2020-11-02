#!/bin/bash

## toggle the Tint2 pannel

isTint2=$(pgrep tint2)

if [ -x $isTint2 ]; then
	tint2 &
elif [ $isTint2 -ne 0 ]; then
	killall tint2
fi
