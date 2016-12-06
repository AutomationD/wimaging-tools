@echo off

ping -n 5 127.0.0.1 >nul
echo Loading WinPE...
wpeinit
ping -n 15 127.0.0.1 >nul
set wimagingRoot=x:\wimaging
set deployRoot=%wimagingRoot%\deploy
set utilsRoot=%wimagingRoot%\utils
set imageRoot=%wimagingRoot%\image
set vncRoot=%wimagingRoot%\VNC

:: Init networking
echo Starting networking...
wpeutil InitializeNetwork
ping -n 15 127.0.0.1 >nul
echo Disabling Firewall...
Wpeutil disablefirewall
ping -n 15 127.0.0.1 >nul
:: Install VNC Server (Default password is "password")
cd %vncRoot%
echo Installing VNC Server...
regedit /s config32.reg
regedit /s config64.reg
tvnserver -install -silent
tvnserver -start

:: Download Setup Script
cd %deployRoot%
echo Downloading Setup Script...
powershell.exe -executionpolicy bypass -File ..\_getpeSetup.ps1

:: Run installation script
echo Run installation script...
call %deployRoot%\peSetup.cmd