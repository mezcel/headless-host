# Cygwin files

homepage [https://www.cygwin.com/](https://www.cygwin.com/)

Cygwin is a large collection of GNU and Open Source tools which provide functionality similar to a Linux distribution on Windows.

Application [installer]( https://www.cygwin.com/setup-x86_64.exe )

## apt-cyg package manager

apt-cyg is a Cygwin package manager. It includes a command-line installer for Cygwin which cooperates with Cygwin Setup and uses the same repository.

Github: [transcode-open/apt-cyg]( https://github.com/transcode-open/apt-cyg )

Install apt-cyg
```sh
lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
install apt-cyg /bin
```

usage example
```sh
bash apt-cyg install tmux
```

## Install my terminal environment

My script depends on having ```wget``` installed
```sh
bash install-cyg-packages.sh
```