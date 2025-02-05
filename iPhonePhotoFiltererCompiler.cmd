@echo off
setlocal
set scriptName=filter_iphone_photos
set exeName=iPhone Photo Filterer
set pathToScript=.

start PythonFileCompiler.cmd "%scriptName%" "%exeName%" "%pathToScript%"
