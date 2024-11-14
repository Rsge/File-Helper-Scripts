@echo off
setlocal
set scriptName=filter_iphone_photos
set exeName=iPhone Photo Filterer
set path=.

start PythonFileCompiler.cmd "%scriptName%" "%exeName%" "%path%"
