@echo off
pushd %~d0
for /D %%i in  (*) do (
	pushd %%i
	mkdir "!"
	move "!*" "!"
	pushd !
		ren "!*.*" "//*.*"
		popd
	popd
)
popd
pause
exit