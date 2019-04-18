@echo off

:: For Translation
::
:: Notification
set warning=安装过程中请勿关闭本窗口!!!
set exit=按任意键退出。
set no-python-exe=未找到Python安装包。
set check-add-python-to-path1=接下来安装Python时需要先勾选"Add Python to Path"再点击"Install Now"，务必记得先勾选。
set check-add-python-to-path2=如果你已理解，输入y并回车以继续:
set python-not-in-path=环境变量未配置成功，请手动配置。
set no-ffmpeg-zip=未找到FFmpeg压缩包。
set press-after-unzip=请在解压完成后按回车键。
set install-completed=安装完成。
::
:: Procedure
set title=You-Get 一键安装脚本  -- By Lussac
set step1=1. Install Python
set step2=2. Install You-Get
set step3=3. Install FFmpeg
set step4=4. Start You-Get
::
:: Batches of download guide and update guide
set dl-guide1=下载视频的命令为：
set dl-guide2=you-get+空格+视频网址
set dl-guide3=例如：
set dl-guide4=you-get https://v.youku.com/v_show/id_aBCdefGh.html
set dl-guide5=如果你想要选择清晰度和格式，请参考官方wiki： https://github.com/soimort/you-get/wiki/中文说明#下载视频
set up-guide1=当前版本：
set up-guide2=正在更新...
set up-guide3=更新完成，已是最新版本。
::
set download-bat=You-Get下载视频
set update-bat=You-Get检查更新
set create-bat-done=已在桌面创建You-Get启动脚本"%download-bat%"和更新脚本"%update-bat%"。
set download-bat-content=start cmd /k "title %download-bat%&&echo %dl-guide1%&&echo %dl-guide2%&&echo %dl-guide3%&&echo %dl-guide4%&&echo.&&echo %dl-guide5%"
set update-bat-content=start cmd /k "title %update-bat%&&echo %up-guide1%&&you-get -V&&echo %up-guide2%&&pip install --upgrade you-get&&echo %up-guide3%&&echo %exit%&&pause>NUl&&exit"  


:: Start Installation

title %title%
echo %step1%

:: Check whether Python already installed
echo %PATH%|findstr /i "Python">NUl&&goto install-youget||goto check-python-exe

:check-python-exe
:: Confirm if python-x.x.x.exe exist
for /f "delims=" %%i in ('dir /b /a:a python*.exe') do (set PythonExe-FileName=%%i&goto install-python)
echo %no-python-exe%
echo %exit%
pause>NUl
exit

:install-python
echo %warning%
:loop 
echo %check-add-python-to-path1%
set /p flag=%check-add-python-to-path2%
If /i %flag%==y (goto install-python-y) else (goto loop)
:install-python-y
start /wait %PythonExe-FileName% & echo %PythonExe-FileName% %install-completed%

:: Confirm if python is added to PATH
echo %PATH%|findstr /i "Python">NUl&&goto install-youget||echo %python-not-in-path%
echo %exit%
pause>NUl
exit


echo %step2%

:install-youget
echo Python installed.
pip3 install you-get


echo %step3%

:: Confirm if ffmpeg-x.x.x.zip exist
for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do (set FFmpegZip-FileName=%%i&goto install-ffmpeg)
echo %no-ffmpeg-zip%
echo %exit%
pause>NUl
exit

:install-ffmpeg
echo %press-after-unzip%
start /wait winrar x %FFmpegZip-FileName% C:\
pause>NUl
move C:\ffmpeg* C:\ffmpeg
setx "Path" "%Path%;C:\ffmpeg\bin" /m


echo %step4%

:: Create two batch to open cmd window for starting and update You-Get
echo %download-bat-content% > %USERPROFILE%\Desktop\%download-bat%.bat
echo %update-bat-content%  > %USERPROFILE%\Desktop\%update-bat%.bat
echo %create-bat-done%
echo %exit%
pause>NUl
exit