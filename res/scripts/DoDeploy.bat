@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :InitDeploy-* & :Upgrade-*
:: Please make sure that: only call this batch when %cd% is "res\"; call "res\scripts\lang_*.bat" before calling this batch.
:: e.g.
:: call scripts\DoDeploy.bat Setup youget
:: call scripts\DoDeploy.bat Upgrade youtubedl

@echo off
set "dd_Type=%~1"
set "dd_Tool=%~2"
call :DoDeploy-%dd_Type%
goto :eof


rem ================= Deploy Types =================


:DoDeploy-Setup
cd download
call :Setup_%dd_Tool%
cd ..
goto :eof


:DoDeploy-Upgrade
call :Upgrade_%dd_Tool%
goto :eof


rem ================= FUNCTIONS =================


:Setup_python
:: Get the full name of "python-3.x.x-embed*.zip" -> %pyZip%
for /f "delims=" %%i in ('dir /b /a:a /o:d python*embed*.zip') do ( set "pyZip=%%i" )
echo %str_unzipping% %pyZip%...
:: https://superuser.com/questions/331148/7-zip-command-line-extract-silently-quietly
7za x -aoa -o"%pyBin%" %pyZip% > NUL
echo Python-embed %str_already-deploy%
goto :eof


:Setup_youget
for /f "delims=" %%i in ('dir /b /a:a /o:d you-get*.tar.gz') do ( set "ygZip=%%i" )
if NOT "%~1"=="" ( set "ygZip=%~1" )
echo %str_unzipping% %ygZip%...
:: https://superuser.com/questions/80019/how-can-i-unzip-a-tar-gz-in-one-step-using-7-zip
7za x %ygZip% -so | 7za x -aoa -si -ttar > NUL
ping -n 3 127.0.0.1 > NUL
set ygDir=%ygZip:~0,-7%
move %ygDir% "%ygBin%" > NUL
echo You-Get %str_already-deploy%
goto :eof


:Setup_youtubedl
for /f "delims=" %%i in ('dir /b /a:a /o:d youtube*dl*.tar.gz') do ( set "ydZip=%%i" )
if NOT "%~1"=="" ( set "ydZip=%~1" )
echo %str_unzipping% %ydZip%...
7za x %ydZip% -so | 7za x -aoa -si -ttar > NUL
:: In order to avoid access denied, wait for the decompression to complete.
ping -n 5 127.0.0.1 > NUL
REM There are two kinds of package:
REM   `youtube_dl-2020.9.20.tar.gz` with `youtube_dl-2020.9.20` inside;
REM   `youtube-dl-2020.09.20.tar.gz` with `youtube-dl` inside.
if NOT exist youtube-dl\ (
    set "ydDir=%ydZip:~0,-7%"
) else (
    set "ydDir=youtube-dl"
)
move %ydDir% "%ydBin%" > NUL
( echo #^^!/usr/bin/env python3
echo.
echo import sys, os.path
echo.
echo path = os.path.realpath^(os.path.abspath^(__file__^)^)
echo sys.path.insert^(0, os.path.dirname^(path^)^)
echo.
echo import youtube_dl
echo.
echo if __name__ == '__main__':
echo     youtube_dl.main^(^) ) > "%ydBin%\youtube-dl"
echo Youtube-dl %str_already-deploy%
goto :eof


:Setup_lux
for /f "delims=" %%i in ('dir /b /a:a /o:d lux*Windows*.zip') do ( set "lxZip=%%i" )
if NOT "%~1"=="" ( set "lxZip=%~1" )
echo %str_unzipping% %lxZip%...
7za x -aoa -o"%lxBin%" %lxZip% > NUL
echo Lux %str_already-deploy%
goto :eof


:Setup_ffmpeg
for /f "delims=" %%i in ('dir /b /a:a /o:d ffmpeg*.zip ffmpeg*.7z') do ( set "ffZip=%%i" )
echo %str_unzipping% %ffZip% ...
7za x -aoa %ffZip% > NUL
:: trim file extension
for /f %%i in ("%ffZip%") do ( set "ffDir=%%~ni" )
move %ffDir% "%root%\usr\ffmpeg" > NUL
goto :eof


:Upgrade_youget
setlocal EnableDelayedExpansion
echo %str_upgrading% you-get...
:: %ygCurrentVersion% was set in res\scripts\CheckUpdate.bat :CheckUpdate_youget
del /Q download\you-get-%ygCurrentVersion%.tar.gz >NUL 2>NUL
set "ygFinalFilename=you-get-%ygLatestVersion%.tar.gz"
if exist deploy.settings (
    for /f "tokens=2 delims= " %%i in ('findstr /i "UpgradeOnlyViaGitHub" deploy.settings') do ( set "state_upgradeOnlyViaGitHub=%%i" )
) else ( set "state_upgradeOnlyViaGitHub=disable" )
if "%state_upgradeOnlyViaGitHub%"=="enable" (
    set "ygLatestVersion_Url=https://github.com/soimort/you-get/releases/download/v%ygLatestVersion%/%ygFinalFilename%"
    echo !ygLatestVersion_Url!>> download\to-be-downloaded.txt
    wget %_WgetOptions_% !ygLatestVersion_Url! -P download
) else (
    REM flag %state_isSourcesUpToDate% is used to avoid downloading %_RemoteRes_%/sources.txt
    REM   twice in one upgrading process.
    if NOT "%state_isSourcesUpToDate%"=="true" (
        del /Q sources.txt >NUL 2>NUL
        wget %_WgetOptions_% %_RemoteRes_%/sources.txt
        set "state_isSourcesUpToDate=true"
    )
    call scripts\SourcesSelector.bat sources.txt youget %_Region_% %_SystemType_% download\to-be-downloaded.txt
    wget %_WgetOptions_% -i download\to-be-downloaded.txt -P download
    REM If the file fails to download because of mirror index not syncing timelier, set %_Region_% as "origin" to fetch from original source.
    if NOT exist download\%ygFinalFilename% (
        call scripts\SourcesSelector.bat sources.txt youget origin %_SystemType_% download\to-be-downloaded.txt
        wget %_WgetOptions_% -i download\to-be-downloaded.txt -P download
    )
    REM If %_RemoteRes_%/sources.txt is not updated timely after the new release of you-get, download it from GitHub
    if NOT exist download\%ygFinalFilename% (
        set "ygLatestVersion_Url=https://github.com/soimort/you-get/releases/download/v%ygLatestVersion%/%ygFinalFilename%"
        ( echo # RemoteRes is not updated timely after the new release of you-get, download it from GitHub:
        echo !ygLatestVersion_Url!) >> download\to-be-downloaded.txt
        wget %_WgetOptions_% !ygLatestVersion_Url! -P download
    )
)
REM Endlocal will clean the local environment variables,
REM   so you should bring out the required variables.
endlocal & set "ygFinalFilename=%ygFinalFilename%" & set "state_isSourcesUpToDate=%state_isSourcesUpToDate%"
rd /S /Q "%ygBin%" >NUL 2>NUL
cd download && call :Setup_youget "%ygFinalFilename%"
cd .. && echo You-Get %str_already-upgrade%
goto :eof


:Upgrade_youtubedl
setlocal EnableDelayedExpansion
echo %str_upgrading% youtube-dl...
:: %ydCurrentVersion% and %ydLatestVersion% were set in res\scripts\CheckUpdate.bat :CheckUpdate_youtubedl
set "ydCurrentVersion_trimZero=%ydCurrentVersion:.0=.%"
:: If "%ydCurrentVersion%"=="2019.08.02", "%ydCurrentVersion_trimZero%" will be "2019.8.2".
set "ydLatestVersion_trimZero=%ydLatestVersion:.0=.%"
del /Q download\youtube-dl-%ydCurrentVersion%.tar.gz >NUL 2>NUL
del /Q download\youtube_dl-%ydCurrentVersion_trimZero%.tar.gz >NUL 2>NUL
set "ydFinalFilename=youtube_dl-%ydLatestVersion_trimZero%.tar.gz"
if exist deploy.settings (
    for /f "tokens=2 delims= " %%i in ('findstr /i "UpgradeOnlyViaGitHub" deploy.settings') do ( set "state_upgradeOnlyViaGitHub=%%i" )
) else ( set "state_upgradeOnlyViaGitHub=disable" )
if "%state_upgradeOnlyViaGitHub%"=="enable" (
    set "ydFinalFilename=youtube-dl-%ydLatestVersion%.tar.gz"
    set "ydLatestVersion_Url=https://github.com/ytdl-org/youtube-dl/releases/download/%ydLatestVersion%/!ydFinalFilename!"
    echo !ydLatestVersion_Url!>> download\to-be-downloaded.txt
    wget %_WgetOptions_% !ydLatestVersion_Url! -P download
) else (
    if NOT "%state_isSourcesUpToDate%"=="true" (
        del /Q sources.txt >NUL 2>NUL
        wget %_WgetOptions_% %_RemoteRes_%/sources.txt
        set "state_isSourcesUpToDate=true"
    )
    call scripts\SourcesSelector.bat sources.txt youtubedl %_Region_% %_SystemType_% download\to-be-downloaded.txt
    wget %_WgetOptions_% -i download\to-be-downloaded.txt -P download
    if NOT exist download\%ydFinalFilename% (
        call scripts\SourcesSelector.bat sources.txt youtubedl origin %_SystemType_% download\to-be-downloaded.txt
        wget %_WgetOptions_% -i download\to-be-downloaded.txt -P download
    )
    if NOT exist download\%ydFinalFilename% (
        set "ydFinalFilename=youtube-dl-%ydLatestVersion%.tar.gz"
        set "ydLatestVersion_Url=https://github.com/ytdl-org/youtube-dl/releases/download/%ydLatestVersion%/!ydFinalFilename!"
        ( echo # RemoteRes is not updated timely after the new release of youtube-dl, download it from GitHub:
        echo !ydLatestVersion_Url!) >> download\to-be-downloaded.txt
        wget %_WgetOptions_% !ydLatestVersion_Url! -P download
    )
)
endlocal & set "ydFinalFilename=%ydFinalFilename%" & set "state_isSourcesUpToDate=%state_isSourcesUpToDate%"
rd /S /Q "%ydBin%" >NUL 2>NUL
cd download && call :Setup_youtubedl "%ydFinalFilename%"
cd .. && echo Youtube-dl %str_already-upgrade%
goto :eof


:Upgrade_lux
echo %str_upgrading% lux...
:: %lxCurrentVersion% , %lxLatestVersion% and %lxLatestVersion_Tag%
::   were set in res\scripts\CheckUpdate.bat :CheckUpdate_lux
del /Q download\lux_%lxCurrentVersion%_Windows*.zip >NUL 2>NUL
set "lxLatestVersion_Url=https://github.com/iawia002/lux/releases/download/%lxLatestVersion_Tag%/lux_%lxLatestVersion%_Windows_%_SystemType_%-bit.zip"
echo %lxLatestVersion_Url%>> download\to-be-downloaded.txt
wget %_WgetOptions_% %lxLatestVersion_Url% -P download
del /Q "%lxBin%\lux.exe" >NUL 2>NUL
cd download && call :Setup_lux "lux_%lxLatestVersion%_Windows_%_SystemType_%-bit.zip"
cd .. && echo Lux %str_already-upgrade%
goto :eof


rem ================= End of File =================
