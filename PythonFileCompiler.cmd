@echo off
setlocal
set scriptName=%~1
set exeName=%~2
set exeFile=%exeName%.exe
set pathToScript=%~3

echo Compiling exe file. . .
echo.
pyinstaller.exe --onefile "%pathToScript%\%scriptName%.py"
echo.
robocopy dist . * /MOV
if exist "%exeFile%" del "%exeFile%"
ren "%scriptName%.exe" "%exeFile%"
echo Compilation finished.
echo.
echo Deleting build files. . .
del /q %scriptName%.spec
rd /s /q build
rd /q dist
echo Cleanup finished.
echo.
echo Exe file can now be used.
pause
exit
