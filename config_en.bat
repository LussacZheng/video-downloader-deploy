rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: You-Get(Portable) Configure Batch
:: Author: Lussac
:: Version: embed-0.1.0
:: Last updated: 2019/06/02
:: https://blog.lussac.net
@echo off
set version=embed-0.1.0
set date=2019/06/02

:: START OF TRANSLATION
title You-Get(Portable) Configure Batch  -- By Lussac
:: Notification
set no-python-zip="python-*-embed-*.zip" NOT found.
set no-youget-targz="you-get-*.tar.gz" NOT found.
set no-7za-exe="7za.exe" NOT found.
set already-configured=already configured.
set canBeDeleted=_This folder can be deleted_
:: Procedure
set exit=Press any key to exit.
set step1=1. Configure Python
set step2=2. Configure You-Get
set step3=3. Start You-Get
set unzipping=Unzipping
set config-ok=Configuration completed.
:: Guides of download and upgrade batches
set dl-guide-embed1=For this portable version, use "yg" command instead of "you-get".
set dl-guide-embed2=If you move or rename the whole folder, please run the "config.bat" again.
set dl-guide1=The command to download a video is:
set dl-guide2=yg+'Space'+'video url'
set dl-guide3=For example:
set dl-guide4=yg https://www.youtube.com/watch?v=aBCdefGh
set dl-guide5=By default, you will get the video of highest quality. And the files downloaded will be saved in "Download".
set dl-guide6=If you want to choose the quality of video, change the directory saved in, or learn more usage of You-Get, please refer the Official wiki:
set dl-guide7=https://github.com/soimort/you-get#download-a-video
set up-guide1=How to upgrade the portable version of You-Get:
set up-guide2=https://github.com/LussacZheng/you-get_install_win/tree/embed
:: Contents of download and upgrade batches
set download-bat=You-Get_Download_video
set create-bat-done=The You-Get starting batch "%download-bat%" has been created.
set download-bat-content=start cmd /k "title %download-bat%&&echo %dl-guide-embed1%&&echo %dl-guide-embed2%&&echo.&&echo.&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo.&&echo %dl-guide6%&&echo %dl-guide7%&&echo.&&echo %up-guide1%&&echo %up-guide2%"
:: Welcome Info
cls
echo =============================================
echo =============================================
echo  You-Get(Portable) Configure Batch  (By Lussac)
echo =============================================
echo ===== Version: %version% (%date%) =====
echo =============================================
echo =============================================
:: END OF TRANSLATION

:: Start of Installation
echo.
set root=%~dp0
set root=%root:~0,-1%
set pySrc=%root%\Python-embed
set ygSrc=%root%\you-get

if exist 7za.exe md "%canBeDeleted%" & goto start > NUL
if NOT exist "%pySrc%" (
    echo.&echo %no-7za-exe%
    goto EOF
)
if NOT exist "%ygSrc%" (
    echo.&echo %no-7za-exe%
    goto EOF
)

:start
:: Step 1
echo.&echo %step1%
:: Check whether Python already configured
if exist "%pySrc%" goto check-youget-zip

:check-python-zip
:: Check whether "python-3.x.x-embed*.zip" exist
for /f "delims=" %%i in ('dir /b /a:a python*embed*.zip') do (set pyZip=%%i& goto configure-python)
echo.&echo %no-python-zip%
goto EOF

:configure-python
echo %unzipping% %pyZip%...
::https://superuser.com/questions/331148/7-zip-command-line-extract-silently-quietly
7za x %pyZip% -o"%pySrc%" > NUL
move %pyZip% "%root%\%canBeDeleted%" > NUL
echo.

:: Step 2
:check-youget-zip
echo Python-embed %already-configured%
echo.&echo %step2%
if exist "%ygSrc%" goto configure

for /f "delims=" %%i in ('dir /b /a:a you-get*.tar.gz') do (set ygZip=%%i& goto configure-youget)
echo.&echo %no-youget-targz%
goto EOF

:configure-youget
echo %unzipping% %ygZip%...
:: https://superuser.com/questions/80019/how-can-i-unzip-a-tar-gz-in-one-step-using-7-zip
7za x %ygZip% -so | 7za x -aoa -si -ttar > NUL
set ygDir=%ygZip:~0,-7%
move "%root%\%ygDir%" "%root%\you-get" > NUL
move %ygZip% "%root%\%canBeDeleted%" > NUL

if exist 7za.exe move 7za.exe "%root%\%canBeDeleted%" > NUL
echo.

:: Step 3
:configure
echo You-Get %already-configured%
echo.&echo %step3%
echo @"%pySrc%\python.exe" "%ygSrc%\you-get" -o Download %%*>yg.cmd

:: Create two quick-start batches to use and upgrade You-Get
echo %download-bat-content% > %download-bat%.bat
echo %create-bat-done%
echo.
echo =============================================
echo %config-ok%
echo =============================================

:: END OF FILE
:EOF
echo.&echo %exit%
pause>NUL
exit