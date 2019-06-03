rem - Encoding:gb2312; Mode:Batch; Language:zh-CN; LineEndings:CRLF -
:: You-Get(绿色版) 配置脚本
:: Author: Lussac
:: Version: embed-0.2.0
:: Last updated: 2019/06/03
:: https://blog.lussac.net
@echo off
set version=embed-0.2.0
set date=2019/06/03
:: START OF TRANSLATION
set title=You-Get(绿色版) 配置脚本
:: Notification
set please-newDir=请在一个新建的文件夹中运行此脚本。
set already-config=已配置。
set config-ok=配置已完成。
set exit=按任意键退出。
:: Procedure
set downloading=正在下载
set unzipping=正在解压
set please-choose=请输入数字后回车: 
set open-webpage=正在打开网页
:: Guides of download batch
set dl-guide-embed1=对于此绿色版，应使用"yg"而不是"you-get"命令。
set dl-guide-embed2=如果你移动或重命名了整个文件夹，请重新运行 "config.bat" 。
set dl-guide1=下载视频的命令为：
set dl-guide2=yg+空格+视频网址
set dl-guide3=例如：
set dl-guide4=yg https://v.youku.com/v_show/id_aBCdefGh.html
set dl-guide5=默认下载最高清晰度。下载文件默认保存在 Download 目录。
set dl-guide6=如果你想选择清晰度、更改默认路径，或想了解You-Get其他的用法，请参考官方wiki：
set dl-guide7=https://github.com/soimort/you-get/wiki/中文说明
:: Contents of download batch
set download-bat=You-Get下载视频
set create-bat-done=已创建 You-Get 启动脚本"%download-bat%"。
set download-bat-content=start cmd /k "title %download-bat%&&echo %dl-guide-embed1%&&echo %dl-guide-embed2%&&echo.&&echo.&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo.&&echo %dl-guide6%&&echo %dl-guide7%"
:: Welcome Info
set opt1=[1] 初次配置 You-Get (无 FFmpeg)
set opt2=[2] 配置 FFmpeg
set opt3=[3] 更新 You-Get
set opt4=[4] 修复 "yg.cmd"
set opt5=[5] 更新此脚本 (访问GitHub)
:: END OF TRANSLATION

:: Start of Configuration
title %title%  -- By Lussac
set root=%cd%
set pySrc=%root%\python-embed
set ygSrc=%root%\you-get
:: [TEST]
set http=C:\Users\admin\Desktop\branch embed-python\full-test\http

:menu
cd %root%
cls
echo =============================================
echo =============================================
echo === %title%  (By Lussac) ===
echo =============================================
echo ===== Version: %version% (%date%) =====
echo =============================================
echo =============================================
echo.
echo.&echo  %opt1%
echo.&echo  %opt2%
echo.&echo  %opt3%
echo.&echo  %opt4%
echo.&echo  %opt5% 
echo.&echo.
echo =============================================
set /p a=%please-choose%
echo.
if "%a%"=="1" goto init-config
if "%a%"=="2" goto config-ffmpeg
if "%a%"=="3" goto upgrade-youget
if "%a%"=="4" goto reset-ygcmd
if "%a%"=="5" goto update
goto menu

rem ================= OPTION 1 =================

:init-config
:: Only allow "res" and this batch (totally 2) in this folder when initial configuration.
for /f "delims=" %%i in (' dir /b ') do ( set /a isNewDir+=1 )
::if %isNewDir% GTR 2 ( echo. & echo %please-newDir% & goto EXIT )

call :Commom

echo %downloading% "Sources List"...
wget -q --no-check-certificate https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/res/sources.txt
::https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i sources.txt
::if exist .wget-hsts del .wget-hsts

if exist "%pySrc%" goto check-youget-zip

:check-python-zip
:: Get the full name of "python-3.x.x-embed*.zip" > %pyZip%
for /f "delims=" %%i in ('dir /b /a:a python*embed*.zip') do (set pyZip=%%i)
echo %unzipping% %pyZip%...
::https://superuser.com/questions/331148/7-zip-command-line-extract-silently-quietly
7za x %pyZip% -o"%pySrc%" > NUL

:check-youget-zip
echo Python-embed %already-config%

if exist "%ygSrc%" goto creat-bat

call :Setup-YouGet

:creat-bat
echo You-Get %already-config%
cd ..
call :Create-ygcmd
echo %download-bat-content% > %download-bat%.bat
echo.&echo %create-bat-done%
pause>NUL
goto menu

rem ================= OPTION 2 =================

:config-ffmpeg
:: Check whether FFmpeg already exists
echo %PATH%|findstr /i "ffmpeg">NUL && goto ffmpeg-config-ok

call :Commom
wget -q --no-check-certificate https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/res/sources_ffmpeg.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i sources_ffmpeg.txt

for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do (set FFmpegZip=%%i)
echo %unzipping% %FFmpegZip% ...
7za x %FFmpegZip% -oC:\ -aoa > NUL
move C:\ffmpeg* C:\ffmpeg > NUL
setx "Path" "%Path%;C:\ffmpeg\bin"

:ffmpeg-config-ok
echo.&echo FFmpeg %already-config%
pause>NUL
goto menu

rem ================= OPTION 3 =================

:upgrade-youget
call :Commom
if exist you-get*.tar.gz del /Q you-get*.tar.gz
rd /S /Q "%ygSrc%"
wget -q --no-check-certificate https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/res/sources_youget.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i sources_youget.txt
call :Setup-YouGet
echo.&echo You-Get %already-config%
pause>NUL
goto menu

rem ================= OPTION 4 =================

:reset-ygcmd
call :Create-ygcmd
::echo @echo @"%%cd%%\python-embed\python.exe" "%%cd%%\you-get\you-get" -o Download %%%%*^>yg.cmd> re-config.cmd
echo.&echo %config-ok%
pause>NUL
goto menu

rem ================= OPTION 5 =================

:update
echo %open-webpage%...
start https://github.com/LussacZheng/you-get_install_win/tree/embed
pause>NUL
goto menu

rem ================= FUNCTION =================

:EXIT
echo.&echo %exit%
pause>NUL
exit

:Commom
if NOT exist res md res
cd res
call :Get-wget
goto :eof

:Get-wget
if NOT exist wget.exe (
    echo %downloading% "wget.exe"...
    :: use ^) instead of )
    powershell (New-Object Net.WebClient^).DownloadFile('https://raw.githubusercontent.com/LussacZheng/you-get_install_win/embed/res/wget.exe', 'wget.exe'^)
)
goto :eof

:Setup-YouGet
for /f "delims=" %%i in ('dir /b /a:a you-get*.tar.gz') do (set ygZip=%%i)
echo %unzipping% %ygZip%...
:: https://superuser.com/questions/80019/how-can-i-unzip-a-tar-gz-in-one-step-using-7-zip
7za x %ygZip% -so | 7za x -aoa -si -ttar > NUL
set ygDir=%ygZip:~0,-7%
move %ygDir% "%root%\you-get" > NUL
goto :eof

:Create-ygcmd
echo @"%pySrc%\python.exe" "%ygSrc%\you-get" -o Download %%*> yg.cmd
goto :eof