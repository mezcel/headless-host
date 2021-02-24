## Windows Terminal

config file: 
```
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\preofiles.json
```

If you want to use custom images, grag files intro the config directory and use ```ms-appdata``` as its root path

Ex:

```
"backgroundImage" : "ms-appdata:///roaming/yourimage.jpg",
"backgroundImageOpacity" : 0.75,
"backgroundImageStrechMode" : "fill",
```
