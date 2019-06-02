rem - Encoding:utf-8; Mode:Batch; Language:zh-CN; LineEndings:CRLF -
:: You-Get 安装脚本
:: Author: Lussac
:: Version: 0.2.1
:: Last updated: 2019/06/02
:: https://blog.lussac.net
@echo off
set version=0.2.1
set date=2019/06/02

:: START OF TRANSLATION
title You-Get 安装脚本  -- By Lussac
:: Notification
set warning========== 安装过程中 请勿关闭本窗口 =========
set no-python-exe=未找到Python安装包。
set info-add-python-to-path1=接下来安装Python时需要先勾选"Add Python to PATH"再点击"Install Now / Customize installation"，务必记得先勾选。
set info-add-python-to-path2=如果你已理解，输入y并按Enter以继续:
set no-ffmpeg-zip=未找到FFmpeg压缩包。
set already-installed=已安装。
set no-unzip-exe=未找到 "unzip.exe" 。
:: Procedure
set exit=按任意键退出。
set run-bat-again=请关闭本窗口后重新运行 install_zh-latest.bat.
set please-wait=安装或解压需要一定时间，请耐心等待...
set step1=1. 安装 Python
set step2=2. 安装 You-Get
set step3=3. 安装 FFmpeg
set step4=4. 使用 You-Get
set opening=正在打开
set installing-youget=正在安装 You-Get...
set unzipping=正在解压
:: Guides of download and upgrade batches
set dl-guide1=下载视频的命令为：
set dl-guide2=you-get+空格+视频网址
set dl-guide3=例如：
set dl-guide4=you-get https://v.youku.com/v_show/id_aBCdefGh.html
set dl-guide5=默认下载最高清晰度。下载文件默认保存在当前脚本所在的目录。
set dl-guide6=如果你想选择清晰度、更改默认路径，或想了解You-Get其他的用法，请参考官方wiki：
set dl-guide7=https://github.com/soimort/you-get/wiki/中文说明
set up-guide1=当前版本：
set up-guide2=正在检查更新...
set up-guide3=更新完成，已是最新版本。
:: Contents of download and upgrade batches
set download-bat=You-Get下载视频
set upgrade-bat=You-Get检查更新
set create-bat-done=已在桌面创建 You-Get 启动脚本"%download-bat%" 和 更新脚本"%upgrade-bat%" 。
set download-bat-content=start cmd /k "title %download-bat%&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo %dl-guide6%&&echo %dl-guide7%"
set upgrade-bat-content=start cmd /k "title %upgrade-bat%&&echo %up-guide1%&&you-get -V&&echo.&&echo %up-guide2%&&python -m pip install --upgrade pip&&pip install --upgrade you-get&&echo.&&echo %up-guide3%&&echo %exit%&&pause>NUL&&exit"
:: Welcome Info
cls
echo =============================================
echo =============================================
echo ======== You-Get安装脚本 (By Lussac) ========
echo =============================================
echo ======== Version: %version% (%date%) ========
echo =============================================
echo =============================================
:: END OF TRANSLATION

:: Start of Installation
echo.&echo %warning%

:: Step 1
echo.&echo %step1%
:: Check whether Python already installed
echo %PATH%|findstr /i "Python">NUL&&goto install-youget||goto check-python-exe

:check-python-exe
:: Check whether "python-x.x.x.exe" exist
for /f "delims=" %%i in ('dir /b /a:a python*.exe') do (set pyExe=%%i&goto loop)
echo.&echo %no-python-exe%
goto EOF

:loop 
echo %info-add-python-to-path1%
set /p flag=%info-add-python-to-path2%
If NOT DEFINED flag goto loop
If /i %flag%==y (goto install-python) else (goto loop)

:install-python
echo.&echo %opening% %pyExe%...&echo %please-wait%
start /wait %pyExe% & echo %pyExe% %already-installed%
echo.&echo %run-bat-again%
pause>NUL
exit

:: Step 2
:install-youget
echo Python %already-installed%
echo.&echo %step2%
echo %installing-youget%&echo %please-wait%
echo.
pip3 install you-get
echo.
echo You-Get %already-installed%

:: Step 3
echo.&echo %step3%
:: Check whether FFmpeg already installed
echo %PATH%|findstr /i "ffmpeg">NUL&&goto start-youget||goto check-ffmpeg-zip

:check-ffmpeg-zip
:: Check whether "ffmpeg-x.x.x.zip" exist
for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do (set FFmpegZip=%%i&goto install-ffmpeg)
echo.&echo %no-ffmpeg-zip%
goto EOF

:install-ffmpeg
echo %unzipping% %FFmpegZip% ...&echo %please-wait%
:: Check whether "unzip.exe" exist
for /f "delims=" %%i in ('dir /b /a:a unzip.exe') do (goto install-ffmpeg_unzipping)
echo.&echo %no-unzip-exe%
goto EOF

:install-ffmpeg_unzipping
unzip -oq %FFmpegZip% -d C:\
move C:\ffmpeg* C:\ffmpeg
::setx "Path" "%Path%;C:\ffmpeg\bin" /m
setx "Path" "%Path%;C:\ffmpeg\bin"

:: Step 4
:start-youget
echo FFmpeg %already-installed%
echo.&echo %step4%
:: Create two quick-start batches to use and upgrade You-Get
echo %download-bat-content% > %USERPROFILE%\Desktop\%download-bat%.bat
echo %upgrade-bat-content%  > %USERPROFILE%\Desktop\%upgrade-bat%.bat
echo %create-bat-done%

:: END OF FILE
:EOF
echo.&echo %exit%
pause>NUL
exit