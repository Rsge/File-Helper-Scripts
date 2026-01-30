@echo off
setlocal enabledelayedexpansion

rem Base constants
set usersPath=C:\Users
set oneDriveSubpath=OneDrive*
set desktopDir=Desktop
for /f "tokens=2*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mozilla Firefox" /v InstallLocation') do (
	set firefoxPath=%%j
)
set firefoxExe=firefox.exe

rem If Firefox is not installed, close the script.
if not defined firefoxPath (
	exit /b
)

rem Loop through all folders in Users.
for /f "tokens=*" %%p in ('dir /a:d-s /b "%usersPath%\*"') do (
	set userDesktopPath=%usersPath%\%%p\%desktopDir%
	rem Go into the user's desktop folder.
	pushd "!userDesktopPath!" && (
		rem Check if Firefox exe exists on Desktop.
		if exist "%firefoxExe%" (
			echo Found desktop Firefox exe: !userDesktopPath!\%firefoxExe%
			echo Deleting...
			del /q "%firefoxExe%"
		)
		popd
	)
	rem Search OneDrive folders.
	for /d %%d in ("!userPath!\%oneDriveSubpath%") do (
		set oneDriveDesktopPath=%%d\%desktopDir%
		if exist !oneDriveDesktopPath! (
			pushd "!oneDriveDesktopPath!" && (
				rem Check if Firefox exe exists on OneDrive Desktop.
				if exist "%firefoxExe%" (
					echo Found desktop Firefox exe: !oneDriveDesktopPath!\%firefoxExe%
					echo Deleting...
					del /q %firefoxExe%
				)
				popd
			)
		)
	)
)
rem Make Firefox link on public desktop.
pushd "%usersPath%\Public\Desktop" && (
	if not exist Firefox.lnk (
		echo Linking Firefox on public desktop. . .
		powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('Firefox.lnk');$s.TargetPath='%firefoxPath%\%firefoxExe%';$s.Save()"
	)
	popd
)
