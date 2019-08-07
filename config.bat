@rem - Encoding:utf-8; Mode:Batch; Language:zh-CN,en; LineEndings:CRLF -
:: You-Get(Portable) Configure Batch
:: Author: Lussac (https://blog.lussac.net)
:: Version: embed-0.3.3
:: Last updated: 2019-08-07
:: >>> Get updated from: https://github.com/LussacZheng/you-get_install_win/ <<<
@echo off
set version=embed-0.3.3
set lastUpdated=2019-08-07


rem ================= Preparation =================


set res=https://raw.githubusercontent.com/LussacZheng/you-get_install_win/master/res
::  Get system language -> %_lang%
call res\scripts\LanguageSelector.bat
:: Import translation text
call res\scripts\lang_%_lang%.bat

:: Start of Configuration
title %title%  -- By Lussac
set "root=%cd%"
set "pyBin=%root%\python-embed"
set "ygBin=%root%\you-get"


rem ================= Menu =================


:MENU
cd "%root%"
cls
echo =============================================
echo =============================================
echo ===%titleExpanded%===
echo =============================================
echo ================  By Lussac  ================
echo =============================================
echo ====  Version: %version% (%lastUpdated%)  ====
echo =============================================
echo =============================================
echo.
echo.&echo  %opt1%
echo.&echo  %opt2%
echo.&echo  %opt3%
echo.&echo  %opt4%
echo.&echo  %opt5%
echo.&echo  %opt6%
echo.&echo.
echo =============================================
set a=0
set /p a=%please-choose%
echo.
if "%a%"=="1" goto init-config
if "%a%"=="2" goto config-ffmpeg
if "%a%"=="3" goto upgrade-youget
if "%a%"=="4" goto reset-yg-cmd
if "%a%"=="5" goto reset-dl-bat
if "%a%"=="6" goto update
goto MENU


rem ================= OPTION 1 =================


:init-config
call :Common
:: %_region% was set in res\scripts\lang_%_lang%.bat
call scripts\MirrorSwitch.bat sources %_region%
:: https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\sources-%_region%.txt -P download
:: if exist .wget-hsts del .wget-hsts
cd download

if exist "%pyBin%" goto check-youget-zip


:check-python-zip
:: Get the full name of "python-3.x.x-embed*.zip" -> %pyZip%
for /f "delims=" %%i in ('dir /b /a:a python*embed*.zip') do (set pyZip=%%i)
echo %unzipping% %pyZip%...
:: https://superuser.com/questions/331148/7-zip-command-line-extract-silently-quietly
7za x %pyZip% -o"%pyBin%" > NUL


:check-youget-zip
echo Python-embed %already-config%
if exist "%ygBin%" goto creat-bat
call :Setup_YouGet


:creat-bat
echo You-Get %already-config%
cd ..
call :InitLog
cd "%root%"
call :Create_yg-cmd
call :Create_dl-bat
echo.
echo =============================================
echo %config-ok%
echo %dl-bat-created%
echo =============================================
call :_ReturnToMenu_


rem ================= OPTION 2 =================


:config-ffmpeg
:: Check whether FFmpeg already exists
echo %PATH%|findstr /i "ffmpeg">NUL && goto ffmpeg-config-ok

call :CheckForInit
call :Common
wget -q --no-check-certificate -nc %res%/sources_ffmpeg.txt
call scripts\MirrorSwitch.bat sources_ffmpeg %_region%
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\sources_ffmpeg-%_region%.txt -P download
cd download

for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do (set FFmpegZip=%%i)
echo %unzipping% %FFmpegZip% ...
7za x %FFmpegZip% -oC:\ -aoa > NUL
move C:\ffmpeg* C:\ffmpeg > NUL
if exist C:\ffmpeg\bin\ffmpeg.exe ( setx "Path" "%Path%;C:\ffmpeg\bin" )


:ffmpeg-config-ok
echo.&echo FFmpeg %already-config%
call :_ReturnToMenu_


rem ================= OPTION 3 =================


:upgrade-youget
call :CheckForInit
::if NOT exist "%ygBin%\src\you_get\version.py" 
cd res && call :Common_wget
echo %checkingUpdate%...
:: Get %_isYgLatestVersion% from "scripts\CheckUpdate_youget.bat". 0: false; 1: true.
call scripts\CheckUpdate_youget.bat
if %_isYgLatestVersion%==1 (
    echo %youget-upgraded%: v%ygCurrentVersion%
    call :_ReturnToMenu_
)
echo %youget-upgrading%...
cd "%root%" && call :Common
del /Q download\you-get*.tar.gz >NUL 2>NUL
del /Q sources_youget.txt >NUL 2>NUL
wget -q --no-check-certificate -nc %res%/sources_youget.txt
call scripts\MirrorSwitch.bat sources_youget %_region%
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\sources_youget-%_region%.txt -P download
cd download
rd /S /Q "%ygBin%" >NUL 2>NUL

call :Setup_YouGet
echo.&echo You-Get %already-updated%
call :_ReturnToMenu_


rem ================= OPTION 4 =================


:reset-yg-cmd
call :CheckForInit
call :Create_yg-cmd
:: echo @echo @"%%cd%%\python-embed\python.exe" "%%cd%%\you-get\you-get" -o Download %%%%*^>yg.cmd> fix.cmd
echo.&echo %config-ok%
call :_ReturnToMenu_


rem ================= OPTION 5 =================


:reset-dl-bat
call :CheckForInit
call :Create_dl-bat
echo.&echo %dl-bat-created%
call :_ReturnToMenu_


rem ================= OPTION 6 =================


:update
cd res && call :Common_wget
echo %checkingUpdate%...
:: Get %_isLatestVersion% from "scripts\CheckUpdate.bat". 0: false; 1: true.
call scripts\CheckUpdate.bat
if %_isLatestVersion%==1 (
    echo %bat-updated%
    echo %open-webpage1%...
) else (
    echo %bat-updating% %latestVersion%
    echo %open-webpage2%...
)
pause>NUL
start https://github.com/LussacZheng/you-get_install_win
call :_ReturnToMenu_


rem ================= FUNCTIONS =================


:_ReturnToMenu_
::echo.&echo.&echo %return%
pause>NUL
goto MENU


:Common
:: Make sure the existence of res\wget.exe, res\7za.exe, res\download\7za.exe
cd res
call :Common_wget
echo %downloading%...
if NOT exist 7za.exe (
    wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc %res%/7za.exe
)
if NOT exist download\7za.exe (
    xcopy 7za.exe download\ > NUL
)
:: Now %cd% is "res\".
goto :eof


:Common_wget
:: Make sure the existence of res\wget.exe
if NOT exist wget.exe (
    echo %downloading% "wget.exe", %please-wait%...
    :: use ^) instead of )
    powershell (New-Object Net.WebClient^).DownloadFile('%res%/wget.exe', 'wget.exe'^)
)
goto :eof


:Setup_YouGet
for /f "delims=" %%i in ('dir /b /a:a you-get*.tar.gz') do (set ygZip=%%i)
echo %unzipping% %ygZip%...
:: https://superuser.com/questions/80019/how-can-i-unzip-a-tar-gz-in-one-step-using-7-zip
7za x %ygZip% -so | 7za x -aoa -si -ttar > NUL
set ygDir=%ygZip:~0,-7%
move %ygDir% "%root%\you-get" > NUL
goto :eof


:Create_yg-cmd
echo @"%pyBin%\python.exe" "%ygBin%\you-get" -o Download %%*> yg.cmd
goto :eof


:Create_dl-bat
set dl-bat-content=@start cmd /k "title %dl-bat%&&echo %dl-guide-embed1%&&echo %dl-guide-embed2%&&echo.&&echo.&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo.&&echo %dl-guide6%&&echo %dl-guide7%"
echo %dl-bat-content%> %dl-bat%.bat
goto :eof


:InitLog
echo initialized: true> init.log
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do set LDT=%%a
set "formatedDateTime=%LDT:~0,4%-%LDT:~4,2%-%LDT:~6,2% %LDT:~8,2%:%LDT:~10,2%:%LDT:~12,2%"
echo time: %formatedDateTime%>> init.log
::echo time: %date:~0,10% %time:~0,8%>> init.log
echo pyZip: %pyZip%>> init.log
echo ygZip: %ygZip%>> init.log
echo pyBin: "%pyBin%">> init.log
echo ygBin: "%ygBin%">> init.log
goto :eof


:CheckForInit
if NOT exist res\init.log (
    echo.&echo %please-init%
    pause>NUL
    goto MENU
)
goto :eof

rem ================= End of File =================