rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: You-Get Install Batch
:: Author: Lussac
:: Version: 0.2.1
:: Last updated: 2019/06/02
:: https://blog.lussac.net
@echo off
set version=0.2.1
set date=2019/06/02

:: START OF TRANSLATION
title You-Get Install Batch  -- By Lussac
:: Notification
set warning==DON'T close this window during Installation=
set no-python-exe=Python installation package NOT found.
set info-add-python-to-path1=When installing Python, check "Add Python to PATH" firstly and then click "Install Now / Customize installation". Be sure to check it first.
set info-add-python-to-path2=If you understand, input 'y' and press Enter to continue:
set no-ffmpeg-zip=FFmpeg zip file NOT found.
set already-installed=already installed.
set no-unzip-exe="unzip.exe" NOT found.
:: Procedure
set exit=Press any key to exit.
set run-bat-again=Please close this window and run the install_en-latest.bat AGAIN.
set please-wait=It takes some time to install or unzip, please be patient...
set step1=1. Install Python
set step2=2. Install You-Get
set step3=3. Install FFmpeg
set step4=4. Start You-Get
set opening=Opening
set installing-youget=Installing You-Get...
set unzipping=Unzipping
:: Guides of download and upgrade batches
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
:: Contents of download and upgrade batches
set download-bat=You-Get_Download_video
set upgrade-bat=You-Get_Check_for_upgrading
set create-bat-done=The You-Get starting batch "%download-bat%" and upgrading batch "%upgrade-bat%" has been created on the Desktop.
set download-bat-content=start cmd /k "title %download-bat%&&echo %dl-guide1%&&echo %dl-guide2%&&echo.&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%&&echo.&&echo %dl-guide6%&&echo %dl-guide7%"
set upgrade-bat-content=start cmd /k "title %upgrade-bat%&&echo %up-guide1%&&you-get -V&&echo.&&echo %up-guide2%&&python -m pip install --upgrade pip&&pip install --upgrade you-get&&echo.&&echo %up-guide3%&&echo %exit%&&pause>NUL&&exit"
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