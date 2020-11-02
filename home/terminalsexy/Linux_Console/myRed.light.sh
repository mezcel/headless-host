#!/bin/sh
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0000000
  \e]P1ff0100
  \e]P2f98079
  \e]P3cecb00
  \e]P4ef9292
  \e]P5cb1ed1
  \e]P689a2a2
  \e]P7e5e5e5
  \e]P84d4d4d
  \e]P91d865f
  \e]PAaf583f
  \e]PBa6a556
  \e]PCe4567b
  \e]PDfd28ff
  \e]PE207373
  \e]PFffffff
  "
  # get rid of artifacts
  clear
fi
