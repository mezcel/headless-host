#!/bin/bash

## Guvbox dark based on https://github.com/arcticicestudio/nord

function define_color {
    attrNo=$1
    hexColor=$2
    /bin/echo -e "\e]P${attrNo}${hexColor}"
}

if [ "$TERM" = "linux" ]; then

    #*background: #2e3440
    define_color 0 2e3440

    #*foreground: #88c0d0
    define_color 8 88c0d0

    #! Black + DarkGrey
    #*color0:  #2e3440
    define_color 0 2e3440
    #*color8:  #88c0d0
    define_color 8 88c0d0

    #! DarkRed + Red
    #*color1:  #3b4252
    define_color 1 3b4252
    #*color9:  #81a1c1
    define_color 9 81a1c1

    #! DarkGreen + Green
    #*color2:  #434c5e
    define_color 2 434c5e
    #*color10: #5e81ac
    define_color A 5e81ac

    #! DarkYellow + Yellow
    #*color3:  #4c566a
    define_color 3 4c566a
    #*color11: #bf616a
    define_color B bf616a

    #! DarkBlue + Blue
    #*color4:  #d8dee9
    define_color 4 d8dee9
    #*color12: #d08770
    define_color C d08770

    #! DarkMagenta + Magenta
    #*color5:  #e5e9f0
    define_color 5 e5e9f0
    #*color13: #ebcb8b
    define_color D ebcb8b

    #! DarkCyan + Cyan
    #*color6:  #eceff4
    define_color 6 eceff4
    #*color14: #a3be8c
    define_color E a3be8c

    #! LightGrey + White
    #*color7:  #8fbcbb
    define_color 7 8fbcbb
    #*color15: #b48ead
    define_color F b48ead

  # get rid of artifacts
  clear
fi
