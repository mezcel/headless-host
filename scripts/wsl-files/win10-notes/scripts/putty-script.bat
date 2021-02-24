@echo off

set kangaroouser="mezcel"
set kangarooip="10.42.0.1"
set kangarooport="22"
set kangaroopw="mypassword1234"
set tunnelsourceport="5555"
set tunneldestination="localhost:3389"
REM set xdisplaylocation="localhost:0.0"
set sshtunnel="%tunnelsourceport%:%tunneldestination%"
set rdpsession="localhost"

REM PuTTY SSH Tunnel RDP
REM start putty.exe -ssh mezcel@10.42.0.1 22 -pw mypassword1234 -L 5555:127.0.0.1:3389

start putty.exe -ssh %kangaroouser%@%kangarooip% %kangarooport% -pw %kangaroopw% -L %sshtunnel% -X

REM Windows Remote Desktop Connection v10
REM start mstsc.exe /v:%rdpsession%:%tunnelsourceport% /admin /f

exit