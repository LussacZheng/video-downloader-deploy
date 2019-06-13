@rem - Encoding:gb2312; Mode:Batch; Language:zh-CN; LineEndings:CRLF -
:: You-Get (绿色版) 配置脚本
:: Author: Lussac
:: Version: embed-0.2.4
:: Last updated: 2019/06/13
:: https://blog.lussac.net
@echo off
set version=embed-0.2.4
set date=2019/06/13
set res=https://raw.githubusercontent.com/LussacZheng/you-get_install_win/master/res
:: START OF TRANSLATION
set title=You-Get (绿色版) 配置脚本
:: Notification
set please-choose=请输入选项的序号并按回车: 
set please-newDir=请在一个新建的文件夹中运行此脚本。
set please-init=请先执行 You-Get 初始配置。
set already-config=已配置。
set config-ok=配置已完成。
set exit=按任意键退出。
:: Procedure
set unzipping=正在解压
set downloading=正在下载
set open-webpage=正在打开网页
:: Guides of download batch
set dl-guide-embed1=对于此绿色版，应使用"yg"而不是"you-get"命令。
set dl-guide-embed2=如果你移动或重命名了整个文件夹，请重新运行 `config_zh.bat` 并选择 `修复 "yg.cmd"` 。
set dl-guide1=下载视频的命令为：
set dl-guide2=yg+空格+视频网址
set dl-guide3=例如：
set dl-guide4=yg https://v.youku.com/v_show/id_aBCdefGh.html
set dl-guide5=默认下载最高清晰度。下载文件默认保存在 Download 目录。
set dl-guide6=如果你想选择清晰度、更改默认路径，或想了解You-Get其他的用法，请参考官方wiki：
set dl-guide7=https://github.com/soimort/you-get/wiki/中文说明
:: Contents of download batch
set dl-bat=You-Get下载视频
set dl-bat-created=已创建 You-Get 启动脚本"%dl-bat%"。
:: Menu Options
set opt1=[1] 初始配置 You-Get (无 FFmpeg)
set opt2=[2] 配置 FFmpeg
set opt3=[3] 更新 You-Get
set opt4=[4] 修复 "yg.cmd"
set opt5=[5] 重新创建启动脚本
set opt6=[6] 更新此脚本 (访问GitHub)
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
echo ========  %title%  ========
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