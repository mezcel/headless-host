#!/bin/bash

## Guvbox dark based on https://ethanschoonover.com/solarized

function define_color {
    attrNo=$1
    hexColor=$2
    /bin/echo -e "\e]P${attrNo}${hexColor}"
}

if [ "$TERM" = "linux" ]; then

    #*background: #073642
    define_color 0 073642

    #*foreground: #002b36
    define_color 8 002b36

    #! Black + DarkGrey
    #*color0:  #073642
    define_color 0 073642
    #*color8:  #002b36
    define_color 8 002b36

    #! DarkRed + Red
    #*color1:  #dc322f
    define_color 1 dc322f
    #*color9:  #cb4b16
    define_color 9 cb4b16

    #! DarkGreen + Green
    #*color2:  #859900
    define_color 2 859900
    #*color10: #586e75
    define_color A 586e75

    #! DarkYellow + Yellow
    #*color3:  #b58900
    define_color 3 b58900
    #*color11: #657b83
    define_color B 657b83

    #! DarkBlue + Blue
    #*color4:  #268bd2
    define_color 4 268bd2
    #*color12: #839496
    define_color C 839496

    #! DarkMagenta + Magenta
    #*color5:  #d33682
    define_color 5 d33682
    #*color13: #6c71c4
    define_color D 6c71c4

    #! DarkCyan + Cyan
    #*color6:  #2aa198
    define_color 6 2aa198
    #*color14: #93a1a1
    define_color E 93a1a1

    #! LightGrey + White
    #*color7:  #eee8d5
    define_color 7 eee8d5
    #*color15: #fdf6e3
    define_color F fdf6e3

  # get rid of artifacts
  clear
fi
