@setlocal enableextensions enabledelayedexpansion
@echo off
for /L %%i in (1, 1, 255) Do (
	for /L %%j in (1, 1, 255) Do (
		set /A k=0
		set ip=192.168.%%i.%%j
		for /f "tokens=3" %%a in ('ping -n 1 !ip!') do (
			If !k!==1 (
				If !ip!:==%%a echo !ip!
			)
			set /A "k+=1"
		)
	)
)
pause
exit