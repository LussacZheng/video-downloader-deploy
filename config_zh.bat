rem - Encoding:gb2312; Mode:Batch; Language:zh-CN; LineEndings:CRLF -
:: You-Get(绿色版) 配置脚本
:: Author: Lussac
:: Version: embed-0.1.0
:: Last updated: 2019/06/02
:: https://blog.lussac.net
@echo off
set version=embed-0.1.0
set date=2019/06/02

:: START OF TRANSLATION
title You-Get(绿色版) 配置脚本  -- By Lussac
:: Notification
set no-python-zip=未找到 "python-*-embed-*.zip"。
set no-youget-targz=未找到 "you-get-*.tar.gz"。
set no-7za-exe=未找到 "7za.exe"。
set already-configured=已配置。
set canBeDeleted=_此文件夹可以删除_
:: Procedure
set exit=按任意键退出。
set step1=1. 配置 Python
set step2=2. 配置 You-Get
set step3=3. 使用 You-Get
set unzipping=正在解压
set config-ok=配置已完成。
:: Guides of download and upgrade batches
set dl-guide-embed1=对于此绿色版，应使用"yg"而不是"you-get"命令。
set dl-guide-embed2=如果你移动或重命名了整个文件夹，请重新运行 "config.bat" 。
set dl-guide1=下载视频的命令为：
set dl-guide2=yg+空格+视频网址
set dl-guide3=例如：
set dl-guide4=yg https://v.youku.com/v_show/id_aBCdefGh.html
set dl-guide5=默认下载最高清晰度。下载文件默认保存在 Download 目录。
set dl-guide6=如果你想选择清晰度、更改默认路径，或想了解You-Get其他的用法，请参考官方wiki：
set dl-guide7=https://github.com/soimort/you-get/wiki/中文说明
set up-guide1=如何更新此绿色版 You-Get ：
set up-guide2=https://github.com/LussacZheng/you-get_install_win/tree/embed
:: Contents of download and upgrade batches
set download-bat=You-Get下载视频
set create-bat-done=已创建 You-Get 启动脚本"%download-bat%"。
set download-bat-content=start cmd /k "title %download-bat%&&echo %dl-guide-embed1%&&echo %dl-guide-embed2%&&echo.&&echo.&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo.&&echo %dl-guide6%&&echo %dl-guide7%&&echo.&&echo %up-guide1%&&echo %up-guide2%"
:: Welcome Info
cls
echo =============================================
echo =============================================
echo === You-Get(绿色版) 配置脚本  (By Lussac) ===
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