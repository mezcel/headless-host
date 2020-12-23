#!/bin/sh
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0001100
  \e]P1007700
  \e]P200bb00
  \e]P3007700
  \e]P4009900
  \e]P500bb00
  \e]P6005500
  \e]P700bb00
  \e]P8007700
  \e]P9007700
  \e]PA00bb00
  \e]PB007700
  \e]PC009900
  \e]PD00bb00
  \e]PE005500
  \e]PF00ff00
  "
  # get rid of artifacts
  clear
fi
