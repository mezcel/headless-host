#!/bin/sh
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0090300
  \e]P1db2d20
  \e]P201a252
  \e]P3fded02
  \e]P401a0e4
  \e]P5a16a94
  \e]P6b5e4f4
  \e]P7a5a2a2
  \e]P85c5855
  \e]P9db2d20
  \e]PA01a252
  \e]PBfded02
  \e]PC01a0e4
  \e]PDa16a94
  \e]PEb5e4f4
  \e]PFf7f7f7
  "
  # get rid of artifacts
  clear
fi
