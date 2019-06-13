@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: You-Get(Portable) Configure Batch
:: Author: Lussac
:: Version: embed-0.2.4
:: Last updated: 2019/06/13
:: https://blog.lussac.net
@echo off
set version=embed-0.2.4
set date=2019/06/13
set res=https://raw.githubusercontent.com/LussacZheng/you-get_install_win/master/res
:: START OF TRANSLATION
set title=You-Get(Portable) Configure Batch
:: Notification
set please-choose=Please input the index number of option and press ENTER:
set please-newDir=Please run this batch in a newly created folder.
set please-init=Please perform the initial configuration of You-Get first.
set already-config=already configured.
set config-ok=Configuration completed.
set exit=Press any key to exit.
:: Procedure
set unzipping=Unzipping
set downloading=Downloading
set open-webpage=Opening the webpage
:: Guides of download batch
set dl-guide-embed1=For this portable version, use "yg" command instead of "you-get".
set dl-guide-embed2=If you move or rename the whole folder, please re-run `config_en.bat` and select `Fix "yg.cmd"`.
set dl-guide1=The command to download a video is:
set dl-guide2=yg+'Space'+'video url'
set dl-guide3=For example:
set dl-guide4=yg https://www.youtube.com/watch?v=aBCdefGh
set dl-guide5=By default, you will get the video of highest quality. And the files downloaded will be saved in "Download".
set dl-guide6=If you want to choose the quality of video, change the directory saved in, or learn more usage of You-Get, please refer the Official wiki:
set dl-guide7=https://github.com/soimort/you-get#download-a-video
:: Contents of download batch
set dl-bat=You-Get_Download_video
set dl-bat-created=The You-Get starting batch "%dl-bat%" has been created.
:: Menu Options
set opt1=[1] Initial Configuration of You-Get (Without FFmpeg)
set opt2=[2] Configure FFmpeg
set opt3=[3] Upgrade You-Get
set opt4=[4] Fix "yg.cmd"
set opt5=[5] Re-create the quickstart batch
set opt6=[6] Update this batch (Visit GitHub)
:: END OF TRANSLATION

:: Start of Configuration
title %title%  -- By Lussac
set root=%cd%
set pyBin=%root%\python-embed
set ygBin=%root%\you-get

:MENU
cd %root%
cls
echo =============================================
echo =============================================
echo ====  %title%  ====
echo =============================================
echo ================  By Lussac  ================
echo =============================================
echo ====  Version: %version% (%date%)  ====
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
:: Only allow "res" and this batch (totally 2) in this folder when initial configuration.
for /f "delims=" %%i in (' dir /b ') do ( set /a isNewDir+=1 )
if %isNewDir% GTR 2 ( echo %please-newDir% & goto EXIT )

call :Common
:: del /Q sources.txt >NUL 2>NUL
wget -q --no-check-certificate -nc %res%/sources.txt
:: https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i sources.txt
:: if exist .wget-hsts del .wget-hsts

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
call :InitLog
cd ..
call :Create_yg-cmd
call :Create_dl-bat
echo.
echo =============================================
echo %config-ok%
echo %dl-bat-created%
echo =============================================
pause>NUL
goto MENU

rem ================= OPTION 2 =================

:config-ffmpeg
:: Check whether FFmpeg already exists
echo %PATH%|findstr /i "ffmpeg">NUL && goto ffmpeg-config-ok

call :CheckForInit
call :Common
wget -q --no-check-certificate -nc %res%/sources_ffmpeg.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i sources_ffmpeg.txt

for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do (set FFmpegZip=%%i)
echo %unzipping% %FFmpegZip% ...
7za x %FFmpegZip% -oC:\ -aoa > NUL
move C:\ffmpeg* C:\ffmpeg > NUL
if exist C:\ffmpeg\bin\ffmpeg.exe ( setx "Path" "%Path%;C:\ffmpeg\bin" )

:ffmpeg-config-ok
echo.&echo FFmpeg %already-config%
pause>NUL
goto MENU

rem ================= OPTION 3 =================

:upgrade-youget
call :CheckForInit
call :Common
del /Q you-get*.tar.gz >NUL 2>NUL
del /Q sources_youget.txt >NUL 2>NUL
wget -q --no-check-certificate -nc %res%/sources_youget.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i sources_youget.txt
rd /S /Q "%ygBin%" >NUL 2>NUL

call :Setup_YouGet
echo.&echo You-Get %already-config%
pause>NUL
goto MENU

rem ================= OPTION 4 =================

:reset-yg-cmd
call :CheckForInit
call :Create_yg-cmd
:: echo @echo @"%%cd%%\python-embed\python.exe" "%%cd%%\you-get\you-get" -o Download %%%%*^>yg.cmd> fix.cmd
echo.&echo %config-ok%
pause>NUL
goto MENU

rem ================= OPTION 5 =================

:reset-dl-bat
call :CheckForInit
call :Create_dl-bat
echo.&echo %dl-bat-created%
pause>NUL
goto MENU

rem ================= OPTION 6 =================

:update
echo %open-webpage%...
start https://github.com/LussacZheng/you-get_install_win
pause>NUL
goto MENU

rem ================= FUNCTION =================

:EXIT
echo.&echo %exit%
pause>NUL
exit

:Common
if NOT exist res md res
cd res
if NOT exist wget.exe (
    echo %downloading% "wget.exe"...
    :: use ^) instead of )
    powershell (New-Object Net.WebClient^).DownloadFile('%res%/wget.exe', 'wget.exe'^)
)
echo %downloading%...
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
set dl-bat-content=start cmd /k "title %dl-bat%&&echo %dl-guide-embed1%&&echo %dl-guide-embed2%&&echo.&&echo.&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo.&&echo %dl-guide6%&&echo %dl-guide7%"
echo %dl-bat-content%> %dl-bat%.bat
goto :eof

:InitLog
echo initialized: true> init.log
echo time: %date:~0,10% %time:~0,8%>> init.log
echo pyZip: %pyZip%>> init.log
echo ygZip: %ygZip%>> init.log
echo pyBin: %pyBin%>> init.log
echo ygBin: %ygBin%>> init.log
goto :eof

:CheckForInit
if NOT exist res\init.log (
    echo.&echo %please-init%
    pause>NUL
    goto MENU
)
goto :eof