# g++ with notepad++

Enable c/c++ compile and build

## Install WinGW

Install [MinGW](https://osdn.net/projects/mingw/downloads/68260/mingw-get-setup.exe/)

* Add ```C:\MinGW\bin``` to system environment variables

* Control Panel > System and Security > System > Advanced system settings > Environment Variables
	* ```Control Panel\System and Security\System```
	
| System variables: | Edit |
| --- | --- |
| Path | ```C:\MinGW\bin``` |

---

## Install NppExe plugin for Npp

Within Npp

* Plugins --> Plugins Admin --> NppExec

## Configure NppExe for C/C++

* Launch NppExec

* Execute

Comands:
```sh
npp_save
cd "$(CURRENT_DIRECTORY)"
g++ "$(FILE_NAME)" -o $(NAME_PART) -march=native -O3
NPP_RUN $(NAME_PART)
```

* Name it / Save it

---

## Compile/Build

* Open a demo ```.c``` file

```c
/* hello-world.c */

#include <stdio.h>
int main() {
	// printf() displays the string inside quotation
	printf("Hello, World!");
	return 0;
}
```

* Launch NppExe
	* Plugins --> NppExe --> Execute... --> (pick your script ) --> Ok
	
* Look for your newly generataed ```.exe``` file in your program dir
* test it in CMD
```sh
C:\YOUR\WHEREVER\PATH\hello-world.exe
```