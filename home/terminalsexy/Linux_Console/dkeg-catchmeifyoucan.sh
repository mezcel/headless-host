#!/bin/sh
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0130f0c
  \e]P1604c38
  \e]P28d7f85
  \e]P3907256
  \e]P4aa8d70
  \e]P5b9a38d
  \e]P6c4bfbf
  \e]P7c4ae99
  \e]P8c69f77
  \e]P9cab9a8
  \e]PAd5c6b8
  \e]PBdcd1c7
  \e]PCe0e0e2
  \e]PDe4dad2
  \e]PEeae3dc
  \e]PFf6f2f0
  "
  # get rid of artifacts
  clear
fi
