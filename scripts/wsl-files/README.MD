# [![Windows_logo_-_2012.svg](https://upload.wikimedia.org/wikipedia/commons/5/5f/Windows_logo_-_2012.svg)](https://docs.microsoft.com/en-us/windows/wsl/about) Windows Subsystem for Linux Documentation 

Enable WLS via Powershell

* must enable "Developer Mode"
    * Extra: I enable Powershell script here to enable other DIY power-user ```.ps1``` scripts

```ps1
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

## optional 'Virtual Machine Platform'
## for use with WLS 2
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

## I prefer to use the Official Debian app from the Win10 Store
```

To use GNU Desktop GUI Apps:

* Download X Server on Win10 [xming](https://sourceforge.net/projects/xming/) or [XLaunch vcxsrv](https://sourceforge.net/projects/vcxsrv/)
* Get a Distro from the Windows Store. I prefer Debian on Win10... despite prefering Arch or Alpine on everything else.
* Tell Bash you want to run an app through the X Server

```sh
## Manually Launch a standalone window of the Geany text editor
## In this case X Server was set to 0.0

DISPLAY=:0.0 geany

## or
DISPLAY=:0.0 dwm

## or
## automatically launch a DE app
## within .bashrc add
export DISPLAY=:0.0
```

Access Win10 Dirs from WLS:
```sh
## CD into the Win10 Downloads Dir

cd /mnt/c/Users/<a-user-name>/Downloads
```

Access WLS from Win10:

* you have to ssh into it similar to a remote session

### terminal fonts

* [powerline fonts](https://github.com/powerline/fonts)

---

# PuTTy

Remote terminal and Remote destop ssh tunneling with a real Linux system

```bat
REM bat script example

start putty.exe -ssh mezcel@10.42.0.1 22 -pw password1234 -L 5555:localhost:3389 -X
```
