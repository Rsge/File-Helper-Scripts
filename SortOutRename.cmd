@echo off
pushd %~d0 && (
	for /d %%i in  (*) do (
		pushd %%i
		mkdir "!"
		move "!*" "!"
		pushd !
			ren "!*.*" "//*.*"
			popd
		popd
	)
	popd
)
pause
exit /b
