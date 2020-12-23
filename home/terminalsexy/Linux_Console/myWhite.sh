#!/bin/bash

## White Terminal Basic based on https://github.com/mbadolato/iTerm2-Color-Schemes

function define_color {
    attrNo=$1
    hexColor=$2
    /bin/echo -e "\e]P${attrNo}${hexColor}"
}

if [ "$TERM" = "linux" ]; then

    #*background: #ffffff
    define_color 0 ffffff

    #*foreground: #000000
    define_color 8 000000

    #! Black + DarkGrey
    #*color0:  #ffffff
    define_color 0 ffffff
    #*color8:  #000000
    define_color 8 000000

    #! DarkRed + Red
    #*color1:  #990000
    define_color 1 990000
    #*color9:  #e50000
    define_color 9 e50000

    #! DarkGreen + Green
    #*color2:  #00a600
    define_color 2 00a600
    #*color10: #00d900
    define_color A 00d900

    #! DarkYellow + Yellow
    #*color3:  #999900
    define_color 3 999900
    #*color11: #e5e500
    define_color B e69500

    #! DarkBlue + Blue
    #*color4:  #0000b2
    define_color 4 0000b2
    #*color12: #0000ff
    define_color C 0000ff

    #! DarkMagenta + Magenta
    #*color5:  #b200b2
    define_color 5 b200b2
    #*color13: #e500e5
    define_color D e500e5

    #! DarkCyan + Cyan
    #*color6:  #00a6b2
    define_color 6 00a6b2
    #*color14: #00e5e5
    define_color E 0080ff

    #! LightGrey + White
    #*color7:  #000000
    define_color 7 000000
    #*color15: #808080
    define_color F 808080

  # get rid of artifacts
  clear
fi
