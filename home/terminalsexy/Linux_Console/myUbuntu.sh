#!/bin/bash

## Ubuntu based on https://github.com/mbadolato/iTerm2-Color-Schemes

function define_color {
    attrNo=$1
    hexColor=$2
    /bin/echo -e "\e]P${attrNo}${hexColor}"
}

if [ "$TERM" = "linux" ]; then

    #*background: #300a24
    define_color 0 300a24

    #*foreground: #eeeeec
    define_color 8 eeeeec

    #! Black + DarkGrey
    #*color0:  #300a24
    define_color 0 300a24
    #*color8:  #eeeeec
    define_color 8 eeeeec

    #! DarkRed + Red
    #*color1:  #cc0000
    define_color 1 cc0000
    #*color9:  #ef2929
    define_color 9 ef2929

    #! DarkGreen + Green
    #*color2:  #4e9a06
    define_color 2 4e9a06
    #*color10: #8ae234
    define_color A 8ae234

    #! DarkYellow + Yellow
    #*color3:  #c4a000
    define_color 3 c4a000
    #*color11: #fce94f
    define_color B fce94f

    #! DarkBlue + Blue
    #*color4:  #3465a4
    define_color 4 3465a4
    #*color12: #729fcf
    define_color C 729fcf

    #! DarkMagenta + Magenta
    #*color5:  #75507b
    define_color 5 75507b
    #*color13: #ad7fa8
    define_color D ad7fa8

    #! DarkCyan + Cyan
    #*color6:  #06989a
    define_color 6 06989a
    #*color14: #34e2e2
    define_color E 34e2e2

    #! LightGrey + White
    #*color7:  #d3d7cf
    define_color 7 d3d7cf
    #*color15: #eeeeec
    define_color F eeeeec

  # get rid of artifacts
  clear
fi
