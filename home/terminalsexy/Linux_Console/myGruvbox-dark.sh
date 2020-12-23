#!/bin/bash

## Guvbox dark based on https://github.com/morhetz/gruvbox-contrib

function define_color {
    attrNo=$1
    hexColor=$2
    /bin/echo -e "\e]P${attrNo}${hexColor}"
}

if [ "$TERM" = "linux" ]; then

    #! hard contrast: *background: #1d2021
    #*background: #282828
    define_color 0 282828

    #! soft contrast: *background: #32302f
    #*foreground: #ebdbb2
    define_color 8 ebdbb2

    #! Black + DarkGrey
    #*color0:  #282828
    define_color 0 282828
    #*color8:  #928374
    define_color 8 928374

    #! DarkRed + Red
    #*color1:  #cc241d
    define_color 1 cc241d
    #*color9:  #fb4934
    define_color 9 fb4934

    #! DarkGreen + Green
    #*color2:  #98971a
    define_color 2 98971a
    #*color10: #b8bb26
    define_color A b8bb26

    #! DarkYellow + Yellow
    #*color3:  #d79921
    define_color 3 d79921
    #*color11: #fabd2f
    define_color B fabd2f

    #! DarkBlue + Blue
    #*color4:  #458588
    define_color 4 458588
    #*color12: #83a598
    define_color C 83a598

    #! DarkMagenta + Magenta
    #*color5:  #b16286
    define_color 5 b16286
    #*color13: #d3869b
    define_color D d3869b

    #! DarkCyan + Cyan
    #*color6:  #689d6a
    define_color 6 689d6a
    #*color14: #8ec07c
    define_color E 8ec07c

    #! LightGrey + White
    #*color7:  #a89984
    define_color 7 a89984
    #*color15: #ebdbb2
    define_color F ebdbb2

  # get rid of artifacts
  clear
fi
