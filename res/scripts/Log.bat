@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
:: Used for "Deploy.bat" in :InitLog & :Setup_FFmpeg & :upgrade_done
:: Please make sure that: only call this batch when %cd% is "res\".
:: e.g. 
:: call scripts\Log.bat Init portable
:: call scripts\Log.bat Upgrade withpip

@echo off
setlocal EnableDelayedExpansion
set "log_File=deploy.log"
set "log_Type=%~1"
set "log_DeployMode=%~2"
call :Log_%log_Type%-%log_DeployMode%
goto :eof


rem ================= Log Modes =================


:: py=python, yg=you-get, yd=youtube-dl, an=annie, ff=ffmpeg, pip=pip
:Log_Init-portable
call :Log_init
call :Log_py
call :Log_yg
call :Log_yd
call :Log_an
call :Log_common
goto :eof


:Log_Init-quickstart
call :Log_init
call :Log_py
call :Log_yg
call :Log_common
goto :eof


:Log_Init-withpip
call :Log_init
call :GetPackagesInfo
echo pipVer: %log_pipVer%>> %log_File%
echo ygVer: %log_ygVer%>> %log_File%
echo ydVer: %log_ydVer%>> %log_File%
call :Log_an
call :Log_common
goto :eof


:Log_Init-ffmpeg
call :Log_time
call :Log_ff
call :Log_common
goto :eof


:: %ygCurrentVersion%, %ydLatestVersion%, %anLatestVersion% were set in res\scripts\CheckUpdate.bat :CheckUpdate_*
:Log_Upgrade-portable
call :Log_time
echo ygVer: %ygLatestVersion%>> %log_File%
echo ydVer: %ydLatestVersion%>> %log_File%
echo anVer: %anLatestVersion%>> %log_File%
call :Log_common
goto :eof


:Log_Upgrade-quickstart
call :Log_time
echo ygVer: %ygLatestVersion%>> %log_File%
call :Log_common
goto :eof


:Log_Upgrade-withpip
call :Log_time
call :GetPackagesInfo
echo pipVer: %log_pipVer%>> %log_File%
echo ygVer: %log_ygVer%>> %log_File%
echo ydVer: %log_ydVer%>> %log_File%
echo anVer: %anLatestVersion%>> %log_File%
call :Log_common
goto :eof


rem ================= FUNCTIONS =================


:GetDateTime
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do ( set "LDT=%%a" )
set "formatedDateTime=%LDT:~0,4%-%LDT:~4,2%-%LDT:~6,2% %LDT:~8,2%:%LDT:~10,2%:%LDT:~12,2%"
goto :eof

:GetPackagesInfo
for /f "tokens=2 delims= " %%i in ('pip -V') do ( set "log_pipVer=%%i" )
for /f "tokens=2 delims=-" %%i in ('dir /b "%pyBin%\Lib\site-packages\you_get*.dist-info"') do ( set "log_ygVer=%%i" )
set "log_ygVer=%log_ygVer:.dist=%"
for /f "delims=" %%i in ('youtube-dl --version') do ( set "log_ydVer=%%i" )
goto :eof

:Log_init
echo Initialized: true> %log_File%
echo DeployMode: %log_DeployMode%>> %log_File%
echo.>> %log_File%
call :Log_time
goto :eof

:Log_time
echo ----- %log_Type% ----->> %log_File%
echo.>> %log_File%
call :GetDateTime
echo time: %formatedDateTime%>> %log_File%
:: echo time: %date:~0,10% %time:~0,8%>> %log_File%
echo.>> %log_File%
goto :eof

:Log_common
echo.>> %log_File%
echo errorlevel: !errorlevel!>> %log_File%
echo.>> %log_File%
goto :eof

:Log_py
echo pyZip: %pyZip%>> %log_File%
echo pyBin: "%pyBin%">> %log_File%
goto :eof

:Log_yg
echo ygZip: %ygZip%>> %log_File%
echo ygBin: "%ygBin%">> %log_File%
goto :eof

:Log_yd
echo ydZip: %ydZip%>> %log_File%
echo ydBin: "%ydBin%">> %log_File%
goto :eof

:Log_an
echo anZip: %anZip%>> %log_File%
echo anBin: "%anBin%">> %log_File%
goto :eof

:Log_ff
echo ffZip: %ffZip%>> %log_File%
echo anBin: "%ffBin%">> %log_File%
goto :eof


rem ================= End of File =================