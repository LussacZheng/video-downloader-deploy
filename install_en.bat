rem - coding:utf-8; mode:batch; language: en -
:: You-Get Install Batch
:: Author: Lussac
:: Last updated: 2019/04/18
:: Version: 0.1.1
:: http://blog.lussac.net
@echo off
set version=0.1.1
set date=2019/04/18

:: START OF TRANSLATION
title You-Get Install Batch  -- By Lussac
:: Notification
set warning====Do NOT close this window when installation!!!===
set no-python-exe=Python installation package NOT found.
set info-add-python-to-path1=When installing Python, check "Add Python to PATH" firstly and then click "Install Now". Be sure to check it first.
set info-add-python-to-path2=If you understand, input 'y' and press Enter to continue:
set no-ffmpeg-zip=FFmpeg zip file NOT found.
set already-installed=already installed.
:: Procedure
set exit=Press any key to exit.
set run-bat-again=Please close this window and run the bat AGAIN !!!
set please-wait=It takes some time to install or unzip, please be patient!
set step1=1. Install Python
set step2=2. Install You-Get
set step3=3. Install FFmpeg
set step4=4. Start You-Get
set opening=Opening
set installing-youget=Installing You-Get...
set unzipng=Unzipping
:: Guides of download and update batches
set dl-guide1=The command to download a video is:
set dl-guide2=you-get+'Space'+'video url'
set dl-guide3=For example:
set dl-guide4=you-get https://www.youtube.com/watch?v=aBCdefGh
set dl-guide5=By default, you will get the video of highest quality. And the files downloaded will be saved in the directory where this batch locates.
set dl-guide6=If you want to choose the quality of video, change the directory saved in, or learn more usage of You-Get, please refer the Official wiki:
set dl-guide7=https://github.com/soimort/you-get#download-a-video
set up-guide1=Current version:
set up-guide2=Checking for upgrading...
set up-guide3=Upgrading completes. The latest version is installed.
:: Quick start batch content
set download-bat=You-Get_Download_video
set update-bat=You-Get_Check_for_upgrading
set create-bat-done=The You-Get starting batch "%download-bat%" and upgrading batch "%update-bat%" has been created on the Desktop.
set download-bat-content=start cmd /k "title %download-bat%&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo %dl-guide6%&&echo %dl-guide7%"
set update-bat-content=start cmd /k "title %update-bat%&&echo %up-guide1%&&you-get -V&&echo %up-guide2%&&pip install --upgrade you-get&&echo %up-guide3%&&echo %exit%&&pause>NUL&&exit"

:: Welcome Info
cls
echo =============================================
echo =============================================
echo ===== You-Get Install Batch (By Lussac) =====
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
echo.&echo %opening% %PythonExe-FileName%...&echo %please-wait%
start /wait %PythonExe-FileName% & echo %PythonExe-FileName% %already-installed%
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
:: Check whether ffmpeg-x.x.x.zip exist
for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do (set FFmpegZip-FileName=%%i&goto install-ffmpeg)
echo %no-ffmpeg-zip%
echo %exit%
pause>NUL
exit

:install-ffmpeg
echo %unzipng% %FFmpegZip-FileName% ...&echo %please-wait%
unzip -oq %FFmpegZip-FileName% -d C:\
move C:\ffmpeg* C:\ffmpeg
::setx "Path" "%Path%;C:\ffmpeg\bin" /m
setx "Path" "%Path%;C:\ffmpeg\bin"
echo FFmpeg %already-installed%

:: Step 4
echo.&echo %step4%
:: Create two quick-start batches to use and update You-Get
echo %download-bat-content% > %USERPROFILE%\Desktop\%download-bat%.bat
echo %update-bat-content%  > %USERPROFILE%\Desktop\%update-bat%.bat


echo %create-bat-done%
echo.&echo %exit%
pause>NUL
exit