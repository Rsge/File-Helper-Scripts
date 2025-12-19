@echo off
setlocal enabledelayedexpansion

rem Define the target lines to replace.
set targetLine1-1=user_pref^(^"browser.newtabpage.activity-stream.newtabWallpapers.wallpaper^", ^"abstract-orange^"^);
set targetLine1-2=user_pref^(^"browser.newtabpage.activity-stream.newtabWallpapers.wallpaper^", ^"^"^);
set changedLine1=user_pref^(^"browser.newtabpage.activity-stream.newtabWallpapers.wallpaper^", ^"firefox-a^"^);
set targetLine2=user_pref^(^"browser.ml.chat.provider^", ^"^"^);
set changedLine2=user_pref^(^"browser.ml.chat.provider^", ^"https://chat.mistral.ai/chat^"^);
set usersPath=C:\Users\
set firefoxSubpath=AppData\Roaming\Mozilla\Firefox\Profiles

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
		set prefsFile=!profilePath!\prefs.js
		rem Check if prefs.js exists.
		if exist "!prefsFile!" (
			echo Found profile: !profilePath!
			echo Updating prefs.js...
			rem Create an empty temporary file.
			set temp_file=!profilePath!\prefs_temp.js
			type nul > "!temp_file!"
			pause
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
				) else (
					echo !line!
				)
			) >> "!temp_file!"
			pause
			rem Replace the original file with the temp file.
			move /y "!temp_file!" "!prefsFile!" >nul
			echo Update complete.
		)
	)
)