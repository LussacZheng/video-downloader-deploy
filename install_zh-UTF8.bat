:: You-Get一键安装脚本  -- By Lussac
:: Last updated on 2019/04/17
:: Version: 0.1.0
:: http://blog.lussac.net
@echo off
:: Get Admin permission. For: 1.Once UAC confirm instead of three times; 2.Set system environment variables.
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d %~dp0
::
:: START OF TRANSLATION
title You-Get 一键安装脚本  -- By Lussac
:: Notification
set warning==========安装过程中请勿关闭本窗口!!!=========
set no-python-exe=未找到Python安装包。
set info-add-python-to-path1=接下来安装Python时需要先勾选"Add Python to Path"再点击"Install Now"，务必记得先勾选。
set info-add-python-to-path2=如果你已理解，输入y并按Enter以继续:
set python-not-in-path=环境变量未配置成功，请手动配置。
set no-ffmpeg-zip=未找到FFmpeg压缩包。
set press-after-unzip=请在解压完成后按Enter!!!
set install-completed=安装完成。
set already-installed=已安装。
set installing-youget=正在安装 You-Get...
:: Procedure
set exit=按任意键退出。
set step1=1. 安装 Python
set run-bat-again=请关闭本窗口后重新运行此脚本!!!
set step2=2. 安装 You-Get
set step3=3. 安装 FFmpeg
set step4=4. 使用 You-Get
:: GUides of download and update batches
set dl-guide1=下载视频的命令为：
set dl-guide2=you-get+空格+视频网址
set dl-guide3=例如：
set dl-guide4=you-get https://v.youku.com/v_show/id_aBCdefGh.html
set dl-guide5=默认下载最高清晰度。下载文件默认保存在：%USERPROFILE%
set dl-guide6=如果你想要选择清晰度或更改保存文件夹，请参考官方wiki：
set dl-guide7=https://github.com/soimort/you-get/wiki/中文说明#下载视频
set up-guide1=当前版本：
set up-guide2=正在更新...
set up-guide3=更新完成，已是最新版本。
:: Quick start batch content
set download-bat=You-Get下载视频
set update-bat=You-Get检查更新
set create-bat-done=已在桌面创建You-Get启动脚本"%download-bat%"和更新脚本"%update-bat%"。
set download-bat-content=start cmd /k "title %download-bat%&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo %dl-guide6%&&echo %dl-guide7%"
set update-bat-content=start cmd /k "title %update-bat%&&echo %up-guide1%&&you-get -V&&echo %up-guide2%&&pip install --upgrade you-get&&echo %up-guide3%&&echo %exit%&&pause>NUl&&exit"
::set desktop=桌面
:: Welcome Info
cls
echo =============================================
echo =============================================
echo ===欢迎使用You-Get一键安装脚本 (By Lussac)===
echo =============================================
echo =============================================
echo.
:: END OF TRANSLATION

:: Start Installation
echo %warning%

:: Step 1
echo.&echo %step1%
:: Check whether Python already installed
echo %PATH%|findstr /i "Python">NUL&&goto install-youget||goto check-python-exe

:check-python-exe
:: Check whether python-x.x.x.exe exist
for /f "delims=" %%i in ('dir /b /a:a python*.exe') do (set PythonExe-FileName=%%i&goto loop)
echo %no-python-exe%
echo %exit%
pause>NUL
exit

:loop 
echo %info-add-python-to-path1%
set /p flag=%info-add-python-to-path2%
If NOT DEFINED flag goto loop
If /i %flag%==y (goto install-python) else (goto loop)

:install-python
start /wait %PythonExe-FileName% & echo %PythonExe-FileName% %install-completed%
echo.&echo %run-bat-again%
pause>NUL
exit
:: Confirm if python is added to PATH
:: echo %PATH%|findstr /i "Python">NUl&&goto install-youget||echo %python-not-in-path%
:: echo %exit%
:: pause>NUl
:: exit

:: Step 2
:install-youget
echo Python %already-installed%
echo.&echo %step2%
echo %installing-youget%&echo.
pip3 install you-get
echo.&echo You-Get %already-installed%

:: Step 3
echo.&echo %step3%
:: Check whether ffmpeg-x.x.x.zip exist
for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do (set FFmpegZip-FileName=%%i&goto install-ffmpeg)
echo %no-ffmpeg-zip%
echo %exit%
pause>NUL
exit

:install-ffmpeg
echo %press-after-unzip%
start /wait winrar x %FFmpegZip-FileName% C:\
pause>NUL
move C:\ffmpeg* C:\ffmpeg
::setx "Path" "%Path%;C:\ffmpeg\bin" /m
setx "Path" "%Path%;C:\ffmpeg\bin"
echo FFmpeg %already-installed%

:: Step 4
echo.&echo %step4%
:: Create two quick-start batches to use and update You-Get
echo %download-bat-content% > %USERPROFILE%\Desktop\%download-bat%.bat
echo %update-bat-content%  > %USERPROFILE%\Desktop\%update-bat%.bat
::echo %download-bat-content% > %USERPROFILE%\%desktop%\%download-bat%.bat
::echo %update-bat-content%  > %USERPROFILE%\%desktop%\%update-bat%.bat
echo %create-bat-done%
echo.&echo %exit%
pause>NUL
exit