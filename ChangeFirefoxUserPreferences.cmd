@echo off
setlocal enabledelayedexpansion

rem Define the lines to replace.
set targetLine1-1=user_pref^(^"browser.newtabpage.activity-stream.newtabWallpapers.wallpaper^", ^"abstract-orange^"^);
set targetLine1-2=user_pref^(^"browser.newtabpage.activity-stream.newtabWallpapers.wallpaper^", ^"^"^);
set changedLine1=user_pref^(^"browser.newtabpage.activity-stream.newtabWallpapers.wallpaper^", ^"firefox-a^"^);
set targetLine2=user_pref^(^"browser.ml.chat.provider^", ^"^"^);
rem The following line will be inserted at the end if the target line isn't found.
set changedLine2=user_pref^(^"browser.ml.chat.provider^", ^"https://chat.mistral.ai/chat^"^);

rem Base constants
set usersPath=C:\Users\
set firefoxSubpath=AppData\Roaming\Mozilla\Firefox\Profiles
set prefFileName=prefs.js

rem If Firefox is open, close the script.
tasklist | find "firefox.exe" >nul && (
	exit /b
)

rem Loop through all folders in Users
for /f "tokens=*" %%p in ('dir /a:d-s /b "%usersPath%*"') do (
	set userPath=%usersPath%\%%p
	rem Loop through each folder in the profiles directory.
	for /d %%d in ("!userPath!\%firefoxSubpath%\*.default-release") do (
		set profilePath=%%d
		set prefsFile=!profilePath!\%prefFileName%
		rem Check if prefs.js exists.
		if exist "!prefsFile!" (
			echo Found profile: !profilePath!
			echo Updating prefs.js...
			set setting2Found=0
			rem Create an empty temporary file.
			set tempFile=!profilePath!\%prefFileName%.tmp
			type nul > "!tempFile!"
			rem Loop through the lines in the file.
			rem Append each line to the temp file.
			for /f "usebackq delims=" %%a in ("!prefsFile!") do (
				set line=%%a
				if "!line!"=="%targetLine1-1%" (
					echo !changedLine1!
				) else if "!line!"=="%targetLine1-2%" (
					echo !changedLine1!
				) else if "!line!"=="%targetLine2%" (
					echo !changedLine2!
					set setting2Found=1
				) else (
					echo !line!
				)
			) >> "!tempFile!"
			if !setting2Found!==0 (
				echo !changedLine2! >> "!tempFile!"
			)
			rem Replace the original file with the temp file.
			move /y "!tempFile!" "!prefsFile!" >nul
			echo Update complete.
		)
	)
)