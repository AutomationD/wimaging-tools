:: reanme this file to "_config.cmd"
:: change this

set "foremanproxy="
for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "Default"') do if not defined ip set foremanproxy=%%b
:: set foremanHost=foreman.dev.puppet.comm2000.it

:: keep
set wimagingRoot=x:\wimaging
set deployRoot=%wimagingRoot%\deploy
set utilsRoot=%wimagingRoot%\utils
set imageRoot=%wimagingRoot%\image
