@echo off

rem Set the base directory containing subdirectories with git repos
set baseDir=.\..\..

rem Loop through all subdirectories
for /d %%d in ("%baseDir%\*") do (
    rem Loop through all repos
    for /d %%r in ("%%d\*") do (
        pushd "%%r"
        if exist ".git" (
            echo Syncing repo: %%r
            git pull
            git push
        )
        popd
    )
)
echo/
echo Done.
pause