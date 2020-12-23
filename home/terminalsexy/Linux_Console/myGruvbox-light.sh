#!/bin/bash

## Guvbox light based on https://github.com/morhetz/gruvbox-contrib

function define_color {
    attrNo=$1
    hexColor=$2
    /bin/echo -e "\e]P${attrNo}${hexColor}"
}

if [ "$TERM" = "linux" ]; then
    #! hard contrast: *background: #f9f5d7
    #*background: #fbf1c7
    define_color 0 fbf1c7

    #! soft contrast: *background: #f2e5bc
    #*foreground: #3c3836
    define_color 8 3c3836

    #! Black + DarkGrey
    #*color0:  #fdf4c1
    define_color 0 fdf4c1
    #*color8:  #928374
    define_color 8 000000

    #! DarkRed + Red
    #*color1:  #cc241d
    define_color 1 cc241d
    #*color9:  #9d0006
    define_color 9 9d0006

    #! DarkGreen + Green
    #*color2:  #98971a
    define_color 2 98971a
    #*color10: #79740e
    define_color A 79740e

    #! DarkYellow + Yellow
    #*color3:  #d79921
    define_color 3 d79921
    #*color11: #b57614
    define_color B b57614

    #! DarkBlue + Blue
    #*color4:  #458588
    define_color 4 458588
    #*color12: #076678
    define_color C 076678

    #! DarkMagenta + Magenta
    #*color5:  #b16286
    define_color 5 b16286
    #*color13: #8f3f71
    define_color D 8f3f71

    #! DarkCyan + Cyan
    #*color6:  #689d6a
    define_color 6 689d6a
    #*color14: #427b58
    define_color E 427b58

    #! LightGrey + White
    #*color7:  #7c6f64
    define_color 7 7c6f64
    #*color15: #3c3836
    define_color F 3c3836

  # get rid of artifacts
  clear
fi
