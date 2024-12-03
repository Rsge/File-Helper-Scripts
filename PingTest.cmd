@setlocal enableextensions enabledelayedexpansion
@echo off
for /l %%i in (1, 1, 255) do (
	for /l %%j in (1, 1, 255) do (
		set /a k=0
		set ip=192.168.%%i.%%j
		for /f "tokens=3" %%a in ('ping -n 1 !ip!') do (
			if !k!==1 (
				if !ip!:==%%a (
					echo !ip!
				)
			)
			set /a "k+=1"
		)
	)
)
pause
exit /b
