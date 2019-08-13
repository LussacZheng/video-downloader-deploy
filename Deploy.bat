@rem - Encoding:utf-8; Mode:Batch; Language:zh-CN,en; LineEndings:CRLF -
:: Video Downloaders (You-Get, Youtube-dl, Annie) One-click Deployment Batch (Windows)
:: Author: Lussac (https://blog.lussac.net)
:: Version: 1.0.0
:: Last updated: 2019-08-13
:: >>> Get updated from: https://github.com/LussacZheng/video-downloader-deploy <<<
:: >>> EDIT AT YOUR OWN RISK. <<<
@echo off
setlocal EnableDelayedExpansion
set version=1.0.0
set lastUpdated=2019-08-13
set res=https://raw.githubusercontent.com/LussacZheng/video-downloader-deploy/master/res


rem ================= Preparation =================


REM mode con cols=100 lines=40

call res\scripts\LanguageSelector.bat
:: Import translation text
call res\scripts\lang_%_lang_%.bat
call res\scripts\SystemTypeSelector.bat

:: Start of Deployment
title %str_title%  -- By Lussac
:: py=python, yg=you-get, yd=youtube-dl, an=annie, ff=ffmpeg 
set "root=%cd%"
set "pyBin=%root%\usr\python-embed"
set "ygBin=%root%\usr\you-get"
set "ydBin=%root%\usr\youtube-dl"
set "anBin=%root%\usr"
set "ffBin=%root%\usr\ffmpeg\bin"


rem ================= Menu =================


:MENU
cd "%root%"
cls
echo ====================================================
echo ====================================================
echo ======%str_titleExpanded%=======
echo ====================================================
echo ===================  By Lussac  ====================
echo ====================================================
echo ==========  Version: %version% (%lastUpdated%)  ===========
echo ====================================================
echo ====================================================
echo.
echo.&echo  %str_opt1%
      echo    ^|
      echo    ^|-- [11] %str_portable%: you-get + youtube-dl + annie
      echo    ^|        ( %str_opt11% ) 
      echo    ^|
      echo    ^|-- [12] %str_quickstart%: you-get
      echo    ^|        ( %str_opt12% )
      echo    ^|
      echo    ^|-- [13] %str_withpip%: you-get + youtube-dl + annie
      echo              ( %str_opt13% )
echo.&echo  %str_opt2%
echo.&echo  %str_opt3%
echo.&echo  %str_opt4%
echo.&echo  %str_opt5%
echo.&echo.
echo ====================================================
set choice=0
set /p choice=%str_please-choose%
echo.
if "%choice%"=="1" goto InitDeploy
if "%choice%"=="11" goto InitDeploy-portable
if "%choice%"=="12" goto InitDeploy-quickstart
if "%choice%"=="13" goto InitDeploy-withpip
if "%choice%"=="2" goto Setup_FFmpeg
if "%choice%"=="3" goto Upgrade
if "%choice%"=="4" goto Reset_dl-bat
if "%choice%"=="5" goto Update
goto MENU


rem ================= OPTION 1 =================


:InitDeploy
echo.&echo %str_please-choose-from%
call :_ReturnToMenu_


rem ================= OPTION 11 =================


:InitDeploy-portable
set "DeployMode=portable"
call :ExitIfInit
cd res && call :Common
cd download
if NOT exist "%pyBin%" call :Setup_Python
if NOT exist "%ygBin%" call :Setup_YouGet
if NOT exist "%ydBin%" call :Setup_YoutubeDL
if NOT exist "%anBin%\annie.exe" call :Setup_Annie

:initlog-portable
cd ..
call :InitLog_Common
call :InitLog_Common_yg
call :InitLog_Common_yd
call :InitLog_Common_an
call :InitLog_Common2

call :Create_Download-bat 1
call :_ReturnToMenu_


rem ================= OPTION 12 =================


:InitDeploy-quickstart
set "DeployMode=quickstart"
call :ExitIfInit
cd res && call :Common
cd download
if NOT exist "%pyBin%" call :Setup_Python
if NOT exist "%ygBin%" call :Setup_YouGet

:initlog-quickstart
cd ..
call :InitLog_Common
call :InitLog_Common_yg
call :InitLog_Common2

call :Create_Download-bat 1
call :_ReturnToMenu_


rem ================= OPTION 13 =================


:InitDeploy-withpip
set "DeployMode=withpip"
call :ExitIfInit
cd res
if exist scripts\get-pip.py (
    if NOT exist download md download
    xcopy /Y scripts\get-pip.py download\ > NUL
)
call :Common
cd download
if NOT exist "%pyBin%" call :Setup_Python
if NOT exist "%anBin%\annie.exe" call :Setup_Annie

:edit-python_pth
cd "%pyBin%"
:: Get the full name of "python3*._pth" -> %py_pth%
for /f "delims=" %%i in ('dir /b python*._pth') do (set py_pth=%%i)
copy %py_pth% %py_pth%.bak > NUL
type nul > %py_pth%
for /f "delims=" %%i in (%py_pth%.bak) do (
    set "py_pth_str=%%i"
    set py_pth_str=!py_pth_str:#import=import!
    echo !py_pth_str!>>%py_pth%
)
del /Q %py_pth%.bak >NUL 2>NUL

:get-pip
xcopy /Y "%root%\res\download\get-pip.py" "%pyBin%" > NUL
set "PATH=%pyBin%;%pyBin%\Scripts;%PATH%"
if "%_region%"=="cn" (
    python get-pip.py --index-url=https://pypi.tuna.tsinghua.edu.cn/simple
    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade you-get
    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade youtube-dl
) else (
    python get-pip.py
    pip3 install --upgrade you-get
    pip3 install --upgrade youtube-dl
)
echo You-Get %str_already-deploy%
echo Youtube-dl %str_already-deploy%

:initlog-withpip
cd "%root%\res"
call :InitLog_Common
echo pip -V:>> init.log
pip -V >> init.log
for /f "delims=" %%i in ('dir /b "%pyBin%\Lib\site-packages\you_get*.dist-info"') do ( set "log_ygV=%%i" )
echo you-get: %log_ygV:.dist-info=%>> init.log
echo youtube-dl --version:>> init.log
youtube-dl --version >> init.log
call :InitLog_Common_an
call :InitLog_Common2

call :Create_Download-bat 1
call :_ReturnToMenu_


rem ================= OPTION 2 =================


:Setup_FFmpeg
:: Check whether FFmpeg already exists
echo %PATH%|findstr /i "ffmpeg">NUL && goto ffmpeg-deploy-ok
if exist "%ffBin%\ffmpeg.exe" goto ffmpeg-deploy-ok

call :AskForInit
cd res && call :Common_wget
echo %str_downloading%...
call :Common_7za
wget -q --no-check-certificate -nc %res%/sources_ffmpeg.txt
call scripts\MirrorSwitch.bat sources_ffmpeg %_region%
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\sources_ffmpeg-%_region%.txt -P download
cd download
for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do ( set "ffZip=%%i" )
echo %str_unzipping% %ffZip% ...
7za x %ffZip% > NUL
set ffDir=%ffZip:~0,-4%
move %ffDir% "%root%\usr\ffmpeg" > NUL

:ffmpeg-deploy-ok
echo.&echo FFmpeg %str_already-deploy%
call :_ReturnToMenu_

REM 7za x %FFmpegZip% -oC:\ -aoa > NUL
REM move C:\ffmpeg* C:\ffmpeg > NUL
REM if exist C:\ffmpeg\bin\ffmpeg.exe ( setx "Path" "%Path%;C:\ffmpeg\bin" )


rem ================= OPTION 3 =================


:Upgrade
call :AskForInit
cd res && call :Common_wget && call :Common_7za
call :Get_DeployMode
echo %str_checking-update%...
if "%DeployMode%"=="portable" goto Upgrade-portable
if "%DeployMode%"=="quickstart" goto Upgrade-quickstart
if "%DeployMode%"=="withpip" goto Upgrade-withpip

:upgrade_Manually
set opt3_choice=0
set /p opt3_choice= %str_please-set-DeployMode%
if "%opt3_choice%"=="11" ( set "DeployMode=portable" && goto Upgrade-portable )
if "%opt3_choice%"=="12" ( set "DeployMode=quickstart" && goto Upgrade-quickstart )
if "%opt3_choice%"=="13" ( set "DeployMode=withpip" && goto Upgrade-withpip )
goto upgrade_Manually


:Upgrade-portable
:: Get %_isYgLatestVersion% from "scripts\CheckUpdate_youget.bat". 0: false; 1: true.
:: Get %_isYdLatestVersion% from "scripts\CheckUpdate_youtubedl.bat". 0: false; 1: true.
:: Get %_isAnLatestVersion% from "scripts\CheckUpdate_annie.bat". 0: false; 1: true.
call scripts\CheckUpdate_youget.bat
call scripts\CheckUpdate_youtubedl.bat
call scripts\CheckUpdate_annie.bat
if "%_isYgLatestVersion%"=="1" if "%_isYdLatestVersion%"=="1" if "%_isAnLatestVersion%"=="1" (
    echo you-get %str_is-latestVersion%: v%ygCurrentVersion%
    echo youtube-dl %str_is-latestVersion%: %ydCurrentVersion%
    echo annie %str_is-latestVersion%: v%anCurrentVersion%
   goto upgrade_done
)
if "%_isYgLatestVersion%"=="0" call :Upgrade_YouGet
if "%_isYdLatestVersion%"=="0" call :Upgrade_YoutubeDL
if "%_isAnLatestVersion%"=="0" call :Upgrade_Annie
goto upgrade_done


:Upgrade-quickstart
call scripts\CheckUpdate_youget.bat
if "%_isYgLatestVersion%"=="1" (
    echo you-get %str_is-latestVersion%: v%ygCurrentVersion%
) else call :Upgrade_YouGet
goto upgrade_done


:Upgrade-withpip
call scripts\CheckUpdate_annie.bat
if "%_isAnLatestVersion%"=="1" (
    echo annie %str_is-latestVersion%: v%anCurrentVersion%
) else call :Upgrade_Annie

:: Re-create a pip3.cmd in case of the whole folder had been moved.
set "PATH=%root%\res\command;%pyBin%;%pyBin%\Scripts;%PATH%"
cd command
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\pip3.exe" %%*> pip3.cmd
REM echo @python.exe ..\..\usr\python-embed\Scripts\pip3.exe %%*> pip3.cmd
if "%_region%"=="cn" (
    echo pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade you-get> upgrade_you-get.bat
    echo pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade youtube-dl> upgrade_youtube-dl.bat
) else (
    echo pip3 install --upgrade you-get> upgrade_you-get.bat
    echo pip3 install --upgrade youtube-dl> upgrade_youtube-dl.bat
)
:: Directly use "pip3 install --upgrade you-get" here will crash for some unknown reason.
:: So write the command into a bat and then call it.
call upgrade_you-get.bat && call upgrade_youtube-dl.bat
echo You-Get %str_already-upgraded% && echo Youtube-dl %str_already-upgraded%
goto upgrade_done


:upgrade_done
echo.&echo.&echo %str_upgrade-ok%
call :_ReturnToMenu_


rem ================= OPTION 4 =================


:Reset_dl-bat
call :AskForInit
cd res && call :Get_DeployMode
if NOT "%DeployMode%"=="unknown" goto create_dl-bat

:reset_dl-bat_Manually
set opt4_choice=0
set /p opt4_choice= %str_please-set-DeployMode%
if "%opt4_choice%"=="11" ( set "DeployMode=portable" && goto create_dl-bat )
if "%opt4_choice%"=="12" ( set "DeployMode=quickstart" && goto create_dl-bat )
if "%opt4_choice%"=="13" ( set "DeployMode=withpip" && goto create_dl-bat )
goto reset_dl-bat_Manually

:create_dl-bat
call :Create_Download-bat 0
call :_ReturnToMenu_


rem ================= OPTION 5 =================


:Update
cd res && call :Common_wget
echo %str_checking-update%...
:: Get %_isLatestVersion% from "scripts\CheckUpdate.bat". 0: false; 1: true.
call scripts\CheckUpdate.bat
if %_isLatestVersion%==1 (
    echo %str_bat-is-latest%
    echo %str_open-webpage1%...
) else (
    echo %str_bat-can-update-to% %latestVersion%
    echo %str_open-webpage2%...
)
pause>NUL
start https://github.com/LussacZheng/video-downloader-deploy
call :_ReturnToMenu_


rem ================= FUNCTIONS =================


:_ReturnToMenu_
::echo.&echo.&echo %return%
pause>NUL
goto MENU


:Common
:: Please make sure that: only call this function when %cd% is "res\".
call :Common_wget
:: Make sure the existence of res\wget.exe, res\7za.exe, res\download\7za.exe
echo %str_downloading%...
call :Common_7za
:: %_region% was set in res\scripts\lang_%_lang_%.bat
call scripts\MirrorSwitch.bat sources-%DeployMode% %_region%
:: https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\sources-%DeployMode%-%_region%.txt -P download
:: if exist .wget-hsts del .wget-hsts
goto :eof


:Common_wget
:: Make sure the existence of res\wget.exe
if NOT exist wget.exe (
    echo %str_downloading% "wget.exe", %str_please-wait%...
    :: use ^) instead of )
    powershell (New-Object Net.WebClient^).DownloadFile('%res%/wget.exe', 'wget.exe'^)
)
goto :eof


:Common_7za
if NOT exist 7za.exe (
    wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc %res%/7za.exe
)
if NOT exist download\7za.exe (
    xcopy 7za.exe download\ > NUL
)
goto :eof


:Setup_Python
:: Get the full name of "python-3.x.x-embed*.zip" -> %pyZip%
for /f "delims=" %%i in ('dir /b /a:a python*embed*.zip') do ( set "pyZip=%%i" )
echo %str_unzipping% %pyZip%...
:: https://superuser.com/questions/331148/7-zip-command-line-extract-silently-quietly
7za x %pyZip% -o"%pyBin%" > NUL
echo Python-embed %str_already-deploy%
goto :eof


:Setup_YouGet
for /f "delims=" %%i in ('dir /b /a:a you-get*.tar.gz') do ( set "ygZip=%%i" )
echo %str_unzipping% %ygZip%...
:: https://superuser.com/questions/80019/how-can-i-unzip-a-tar-gz-in-one-step-using-7-zip
7za x %ygZip% -so | 7za x -aoa -si -ttar > NUL
set ygDir=%ygZip:~0,-7%
move %ygDir% "%ygBin%" > NUL
echo You-Get %str_already-deploy%
goto :eof


:Setup_YoutubeDL
for /f "delims=" %%i in ('dir /b /a:a youtube-dl*.tar.gz') do ( set "ydZip=%%i" )
echo %str_unzipping% %ydZip%...
7za x %ydZip% -so | 7za x -aoa -si -ttar > NUL
set ydDir=youtube-dl
move %ydDir% "%ydBin%" > NUL
echo Youtube-dl %str_already-deploy%
goto :eof


:Setup_Annie
for /f "delims=" %%i in ('dir /b /a:a annie*Windows*.zip') do ( set "anZip=%%i" )
echo %str_unzipping% %anZip%...
7za x %anZip% -o"%anBin%" > NUL
echo Annie %str_already-deploy%
goto :eof


:InitLog_Common
echo initialized: true> init.log
echo deployMode: %DeployMode%>> init.log
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do set LDT=%%a
set "formatedDateTime=%LDT:~0,4%-%LDT:~4,2%-%LDT:~6,2% %LDT:~8,2%:%LDT:~10,2%:%LDT:~12,2%"
echo time: %formatedDateTime%>> init.log
::echo time: %date:~0,10% %time:~0,8%>> init.log
echo pyZip: %pyZip%>> init.log
echo pyBin: "%pyBin%">> init.log
goto :eof


:InitLog_Common_yg
echo ygZip: %ygZip%>> init.log
echo ygBin: "%ygBin%">> init.log
goto :eof
:InitLog_Common_yd
echo ydZip: %ydZip%>> init.log
echo ydBin: "%ydBin%">> init.log
goto :eof
:InitLog_Common_an
echo anZip: %anZip%>> init.log
echo anBin: "%anBin%">> init.log
goto :eof
:InitLog_Common2
echo.>> init.log
echo errorlevel: !errorlevel!>> init.log
goto :eof


:Create_Download-bat
set isInInitDeploy=%~1
if exist scripts\Download-%DeployMode%.bat (
    copy /Y scripts\Download-%DeployMode%.bat ..\%str_dl-bat%.bat > NUL
) else (
    echo %str_fileLost%
)
echo.
echo =============================================
if "%isInInitDeploy%"=="1" echo %str_deploy-ok%
echo %str_dl-bat-created%
echo =============================================
goto :eof


:ExitIfInit
:: Check whether already InitDeploy,
if exist usr (
    echo.&echo %str_please-re-init%
    pause>NUL
    exit
)
goto :eof


:AskForInit
if NOT exist usr (
    echo.&echo %str_please-init%
    pause>NUL
    goto MENU
)
goto :eof


:Get_DeployMode
:: Get %DeployMode% from res\init.log
if exist init.log (
    for /f "tokens=2 delims= " %%i in ('findstr /i "deployMode" init.log') do ( set "DeployMode=%%i" )
) else ( set "DeployMode=unknown" )
goto :eof


:Upgrade_YouGet
echo %str_upgrading% you-get...
del /Q download\you-get*.tar.gz >NUL 2>NUL
del /Q sources_youget.txt >NUL 2>NUL
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc %res%/sources_youget.txt
call scripts\MirrorSwitch.bat sources_youget %_region%
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\sources_youget-%_region%.txt -P download
rd /S /Q "%ygBin%" >NUL 2>NUL
cd download && call :Setup_YouGet
cd ..
echo You-Get %str_already-upgraded%
goto :eof


:Upgrade_YoutubeDL
echo %str_upgrading% youtube-dl...
del /Q download\youtube-dl*.tar.gz >NUL 2>NUL
:: %ydLatestVersion% was set in res\scripts\CheckUpdate_youtubedl.bat
set "ydLatestVersion_Url=https://github.com/ytdl-org/youtube-dl/releases/download/%ydLatestVersion%/youtube-dl-%ydLatestVersion%.tar.gz"
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc %ydLatestVersion_Url% -P download
rd /S /Q "%ydBin%" >NUL 2>NUL
cd download && call :Setup_YoutubeDL
cd ..
echo You-Get %str_already-upgraded%
goto :eof


:Upgrade_Annie
echo %str_upgrading% annie...
del /Q download\annie*.zip >NUL 2>NUL
:: %anLatestVersion% was set in res\scripts\CheckUpdate_annie.bat
set "anLatestVersion_Url=https://github.com/iawia002/annie/releases/download/%anLatestVersion%/annie_%anLatestVersion%_Windows_%_SystemType_%-bit.zip"
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc %anLatestVersion_Url% -P download
del /Q "%anBin%\annie.exe" >NUL 2>NUL
cd download && call :Setup_Annie
cd ..
echo Annie %str_already-upgraded%
goto :eof


rem ================= End of File =================