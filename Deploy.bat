@rem - Encoding:utf-8; Mode:Batch; Language:zh-CN,en; LineEndings:CRLF -
:: Video Downloaders (You-Get, Youtube-dl, Annie) One-Click Deployment Batch (Windows)
:: Author: Lussac (https://blog.lussac.net)
:: Version: 1.2.1
:: Last updated: 2019-09-21
:: >>> Get updated from: https://github.com/LussacZheng/video-downloader-deploy <<<
:: >>> EDIT AT YOUR OWN RISK. <<<
@echo off
setlocal EnableDelayedExpansion
set "version=1.2.1"
set "lastUpdated=2019-09-21"
:: Remote resources url of 'sources.txt', 'wget.exe', '7za.exe'
set "_RemoteRes_=https://raw.githubusercontent.com/LussacZheng/video-downloader-deploy/master/res"


rem ================= Preparation =================


REM mode con cols=100 lines=40

call res\scripts\LanguageSelector.bat
:: Import translation text
call res\scripts\lang_%_Language_%.bat
call res\scripts\SystemTypeSelector.bat

:: Start of Deployment
title %str_title%  -- By Lussac
:: py=python, yg=you-get, yd=youtube-dl, an=annie, ff=ffmpeg, pip=pip
set "root=%cd%"
set "pyBin=%root%\usr\python-embed"
set "ygBin=%root%\usr\you-get"
set "ydBin=%root%\usr\youtube-dl"
set "anBin=%root%\usr"
set "ffBin=%root%\usr\ffmpeg\bin"

:: If already deployed, show more info in Option3.
set "opt3_info="
if NOT exist res\deploy.log goto MENU
cd res && call :Get_DeployMode
if "%DeployMode%"=="portable" set "opt3_info=(you-get,youtube-dl,annie)"
if "%DeployMode%"=="quickstart" set "opt3_info=(you-get)"
if "%DeployMode%"=="withpip" set "opt3_info=(you-get,youtube-dl,annie)"


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
echo ==========  version: %version% (%lastUpdated%)  ===========
echo ====================================================
echo ====================================================
echo.
echo. & echo  [1?] %str_opt1%
        echo    ^|
        echo    ^|-- [11] %str_portable%: you-get + youtube-dl + annie
        echo    ^|        ( %str_opt11% ) 
        echo    ^|
        echo    ^|-- [12] %str_quickstart%: you-get
        echo    ^|        ( %str_opt12% )
        echo    ^|
        echo    ^|-- [13] %str_withpip%: you-get + youtube-dl + annie
        echo             ( %str_opt13% )
echo. & echo  [2] %str_opt2%
echo. & echo  [3] %str_opt3% %opt3_info%
echo. & echo  [4] %str_opt4%
echo. & echo  [5] %str_opt5%
echo. & echo  [6] %str_opt6%
echo. & echo.
echo ====================================================
set choice=0
set /p choice= %str_please-choose%
echo.
if "%choice%"=="1" goto InitDeploy
if "%choice%"=="11" goto InitDeploy-portable
if "%choice%"=="12" goto InitDeploy-quickstart
if "%choice%"=="13" goto InitDeploy-withpip
if "%choice%"=="2" goto Setup_FFmpeg
if "%choice%"=="3" goto Upgrade
if "%choice%"=="4" goto Reset_dl-bat
if "%choice%"=="5" goto Update
if "%choice%"=="6" goto Setting
echo. & echo %str_please-input-valid-num%
pause > NUL
goto MENU


rem ================= OPTION 1 =================


:InitDeploy
echo. & echo %str_please-choose-from%
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
cd .. && goto InitLog


rem ================= OPTION 12 =================


:InitDeploy-quickstart
set "DeployMode=quickstart"
call :ExitIfInit
cd res && call :Common
cd download
if NOT exist "%pyBin%" call :Setup_Python
if NOT exist "%ygBin%" call :Setup_YouGet
cd .. && goto InitLog


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
for /f "delims=" %%i in ('dir /b python*._pth') do ( set "py_pth=%%i" )
copy %py_pth% %py_pth%.bak > NUL
type NUL > %py_pth%
for /f "delims=" %%i in (%py_pth%.bak) do (
    set "py_pth_str=%%i"
    set py_pth_str=!py_pth_str:#import=import!
    echo !py_pth_str!>>%py_pth%
)
del /Q %py_pth%.bak >NUL 2>NUL

:get-pip
xcopy /Y "%root%\res\download\get-pip.py" "%pyBin%" > NUL
set "PATH=%pyBin%;%pyBin%\Scripts;%PATH%"
if "%_Region_%"=="cn" set "pip_option=--index-url=https://pypi.tuna.tsinghua.edu.cn/simple"
python get-pip.py %pip_option%
pip3 install --upgrade you-get %pip_option%
pip3 install --upgrade youtube-dl %pip_option%
echo You-Get %str_already-deploy%
echo Youtube-dl %str_already-deploy%
del /Q get-pip.py >NUL 2>NUL
cd "%root%\res" && goto InitLog


rem ================= OPTION 11-13 InitLog =================


:InitLog
call scripts\Log.bat Init %DeployMode%
cd .. && call :Create_Download-bat 1
call :_ReturnToMenu_


rem ================= OPTION 2 =================


:Setup_FFmpeg
:: Check whether FFmpeg already exists
echo %PATH% | findstr /i "ffmpeg" > NUL && goto ffmpeg-deploy-ok
if exist "%ffBin%\ffmpeg.exe" goto ffmpeg-deploy-ok

call :AskForInit
cd res && call :Common_wget
echo %str_downloading%...
call :Common_7za
call scripts\SourcesSelector.bat sources.txt ffmpeg %_Region_% %_SystemType_% download\to-be-downloaded.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\to-be-downloaded.txt -P download
cd download
for /f "delims=" %%i in ('dir /b /a:a ffmpeg*.zip') do ( set "ffZip=%%i" )
echo %str_unzipping% %ffZip% ...
7za x %ffZip% > NUL
set "ffDir=%ffZip:~0,-4%"
move %ffDir% "%root%\usr\ffmpeg" > NUL
:initlog-ffmpeg
cd .. && call scripts\Log.bat Init ffmpeg

:ffmpeg-deploy-ok
echo. & echo FFmpeg %str_already-deploy%
call :_ReturnToMenu_


rem ================= OPTION 3 =================


:Upgrade
call :AskForInit
cd res && call :Common_wget && call :Common_7za
call :Get_DeployMode
set "whetherToLog=false"
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
:: Get %_isYgLatestVersion% , %_isYdLatestVersion% , %_isAnLatestVersion%
:: from "scripts\CheckUpdate.bat". 0: false; 1: true.
call scripts\CheckUpdate.bat youget
call scripts\CheckUpdate.bat youtubedl
call scripts\CheckUpdate.bat annie
if "%_isYgLatestVersion%"=="1" if "%_isYdLatestVersion%"=="1" if "%_isAnLatestVersion%"=="1" (
    echo you-get %str_is-latestVersion%: v%ygCurrentVersion%
    echo youtube-dl %str_is-latestVersion%: %ydCurrentVersion%
    echo annie %str_is-latestVersion%: v%anCurrentVersion%
    goto upgrade_done
)
set "whetherToLog=true"
if "%_isYgLatestVersion%"=="0" call :Upgrade_YouGet
if "%_isYdLatestVersion%"=="0" call :Upgrade_YoutubeDL
if "%_isAnLatestVersion%"=="0" call :Upgrade_Annie
goto upgrade_done


:Upgrade-quickstart
call scripts\CheckUpdate.bat youget
if "%_isYgLatestVersion%"=="1" (
    echo you-get %str_is-latestVersion%: v%ygCurrentVersion%
) else (
    set "whetherToLog=true"
    call :Upgrade_YouGet
)
goto upgrade_done


:Upgrade-withpip
call scripts\CheckUpdate.bat annie
if "%_isAnLatestVersion%"=="1" (
    echo annie %str_is-latestVersion%: v%anCurrentVersion%
) else (
    set "whetherToLog=true"
    call :Upgrade_Annie
)

:: Re-create a pip3.cmd in case of the whole folder had been moved.
set "PATH=%root%\res\command;%pyBin%;%pyBin%\Scripts;%PATH%"
if NOT exist command md command
cd command
echo @"%pyBin%\python.exe" "%pyBin%\Scripts\pip3.exe" %%*> pip3.cmd
REM echo @python.exe ..\..\usr\python-embed\Scripts\pip3.exe %%*> pip3.cmd
if "%_Region_%"=="cn" set "pip_option=--index-url=https://pypi.tuna.tsinghua.edu.cn/simple"
echo pip3 install --upgrade you-get %pip_option%> upgrade_you-get.bat
echo pip3 install --upgrade youtube-dl %pip_option%> upgrade_youtube-dl.bat
:: Directly use "pip3 install --upgrade you-get" here will crash for some unknown reason.
:: So write the command into a bat and then call it.
call upgrade_you-get.bat && call upgrade_youtube-dl.bat
echo You-Get %str_already-upgraded% && echo Youtube-dl %str_already-upgraded%
cd .. && goto upgrade_done


:upgrade_done
if "%whetherToLog%"=="true" call scripts\Log.bat Upgrade %DeployMode%
echo. & echo. & echo %str_upgrade-ok%
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
cd .. && call :Create_Download-bat 0
call :_ReturnToMenu_


rem ================= OPTION 5 =================


:Update
cd res && call :Common_wget
echo %str_checking-update%...
:: Get %_isLatestVersion% from "scripts\CheckUpdate.bat". 0: false; 1: true.
call scripts\CheckUpdate.bat self
if "%_isLatestVersion%"=="1" (
    echo %str_bat-is-latest%
    echo %str_open-webpage1%...
) else (
    echo %str_bat-can-update-to% %latestVersion%
    echo %str_open-webpage2%...
)
pause > NUL
start https://github.com/LussacZheng/video-downloader-deploy
call :_ReturnToMenu_


rem ================= OPTION 6 =================


:Setting
call :AskForInit
cls
echo ====================================================
echo ===============%str_opt6-Expanded%===============
echo ====================================================
echo.
echo. & echo  [1] %str_opt6_opt1%
echo. & echo  [2] %str_opt6_opt2%
echo. & echo  [3] %str_opt6_opt3%
echo. & echo.
echo ====================================================
set opt6_choice=0
set /p opt6_choice= %str_please-choose%
echo.
if "%opt6_choice%"=="1" goto MENU
if "%opt6_choice%"=="2" goto setting_Proxy
if "%opt6_choice%"=="3" goto setting_FFmpeg
echo. & echo %str_please-input-valid-num%
call :_ReturnToSetting_

:setting_Proxy
call res\scripts\Config.bat Proxy
call :_ReturnToSetting_

:setting_FFmpeg
call res\scripts\Config.bat FFmpeg
call :_ReturnToSetting_


rem ================= FUNCTIONS =================


:_ReturnToMenu_
pause > NUL
goto MENU


:_ReturnToSetting_
pause > NUL
goto Setting


:: Please make sure that: only call :Common* when %cd% is "res\".
:Common
call :Common_wget
echo %str_downloading%...
call :Common_7za
:: %_Region_% was set in res\scripts\lang_%_Language_%.bat
call scripts\SourcesSelector.bat sources.txt %DeployMode% %_Region_% %_SystemType_% download\to-be-downloaded.txt
:: https://stackoverflow.com/questions/4686464/how-to-show-wget-progress-bar-only
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\to-be-downloaded.txt -P download
:: if exist .wget-hsts del .wget-hsts
goto :eof


:Common_wget
:: Make sure the existence of res\wget.exe
if NOT exist wget.exe (
    echo %str_downloading% "wget.exe", %str_please-wait%...
    REM :: use ^) instead of )
    REM powershell (New-Object Net.WebClient^).DownloadFile('%_RemoteRes_%/wget.exe', 'wget.exe'^)
    powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (new-object System.Net.WebClient).DownloadFile('%_RemoteRes_%/wget.exe','wget.exe')"
)
goto :eof


:Common_7za
:: Make sure the existence of res\7za.exe, res\download\7za.exe
if NOT exist 7za.exe (
    wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc %_RemoteRes_%/7za.exe
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


:Create_Download-bat
set isInInitDeploy=%~1
call res\scripts\GenerateDownloadBatch.bat %DeployMode%
echo.
echo ====================================================
if "%isInInitDeploy%"=="1" echo %str_deploy-ok%
echo %str_dl-bat-created%
echo ====================================================
goto :eof


:ExitIfInit
:: Check whether already InitDeploy,
if exist usr (
    echo. & echo %str_please-re-init%
    pause > NUL
    exit
)
goto :eof


:AskForInit
if NOT exist usr (
    echo. & echo %str_please-init%
    pause > NUL
    goto MENU
)
goto :eof


:Get_DeployMode
:: Get %DeployMode% from res\deploy.log
if exist deploy.log (
    for /f "tokens=2 delims= " %%i in ('findstr /i "DeployMode" deploy.log') do ( set "DeployMode=%%i" )
) else ( set "DeployMode=unknown" )
goto :eof


:Upgrade_YouGet
echo %str_upgrading% you-get...
:: %ygCurrentVersion% was set in res\scripts\CheckUpdate.bat :CheckUpdate_youget
del /Q download\you-get-%ygCurrentVersion%.tar.gz >NUL 2>NUL
del /Q sources.txt >NUL 2>NUL
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -c %_RemoteRes_%/sources.txt
call scripts\SourcesSelector.bat sources.txt youget %_Region_% %_SystemType_% download\to-be-downloaded.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc -i download\to-be-downloaded.txt -P download
rd /S /Q "%ygBin%" >NUL 2>NUL
cd download && call :Setup_YouGet
cd ..
echo You-Get %str_already-upgraded%
goto :eof


:Upgrade_YoutubeDL
echo %str_upgrading% youtube-dl...
:: %ydCurrentVersion% and %ydLatestVersion% were set in res\scripts\CheckUpdate.bat :CheckUpdate_youtubedl
del /Q download\youtube-dl-%ydCurrentVersion%.tar.gz >NUL 2>NUL
set "ydLatestVersion_Url=https://github.com/ytdl-org/youtube-dl/releases/download/%ydLatestVersion%/youtube-dl-%ydLatestVersion%.tar.gz"
echo %ydLatestVersion_Url%>> download\to-be-downloaded.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc %ydLatestVersion_Url% -P download
rd /S /Q "%ydBin%" >NUL 2>NUL
cd download && call :Setup_YoutubeDL
cd ..
echo You-Get %str_already-upgraded%
goto :eof


:Upgrade_Annie
echo %str_upgrading% annie...
:: %anCurrentVersion% and %anLatestVersion% were set in res\scripts\CheckUpdate.bat :CheckUpdate_annie
del /Q download\annie_%anCurrentVersion%_Windows*.zip >NUL 2>NUL
set "anLatestVersion_Url=https://github.com/iawia002/annie/releases/download/%anLatestVersion%/annie_%anLatestVersion%_Windows_%_SystemType_%-bit.zip"
echo %anLatestVersion_Url%>> download\to-be-downloaded.txt
wget -q --show-progress --progress=bar:force:noscroll --no-check-certificate -nc %anLatestVersion_Url% -P download
del /Q "%anBin%\annie.exe" >NUL 2>NUL
cd download && call :Setup_Annie
cd ..
echo Annie %str_already-upgraded%
goto :eof


rem ================= End of File =================