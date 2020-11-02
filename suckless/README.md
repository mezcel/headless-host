# suckless

## Suckless Patches

| Suckless App | Patch |
| :---: | :---: |
| dwm | gridmode, rotatestack |
| st | st-dracula, st-nordtheme, st-solarized-both |
| dmenu | `patched from within dwm` |

## Tribute Wallpapers

* Hosted on [deviantart.com/mezcel](https://www.deviantart.com/mezcel), are minimalist tribute desktop wallpapers.

## Patch by hand

* Copy custom a config_color.h into config.h
    * Example:
    ```sh
    ## Nord DWM scheme

    cd ~/suckless/dwm/
    sudo cp config_nord.h config.h
    sudo make clean install
    ```
