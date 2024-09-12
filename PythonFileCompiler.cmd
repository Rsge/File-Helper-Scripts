@echo off
set s=%~1
set en=%~2
set e=%en%.exe
set p=%~3

echo Compiling exe file. . .
echo.
pyinstaller.exe --onefile "%p%\%s%.py"
echo.
robocopy dist . * /MOV
if exist %e% del %e%
ren "%s%.exe" "%e%"
echo Compilation finished.
echo.
echo Deleting build files. . .
del /q %s%.spec
rd /s /q build
rd /q dist
echo Cleanup finished.
echo.
echo Exe file can now be used.
pause
exit